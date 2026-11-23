"""Verify issue-command authorization before any dependency code changes."""
import base64, unittest
from unittest.mock import Mock, patch
import resolve_dependabot_issue as resolver

class ResolutionTests(unittest.TestCase):
    def setUp(self):
        self.event = {
            "issue": {
                "number": 10, "state": "open",
                "body": "<!-- incollege-dependabot-alert:1 -->\n"
                        "<!-- incollege-main-pr:42 -->",
            },
            "comment": {
                "body": "/PR-RESOLVE", "author_association": "MEMBER",
                "user": {"login": "maintainer"},
            },
        }
        self.api = Mock(repository_url="https://api.github.com/repos/org/repo")
        self.pull_base = "main"
        self.alert = {
            "number": 1, "state": "open",
            "dependency": {"package": {"name": "actions/checkout", "ecosystem": "github-actions",}},
            "security_advisory": {"ghsa_id": "GHSA-test-test-test"},
        }
        self.api.request.side_effect = self.request

    def request(self, url, data=None, method=None):
        if url.endswith("/permission"):
            return {"permission": "write"}, None
        if url.endswith("/pulls/42"):
            return {"number": 42, "state": "open", "base": {"ref": self.pull_base}}, None
        if url.endswith("/dependabot/alerts/1"):
            return self.alert, None
        if url.endswith("/pulls") and method == "POST":
            return {"number": 100, "html_url": "https://github.com/org/repo/pull/100"}, None
        return None, None

    def assert_read_only(self):
        for call in self.api.request.call_args_list:
            self.assertLess(len(call.args), 2, "Unexpected API mutation")
            self.assertNotIn(call.kwargs.get("method"), {"POST", "PUT", "PATCH", "DELETE"})

    def test_wrong_command_or_untrusted_author_cannot_change_code(self):
        for command, association in (("please fix", "MEMBER"), ("/PR-RESOLVE", "NONE"), ("/PR-RESOLVE extra", "OWNER")):
            with self.subTest(command=command, association=association):
                self.event["comment"].update(body=command, author_association=association)
                with self.assertRaises(ValueError):
                    resolver.resolve(self.api, self.event)
                self.api.request.assert_not_called()

    def test_closed_issue_cannot_change_code(self):
        self.event["issue"]["state"] = "closed"
        with self.assertRaises(ValueError):
            resolver.resolve(self.api, self.event)
        self.api.request.assert_not_called()

    def test_read_only_collaborator_cannot_change_code(self):
        self.api.request.side_effect = None
        self.api.request.return_value = ({"permission": "read"}, None)
        with self.assertRaisesRegex(ValueError, "write access"):
            resolver.resolve(self.api, self.event)
        self.assert_read_only()

    def test_closed_main_pull_request_stops_before_any_mutation(self):
        self.api.request.side_effect = [
            ({"permission": "write"}, None),
            ({"number": 42, "state": "closed", "base": {"ref": "main"}}, None),
        ]
        with self.assertRaisesRegex(ValueError, "must still be open"):
            resolver.resolve(self.api, self.event)
        self.assert_read_only()

    def test_unsupported_ecosystem_leaves_code_untouched(self):
        self.alert["dependency"]["package"]["ecosystem"] = "docker"
        with patch.object(resolver, "existing_open_pull_request", return_value=None):
            with self.assertRaisesRegex(ValueError, "GitHub Actions alerts only"):
                resolver.resolve(self.api, self.event)
        self.assert_read_only()

    def test_authorized_command_creates_only_a_draft_for_the_pr_target(self):
        with patch.object(resolver, "existing_open_pull_request", return_value=None), \
             patch.object(resolver, "apply_action_update", return_value=("bot/dependabot-alert-1-main", 1)) as update:
            resolver.resolve(self.api, self.event)
        update.assert_called_once_with(self.api, self.alert, "main")
        mutations = [call for call in self.api.request.call_args_list if call.kwargs.get("method") == "POST"]
        pull = next(call.args[1] for call in mutations if call.args[0].endswith("/pulls"))
        self.assertTrue(pull["draft"])
        self.assertEqual(pull["base"], "main")
        self.assertFalse(any("/dispatches" in call.args[0] for call in mutations))
        self.assertFalse(any("/merge" in call.args[0] for call in self.api.request.call_args_list))

    def test_existing_draft_is_reported_without_creating_another_patch(self):
        existing = {"number": 100, "html_url": "https://github.com/org/repo/pull/100"}
        with patch.object(resolver, "existing_open_pull_request", return_value=existing), \
             patch.object(resolver, "apply_action_update") as update:
            resolver.resolve(self.api, self.event)
        update.assert_not_called()
        self.assertFalse(any(
            call.args[0].endswith("/pulls") and call.kwargs.get("method") == "POST"
            for call in self.api.request.call_args_list
        ))
        self.assertFalse(any("/tests.yml/dispatches" in call.args[0] for call in self.api.request.call_args_list))

    def test_develop_issue_creates_a_draft_targeting_develop(self):
        self.pull_base = "develop"
        self.event["issue"]["body"] = ("<!-- incollege-dependabot-alert:1 -->\n<!-- incollege-pr:42 -->")
        with patch.object(resolver, "existing_open_pull_request", return_value=None), \
             patch.object(resolver, "apply_action_update", return_value=("bot/dependabot-alert-1-develop", 1)) as update:
            resolver.resolve(self.api, self.event)
        update.assert_called_once_with(self.api, self.alert, "develop")
        pull = next(call.args[1] for call in self.api.request.call_args_list
                    if call.args[0].endswith("/pulls") and call.kwargs.get("method") == "POST")
        self.assertEqual(pull["base"], "develop")

    def test_existing_legacy_branch_is_found_without_creating_another_draft(self):
        existing = {"number": 100, "html_url": "https://github.com/org/repo/pull/100"}
        with patch.object(resolver, "existing_open_pull_request", side_effect=[None, existing]) as find, \
             patch.object(resolver, "apply_action_update") as update:
            resolver.resolve(self.api, self.event)
        self.assertEqual(
            [call.args[1] for call in find.call_args_list],
            ["bot/dependabot-alert-1-main", "bot/dependabot-alert-1"],
        )
        update.assert_not_called()

    def test_new_fix_branches_are_distinct_for_each_target(self):
        for branch in ("develop", "main"):
            with self.subTest(branch=branch):
                api = Mock(repository_url="https://api.github.com/repos/org/repo")
                source = b"steps:\n  - uses: actions/checkout@v1\n"
                api.request.side_effect = [
                    ({"content": base64.b64encode(source).decode()}, None),
                    ({"object": {"sha": "base-sha"}}, None),
                    (None, None), ({"sha": "file-sha"}, None), (None, None),
                ]
                item = {
                    "number": 1,
                    "dependency": {"package": {"name": "actions/checkout", "ecosystem": "github-actions"}, "manifest_path": ".github/workflows/tests.yml"},
                    "security_vulnerability": {"vulnerable_version_range": "< 2", "first_patched_version": {"identifier": "2"}},
                }
                name, changed = resolver.apply_action_update(api, item, branch)
                self.assertEqual((name, changed), (f"bot/dependabot-alert-1-{branch}", 1))
                create_ref, update_file = api.request.call_args_list[2], api.request.call_args_list[4]
                self.assertEqual(create_ref.args[1]["ref"], f"refs/heads/{name}")
                self.assertEqual(update_file.args[1]["branch"], name)
                self.assertIn(b"actions/checkout@v2", base64.b64decode(update_file.args[1]["content"]))

if __name__ == "__main__":
    unittest.main()