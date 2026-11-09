#!/usr/bin/env python3
"""Mirror Dependabot alerts and support authorized issue-command remediation."""

import json, os, re, sys
from urllib.error import HTTPError, URLError
from urllib.parse import urlsplit
from urllib.request import HTTPRedirectHandler, Request, build_opener

MARKER = re.compile(r"<!-- incollege-dependabot-alert:(\d+) -->")
PR_MARKER = re.compile(r"<!-- incollege-main-pr:(\d+) -->")

class RejectRedirects(HTTPRedirectHandler):
    def redirect_request(self, request, response, code, message, headers, new_url):
        # urllib otherwise forwards Authorization headers when the host changes.
        raise RuntimeError("GitHub API redirect rejected; verify the repository URL.")

def open_api_request(request, timeout):
    return build_opener(RejectRedirects()).open(request, timeout=timeout)

class GitHubAPI:
    def __init__(self, token, repository, base_url="https://api.github.com"):
        if not token:
            raise ValueError("GITHUB_TOKEN is required")
        if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repository):
            raise ValueError("GITHUB_REPOSITORY must be owner/repository")
        self.base_url = base_url.rstrip("/")
        if urlsplit(self.base_url).scheme != "https":
            raise ValueError("The GitHub API URL must use HTTPS")
        self.repository_url = f"{self.base_url}/repos/{repository}"
        self.token = token

    def request(self, url, data=None, method=None):
        # Never send the token to an origin supplied by an unexpected Link URL.
        if urlsplit(url)[:2] != urlsplit(self.base_url)[:2]:
            raise ValueError("GitHub pagination changed API origin")
        request = Request(
            url,
            data=json.dumps(data).encode("utf-8") if data is not None else None,
            headers={
                "Authorization": f"Bearer {self.token}",
                "Accept": "application/vnd.github+json",
                "X-GitHub-Api-Version": "2026-03-10",
                "Content-Type": "application/json",
            },
            method=method or ("POST" if data is not None else "GET"),
        )
        try:
            with open_api_request(request, timeout=30) as response:
                response_body = response.read()
                payload = json.loads(response_body) if response_body else None
                link = response.headers.get("Link", "")
        except HTTPError as error:
            raise RuntimeError(
                f"GitHub API returned HTTP {error.code}; verify Dependabot "
                "alerts are enabled and workflow permissions are allowed."
            ) from error
        except URLError as error:
            raise RuntimeError("GitHub API request failed; check connectivity.") from error
        next_url = None
        for part in link.split(","):
            match = re.fullmatch(r'\s*<([^>]+)>;\s*rel="next"\s*', part)
            if match:
                next_url = match.group(1)
        return payload, next_url

    def paginate(self, path):
        url = f"{self.repository_url}/{path}"
        records = []
        visited = set()
        while url:
            if url in visited:
                raise RuntimeError("GitHub API pagination repeated a page")
            visited.add(url)
            page, url = self.request(url)
            if not isinstance(page, list):
                raise RuntimeError("GitHub API list response was not a list")
            records.extend(page)
        return records

    def create_issue(self, title, body):
        return self.request(f"{self.repository_url}/issues", {"title": title, "body": body})[0]

def inline(value):
    """Render API text as a code span without newlines or embedded backticks."""
    return "`" + str(value).replace("`", "'").replace("\r", " ").replace("\n", " ") + "`"

def main_pull_request(api, event, event_name):
    """Accept only a current, open main-targeting pull request event."""
    if event_name != "pull_request_target" or event.get("action") not in {
        "opened", "reopened", "synchronize", "edited"
    }:
        raise ValueError("Dependabot issue sync requires a pull request targeting main.")
    pull = event.get("pull_request") or {}
    number = pull.get("number")
    if isinstance(number, bool) or not isinstance(number, int) or number < 1:
        raise ValueError("The pull request number is invalid.")
    if pull.get("state") != "open" or (pull.get("base") or {}).get("ref") != "main":
        raise ValueError("The pull request must be open and target main.")
    current, _ = api.request(f"{api.repository_url}/pulls/{number}")
    if (current.get("number") != number or current.get("state") != "open"
            or (current.get("base") or {}).get("ref") != "main"):
        raise ValueError("The pull request is no longer open against main.")
    return number


def mirror_alerts(api, pull_number):
    # Fetch all pages before writes so issue creation cannot shift pagination.
    alerts = api.paginate("dependabot/alerts?state=open&per_page=100")
    issues = api.paginate("issues?state=all&per_page=100")
    existing = {}
    for issue in issues:
        if "pull_request" not in issue:
            for number in MARKER.findall(issue.get("body") or ""):
                existing.setdefault(int(number), issue)
    pr_marker = f"<!-- incollege-main-pr:{pull_number} -->"
    created = 0
    for alert in alerts:
        number = int(alert["number"])
        if number in existing:
            issue = existing[number]
            if issue.get("state") == "open" and pr_marker not in (issue.get("body") or ""):
                body = (issue.get("body") or "").rstrip() + f"\n\n{pr_marker}\nRelated main pull request: #{pull_number}."
                api.request(f"{api.repository_url}/issues/{int(issue['number'])}", {"body": body}, method="PATCH")
                issue["body"] = body
            continue
        dependency = alert["dependency"]
        advisory = alert["security_advisory"]
        vulnerability = alert["security_vulnerability"]
        package = dependency["package"]
        patched = vulnerability.get("first_patched_version") or {}
        title = (
            f"[Dependabot #{number}] {advisory['severity']}: "
            f"{package['name']} ({advisory['ghsa_id']})"
        ).replace("\n", " ").replace("\r", " ")[:240]
        body = "\n".join([
            f"<!-- incollege-dependabot-alert:{number} -->",
            pr_marker,
            f"Created for open pull request #{pull_number} targeting main.",
            "Dependabot reported a vulnerable dependency. Review this issue before starting a fix.",
            "",
            f"- Alert: {alert['html_url']}",
            f"- Advisory: {inline(advisory['ghsa_id'])}",
            f"- Severity: {inline(advisory['severity'])}",
            f"- Dependency: {inline(package['name'])} ({inline(package['ecosystem'])})",
            f"- Manifest: {inline(dependency['manifest_path'])}",
            f"- Vulnerable versions: {inline(vulnerability['vulnerable_version_range'])}",
            f"- First patched version: {inline(patched.get('identifier', 'not available'))}",
            "",
            "An authorized repository collaborator can comment /PR-RESOLVE to request a draft update pull request and rerun the pipeline.",
            "Only supported GitHub Actions version updates are automated. Unsupported alerts are reported without changing files. "
            "The bot never merges a pull request.",
            "",
            "Check the linked alert for its current status before closing this issue.",
        ])
        api.create_issue(title, body)
        existing[number] = {"state": "open", "body": body}
        created += 1
    print(f"Dependabot: {len(alerts)} open alert(s); {created} new issue(s).")
    return created

def main():
    try:
        api = GitHubAPI(
            os.environ.get("GITHUB_TOKEN", ""),
            os.environ.get("GITHUB_REPOSITORY", ""),
            os.environ.get("GITHUB_API_URL", "https://api.github.com"),
        )
        with open(os.environ["GITHUB_EVENT_PATH"], encoding="utf-8") as event_file:
            event = json.load(event_file)
        pull_number = main_pull_request(api, event, os.environ.get("GITHUB_EVENT_NAME", ""))
        mirror_alerts(api, pull_number)
    except (KeyError, OSError, ValueError, RuntimeError, TypeError) as error:
        print(f"Dependabot issue sync failed: {error}", file=sys.stderr)
        return 1
    return 0

if __name__ == "__main__":
    sys.exit(main())