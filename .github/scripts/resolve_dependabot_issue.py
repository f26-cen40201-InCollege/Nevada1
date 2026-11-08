#!/usr/bin/env python3
"""Open a draft update PR only after an authorized issue command."""

import base64
import json
import os
from pathlib import PurePosixPath
import re
import sys
from urllib.parse import quote, urlencode

from dependabot_issues import GitHubAPI

COMMAND = "/PR-RESOLVE"
MARKER = re.compile(r"<!-- incollege-dependabot-alert:(\d+) -->")
ALLOWED_ASSOCIATIONS = {"OWNER", "MEMBER", "COLLABORATOR"}


def version(value):
    match = re.fullmatch(r"v?(\d+)(?:\.(\d+))?(?:\.(\d+))?(?:\.(\d+))?", value.strip())
    if not match:
        return None
    return tuple(int(part or 0) for part in match.groups())


def in_range(candidate, version_range):
    current = version(candidate)
    if current is None or not version_range.strip():
        return None
    alternatives = version_range.split("||")
    for alternative in alternatives:
        constraints = [part.strip() for part in alternative.split(",")]
        if not all(constraints):
            return None
        satisfied = True
        for constraint in constraints:
            match = re.fullmatch(r"(<=|>=|<|>|==|=|!=)\s*(v?\d+(?:\.\d+){0,3})", constraint)
            if not match:
                return None
            target = version(match.group(2))
            if target is None:
                return None
            operator = match.group(1)
            satisfied = satisfied and {
                "<": current < target,
                "<=": current <= target,
                ">": current > target,
                ">=": current >= target,
                "=": current == target,
                "==": current == target,
                "!=": current != target,
            }[operator]
        if satisfied:
            return True
    return False


def api_url(api, path):
    return f"{api.repository_url}/{path.lstrip('/')}"


def read_event(path):
    with open(path, encoding="utf-8") as event_file:
        return json.load(event_file)


def issue_alert_number(issue):
    if "pull_request" in issue:
        raise ValueError("The command must be used on an issue, not a pull request.")
    matches = MARKER.findall(issue.get("body") or "")
    if len(matches) != 1:
        raise ValueError("This issue is not linked to one Dependabot alert.")
    return int(matches[0])


def apply_action_update(api, alert, default_branch):
    vulnerability = alert.get("security_vulnerability") or {}
    dependency = alert.get("dependency") or {}
    package = (dependency.get("package") or {}).get("name", "")
    ecosystem = (dependency.get("package") or {}).get("ecosystem", "")
    if ecosystem != "github-actions":
        raise ValueError("Automatic remediation currently supports GitHub Actions alerts only.")
    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", package):
        raise ValueError("The alert does not identify a supported owner/repository action.")

    manifest = dependency.get("manifest_path", "")
    manifest_path = PurePosixPath(manifest)
    if (manifest_path.is_absolute() or ".." in manifest_path.parts
            or not manifest.startswith(".github/workflows/")
            or manifest_path.suffix not in {".yaml", ".yml"}):
        raise ValueError("Only GitHub Actions workflow manifests are supported.")

    version_range = vulnerability.get("vulnerable_version_range", "")
    patched_value = (vulnerability.get("first_patched_version") or {}).get("identifier", "")
    patched = version(patched_value)
    if patched is None or in_range(patched_value, version_range) is not False:
        raise ValueError("The advisory has no supported first patched version.")

    query = urlencode({"ref": default_branch})
    content_url = api_url(api, f"contents/{quote(manifest, safe='/')}?{query}")
    document, _ = api.request(content_url)
    try:
        source = base64.b64decode(document["content"], validate=False).decode("utf-8")
    except (KeyError, UnicodeDecodeError, ValueError) as error:
        raise ValueError("The workflow manifest could not be read as UTF-8.") from error

    action_ref = re.compile(
        rf"^(?P<prefix>[ \t]*(?:-[ \t]+)?uses:[ \t]*{re.escape(package)}@)"
        r"(?P<ref>[^\s#]+)"
    )
    block_scalar = re.compile(
        r"^(?P<indent>[ \t]*)(?:-[ \t]+)?[A-Za-z_][\w-]*:[ \t]*[|>][+-]?(?:[ \t]+#.*)?$"
    )
    changed = 0
    unsupported = []

    def replace_vulnerable(match):
        nonlocal changed
        current_ref = match.group("ref")
        current = version(current_ref)
        affected = in_range(current_ref, version_range)
        if current is None or affected is None:
            unsupported.append(current_ref)
            return match.group(0)
        if affected:
            replacement = patched_value
            if current_ref.startswith("v") and not replacement.startswith("v"):
                replacement = "v" + replacement
            if current_ref.startswith("V") and not replacement.startswith(("v", "V")):
                replacement = "V" + replacement
            changed += 1
            return match.group("prefix") + replacement
        return match.group(0)

    updated_lines = []
    block_indent = None
    for line in source.splitlines(keepends=True):
        leading_indent = len(line) - len(line.lstrip(" \t"))
        if block_indent is not None:
            if line.strip() and leading_indent > block_indent:
                updated_lines.append(line)
                continue
            block_indent = None
        block = block_scalar.match(line.rstrip("\r\n"))
        if block:
            block_indent = len(block.group("indent"))
            updated_lines.append(line)
            continue
        match = action_ref.match(line.rstrip("\r\n"))
        updated_lines.append(action_ref.sub(replace_vulnerable, line, count=1)
                             if match else line)
    updated = "".join(updated_lines)
    if unsupported:
        raise ValueError("An action reference uses unsupported version syntax; no files were changed.")
    if changed == 0:
        raise ValueError("No vulnerable action reference matching this alert remains in the manifest.")

    ref_data, _ = api.request(api_url(api, f"git/ref/heads/{quote(default_branch, safe='/')}"))
    base_sha = ref_data["object"]["sha"]
    branch_name = f"bot/dependabot-alert-{alert['number']}"
    api.request(api_url(api, "git/refs"), {
        "ref": f"refs/heads/{branch_name}",
        "sha": base_sha,
    }, method="POST")

    existing, _ = api.request(api_url(
        api,
        f"contents/{quote(manifest, safe='/')}?{urlencode({'ref': branch_name})}",
    ))
    encoded = base64.b64encode(updated.encode("utf-8")).decode("ascii")
    api.request(api_url(api, f"contents/{quote(manifest, safe='/')}"), {
        "message": f"fix: update {package} for Dependabot alert {alert['number']}",
        "content": encoded,
        "sha": existing["sha"],
        "branch": branch_name,
    }, method="PUT")
    return branch_name, changed


def dispatch_pipeline(api, branch_name):
    api.request(api_url(api, "actions/workflows/tests.yml/dispatches"), {
        "ref": branch_name,
    }, method="POST")


def comment(api, issue_number, body):
    api.request(api_url(api, f"issues/{issue_number}/comments"), {"body": body}, method="POST")


def existing_open_pull_request(api, branch_name, default_branch):
    repository_owner = api.repository_url.rsplit("/", 2)[-2]
    query = urlencode({
        "state": "open",
        "head": f"{repository_owner}:{branch_name}",
        "base": default_branch,
        "per_page": "100",
    })
    pull_requests = api.paginate(f"pulls?{query}")
    return pull_requests[0] if pull_requests else None


def resolve(api, event):
    issue = event.get("issue") or {}
    command_comment = event.get("comment") or {}
    issue_number = int(issue.get("number", 0))
    if not issue_number or issue.get("state") != "open":
        raise ValueError("The Dependabot issue must still be open.")
    if command_comment.get("body", "").strip() != COMMAND:
        raise ValueError("Use the exact /PR-RESOLVE command on a Dependabot issue.")
    if command_comment.get("author_association") not in ALLOWED_ASSOCIATIONS:
        raise ValueError("Only repository owners, members, and collaborators can start an update.")

    commenter = command_comment.get("user") or {}
    commenter_login = commenter.get("login", "")
    if not commenter_login or not re.fullmatch(r"[A-Za-z0-9-]+", commenter_login):
        raise ValueError("The command author could not be verified.")
    permission, _ = api.request(api_url(
        api,
        f"collaborators/{quote(commenter_login, safe='')}/permission",
    ))
    if permission.get("permission") not in {"admin", "write"}:
        raise ValueError("The command author needs write access to the repository.")

    alert_number = issue_alert_number(issue)
    alert, _ = api.request(api_url(api, f"dependabot/alerts/{alert_number}"))
    if alert.get("number") != alert_number or alert.get("state") != "open":
        raise ValueError("The linked Dependabot alert is no longer open.")

    repository, _ = api.request(api.repository_url)
    default_branch = repository["default_branch"]
    branch_name = f"bot/dependabot-alert-{alert_number}"
    existing = existing_open_pull_request(api, branch_name, default_branch)
    if existing:
        dispatch_pipeline(api, branch_name)
        comment(
            api,
            issue_number,
            f"Reran the build pipeline for existing draft pull request "
            f"#{existing['number']}: {existing['html_url']}. It will not be merged automatically.",
        )
        print(f"Redispatched the pipeline for existing draft PR #{existing['number']}.")
        return

    branch_name, updated_count = apply_action_update(api, alert, default_branch)
    ghsa_id = (alert.get("security_advisory") or {}).get("ghsa_id", "Dependabot")
    package = (alert.get("dependency") or {}).get("package", {}).get("name", "dependency")
    pull_request, _ = api.request(api_url(api, "pulls"), {
        "title": f"fix: update {package} for {ghsa_id}"[:240],
        "head": branch_name,
        "base": default_branch,
        "draft": True,
        "body": (
            f"This draft updates {package} to the first patched version for "
            f"Dependabot alert #{alert_number} ({ghsa_id}).\n\n"
            f"Requested with {COMMAND} on issue #{issue_number}. "
            "The pipeline is dispatched for this branch. Review before merging."
        ),
    }, method="POST")
    dispatch_pipeline(api, branch_name)
    comment(
        api,
        issue_number,
        f"Created draft pull request #{pull_request['number']} for {updated_count} "
        f"vulnerable action reference(s): {pull_request['html_url']}. "
        f"The build pipeline has been dispatched for branch {branch_name}. "
        "The pull request will not be merged automatically.",
    )
    print(f"Created draft PR #{pull_request['number']} and dispatched the build pipeline.")


def main():
    try:
        event = read_event(os.environ["GITHUB_EVENT_PATH"])
        token = os.environ["GITHUB_TOKEN"]
        repository = os.environ["GITHUB_REPOSITORY"]
        api = GitHubAPI(token, repository, os.environ.get("GITHUB_API_URL", "https://api.github.com"))
        resolve(api, event)
    except (KeyError, ValueError, RuntimeError, TypeError) as error:
        print(f"Dependabot issue command failed: {error}", file=sys.stderr)
        try:
            event = read_event(os.environ["GITHUB_EVENT_PATH"])
            issue_number = int((event.get("issue") or {}).get("number", 0))
            if issue_number:
                api = GitHubAPI(
                    os.environ.get("GITHUB_TOKEN", ""),
                    os.environ.get("GITHUB_REPOSITORY", ""),
                    os.environ.get("GITHUB_API_URL", "https://api.github.com"),
                )
                comment(api, issue_number, f"Resolution stopped: {error} Check for an existing draft PR or bot/dependabot-alert-{issue_number} branch before retrying. The bot never merges.")
        except (KeyError, ValueError, RuntimeError, TypeError):
            pass
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
