"""Verify issue-command authorization before any dependency code changes."""
import unittest
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
            return {"number": 42, "state": "open", "base": {"ref": "main"}}, None
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

    def test_authorized_command_creates_only_a_draft_and_dispatches_checks(self):
        with patch.object(resolver, "existing_open_pull_request", return_value=None), \
             patch.object(resolver, "apply_action_update", return_value=("bot/dependabot-alert-1", 1)) as update:
            resolver.resolve(self.api, self.event)
        update.assert_called_once_with(self.api, self.alert, "main")
        mutations = [call for call in self.api.request.call_args_list if call.kwargs.get("method") == "POST"]
        pull = next(call.args[1] for call in mutations if call.args[0].endswith("/pulls"))
        self.assertTrue(pull["draft"])
        self.assertEqual(pull["base"], "main")
        self.assertTrue(any("/tests.yml/dispatches" in call.args[0] for call in mutations))
        self.assertFalse(any("/merge" in call.args[0] for call in self.api.request.call_args_list))

    def test_existing_draft_is_retested_without_creating_another_patch(self):
        existing = {"number": 100, "html_url": "https://github.com/org/repo/pull/100"}
        with patch.object(resolver, "existing_open_pull_request", return_value=existing), \
             patch.object(resolver, "apply_action_update") as update:
            resolver.resolve(self.api, self.event)
        update.assert_not_called()
        self.assertFalse(any(
            call.args[0].endswith("/pulls") and call.kwargs.get("method") == "POST"
            for call in self.api.request.call_args_list
        ))
        self.assertTrue(any(
            "/tests.yml/dispatches" in call.args[0] for call in self.api.request.call_args_list
        ))

if __name__ == "__main__":
    unittest.main()