"""Offline checks for alert issue deduplication, pagination, and failures."""
import io, json, unittest
import dependabot_issues as sync
from contextlib import redirect_stdout
from unittest.mock import Mock, patch
from urllib.error import HTTPError

def alert(number=1):
    return {
        "number": number,
        "html_url": f"https://github.com/org/repo/security/dependabot/{number}",
        "dependency": {
            "package": {"name": "example", "ecosystem": "actions"},
            "manifest_path": ".github/workflows/tests.yml",
        },
        "security_advisory": {"severity": "high", "ghsa_id": "GHSA-test-test-test"},
        "security_vulnerability": {"vulnerable_version_range": "< 2", "first_patched_version": {"identifier": "2"}},
    }

class MirrorTests(unittest.TestCase):
    def run_sync(self, alerts, issues):
        api = Mock()
        api.paginate.side_effect = [alerts, issues]
        with redirect_stdout(io.StringIO()):
            created = sync.mirror_alerts(api, 42)
        return created, api

    def test_creates_issue_with_evidence_and_no_patch(self):
        created, api = self.run_sync([alert()], [])
        self.assertEqual(created, 1)
        title, body = api.create_issue.call_args.args
        self.assertIn("Dependabot #1", title)
        self.assertIn("<!-- incollege-dependabot-alert:1 -->", body)
        self.assertIn("First patched version: `2`", body)
        self.assertIn("/PR-RESOLVE", body)
        self.assertIn("<!-- incollege-main-pr:42 -->", body)

    def test_open_and_closed_issues_prevent_duplicates(self):
        for state in ("open", "closed"):
            with self.subTest(state=state):
                created, api = self.run_sync([alert()], [{"number": 10, "state": state, "body": "<!-- incollege-dependabot-alert:1 -->"}])
                self.assertEqual(created, 0)
                api.create_issue.assert_not_called()
                if state == "open":
                    self.assertIn("<!-- incollege-main-pr:42 -->", api.request.call_args.args[1]["body"])
                else:
                    api.request.assert_not_called()

    def test_pull_request_marker_does_not_suppress_issue(self):
        created, _ = self.run_sync([alert()], [{"pull_request": {}, "body": "<!-- incollege-dependabot-alert:1 -->"}])
        self.assertEqual(created, 1)

    def test_duplicate_alert_does_not_create_two_issues(self):
        created, api = self.run_sync([alert(), alert()], [{"body": None}])
        self.assertEqual(created, 1)
        api.create_issue.assert_called_once()

    def test_empty_alerts(self):
        created, api = self.run_sync([], [])
        self.assertEqual(created, 0)
        api.create_issue.assert_not_called()

    def test_create_error_propagates(self):
        api = Mock()
        api.paginate.side_effect = [[alert()], []]
        api.create_issue.side_effect = RuntimeError("denied")
        with self.assertRaisesRegex(RuntimeError, "denied"):
            sync.mirror_alerts(api, 42)

    def test_no_patched_version(self):
        item = alert()
        item["security_vulnerability"]["first_patched_version"] = None
        _, api = self.run_sync([item], [])
        self.assertIn("not available", api.create_issue.call_args.args[1])

class MainPullRequestTests(unittest.TestCase):
    def setUp(self):
        self.api = Mock(repository_url="https://api.github.com/repos/org/repo")
        self.pull = {"number": 42, "state": "open", "base": {"ref": "main"}}
        self.event = {"action": "opened", "pull_request": self.pull.copy()}
        self.api.request.return_value = (self.pull.copy(), None)

    def test_accepts_open_main_pr_after_api_recheck(self):
        self.assertEqual(sync.main_pull_request(self.api, self.event, "pull_request_target"), 42)

    def test_rejects_feature_or_develop_events(self):
        for event_name, base in (("push", "main"), ("pull_request_target", "develop")):
            with self.subTest(event_name=event_name, base=base):
                event = {"action": "opened", "pull_request": {**self.pull, "base": {"ref": base}}}
                with self.assertRaises(ValueError):
                    sync.main_pull_request(self.api, event, event_name)

    def test_rejects_pr_retargeted_or_closed_before_sync(self):
        for current in ({**self.pull, "state": "closed"}, {**self.pull, "base": {"ref": "develop"}}):
            with self.subTest(current=current):
                self.api.request.return_value = (current, None)
                with self.assertRaises(ValueError):
                    sync.main_pull_request(self.api, self.event, "pull_request_target")

    def test_resolution_requires_linked_open_main_pr(self):
        import resolve_dependabot_issue as resolver
        issue = {"body": "<!-- incollege-main-pr:42 -->"}
        self.assertEqual(resolver.require_linked_main_pull_request(self.api, issue), 42)
        self.api.request.return_value = ({**self.pull, "state": "closed"}, None)
        with self.assertRaises(ValueError):
            resolver.require_linked_main_pull_request(self.api, issue)
        with self.assertRaises(ValueError):
            resolver.require_linked_main_pull_request(self.api, {"body": "no link"})

class APITests(unittest.TestCase):
    def setUp(self):
        self.api = sync.GitHubAPI("test-token", "org/repo")

    def test_follows_all_pagination_pages(self):
        next_page = "https://api.github.com/repos/org/repo/dependabot/alerts?after=cursor"
        self.api.request = Mock(side_effect=[([alert()], next_page), ([alert(2)], None)])
        records = self.api.paginate("dependabot/alerts?state=open&per_page=100")
        self.assertEqual([record["number"] for record in records], [1, 2])
        self.assertEqual(self.api.request.call_args.args[0], next_page)

    def test_cycle_is_an_error(self):
        self.api.request = Mock(return_value=([], "https://api.github.com/repos/org/repo/issues"))
        with self.assertRaisesRegex(RuntimeError, "repeated"):
            self.api.paginate("issues")

    def test_unexpected_response_is_an_error(self):
        self.api.request = Mock(return_value=({"error": "denied"}, None))
        with self.assertRaisesRegex(RuntimeError, "not a list"):
            self.api.paginate("issues")

    def test_http_error_is_an_error_not_an_empty_scan(self):
        with patch.object(sync, "open_api_request", side_effect=HTTPError("https://api.github.com", 403, "denied", {}, None)):
            with self.assertRaisesRegex(RuntimeError, "HTTP 403"):
                self.api.request("https://api.github.com/repos/org/repo/issues")

    def test_link_header_and_authentication(self):
        response = Mock()
        response.read = Mock(return_value=json.dumps([alert()]).encode())
        response.headers = {"Link": '<https://api.github.com/next?after=1>; rel="next", <https://api.github.com/prev>; rel="prev"'}
        response.__enter__ = Mock(return_value=response)
        response.__exit__ = Mock(return_value=False)
        with patch.object(sync, "open_api_request", return_value=response) as opened:
            records, next_url = self.api.request("https://api.github.com/repos/org/repo/issues")
        self.assertEqual(len(records), 1)
        self.assertEqual(next_url, "https://api.github.com/next?after=1")
        self.assertEqual(opened.call_args.args[0].get_header("Authorization"), "Bearer test-token")

    def test_cross_origin_pagination_rejected_before_request(self):
        with patch.object(sync, "open_api_request") as opened:
            with self.assertRaisesRegex(ValueError, "origin"):
                self.api.request("https://attacker.invalid/page")
            opened.assert_not_called()

    def test_redirects_cannot_forward_authorization(self):
        request = sync.Request(
            "https://api.github.com/repos/org/repo/issues", headers={"Authorization": "Bearer test-token"}
        )
        for target in ("https://attacker.invalid/page", "https://api.github.com/moved"):
            with self.subTest(target=target):
                with self.assertRaisesRegex(RuntimeError, "redirect rejected"):
                    sync.RejectRedirects().redirect_request(request, None, 302, "Found", {}, target)

    def test_transport_installs_redirect_rejection(self):
        request = sync.Request("https://api.github.com/repos/org/repo/issues")
        with patch.object(sync, "build_opener") as builder:
            sync.open_api_request(request, timeout=30)
        self.assertIsInstance(builder.call_args.args[0], sync.RejectRedirects)
        builder.return_value.open.assert_called_once_with(request, timeout=30)

    def test_missing_token_or_invalid_repository_rejected(self):
        for token, repo in (("", "org/repo"), ("token", "../bad/repo")):
            with self.subTest(repo=repo):
                with self.assertRaises(ValueError):
                    sync.GitHubAPI(token, repo)

    def test_main_returns_failure_when_configuration_missing(self):
        with patch.dict(sync.os.environ, {}, clear=True), patch("sys.stderr", io.StringIO()):
            self.assertEqual(sync.main(), 1)

if __name__ == "__main__":
    unittest.main()