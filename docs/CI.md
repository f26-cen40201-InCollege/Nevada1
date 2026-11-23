# InCollege pipeline checks and dependency alerts

The `COBOL build and pipeline checks` workflow runs for pull requests targeting `develop` or `main`, including when a PR is retargeted to one of those branches. It runs the pipeline automation checks under `.github/scripts/`, compiles the application using `.github/Dockerfile` with Ubuntu 22.04 and GnuCOBOL, and executes 19 isolated messaging acceptance checks against the compiled program. Build logs, check logs, and per-run input/output evidence are preserved as workflow artifacts, and failures return a nonzero status. Assigned testers continue to own their scenario fixtures and submission archives.

Run the pipeline checks locally:

```bash
python3 -B -m unittest discover -s .github/scripts -p 'test_*.py' -v
docker build --file .github/Dockerfile --tag incollege-ci .
docker run --rm --network none incollege-ci python3 -B /opt/incollege/check_messages.py
```

## Application evidence and legacy harness

The Docker acceptance checks cover received-message formatting, exact recipient filtering, different senders, 200-character content, 125 messages, empty and missing storage, storage failures, repeated views, main-menu navigation, input exhaustion, and real send/restart/view persistence. Every application run compares standard output byte for byte with `InCollege-Output.txt`. Test storage is temporary; repository data and assigned testers' files are never overwritten.

In Actions, `test-results/` contains each run's input, console output, output file, and available account/connection/message fixtures. The container runs without network access and writes evidence as the runner's user. For local evidence, create a writable results directory and bind-mount it at `/results` with `INCOLLEGE_TEST_RESULTS=/results`, following the command in `.github/workflows/tests.yml`.

The existing `test-main.cob` harness remains available through the VS Code tasks. Before Epic 9 implementation, an isolated run of the committed harness reported **11 passed and 53 failed**. Its active scenarios and expected transcripts cover older Epic 6 behavior. These pre-existing failures require tester review; the new workflow does not claim that this historical suite passes or replace its expected files with generated output.

## Dependabot setup

Dependabot alerts and security-update pull requests are separate GitHub settings. Enable the dependency graph and **Dependabot alerts**. Keep **Dependabot security updates** disabled. The checked-in `dependabot.yml` sets the version-update pull request limit to zero and ignores updates for the configured ecosystems. A zero version-update limit alone does not disable security-update pull requests. These rules leave vulnerability alerts enabled while preserving the team's issue-first approval process.

An administrator can apply the live settings with GitHub CLI after authenticating to the intended repository. Disable automatic fixes first, then enable alerts:

```bash
gh api --method DELETE repos/f26-cen40201-InCollege/Nevada1/automated-security-fixes
gh api --method PUT repos/f26-cen40201-InCollege/Nevada1/vulnerability-alerts
gh api --include repos/f26-cen40201-InCollege/Nevada1/automated-security-fixes
gh api --include repos/f26-cen40201-InCollege/Nevada1/vulnerability-alerts
```

Successful mutation calls return HTTP 204. After a successful disable call, the automatic-fixes check returns HTTP 404 when disabled; the alerts check should return HTTP 204. Confirm that the authenticated account still has administration access before interpreting a 404, which can also hide an inaccessible repository. Organization policies can govern these settings; confirm the repository's Settings → Advanced Security page agrees. Changes to these live settings require repository administration permission and are not applied by committing configuration files.

The `Dependabot issues` workflow runs when a pull request targeting `develop` or `main` is opened, reopened, updated, or retargeted. It checks through the GitHub API that the pull request is still open against the same allowed target before reading open Dependabot alerts. It creates one issue per alert, associates existing open issues with the pull request, and leaves closed issues closed. The workflow executes only trusted code checked out from `main`, never pull request code. Dependabot alerts themselves describe the repository's default branch; they are not a scan of the pull request's changed dependencies.

The workflow requests `vulnerability-alerts: read` for its `GITHUB_TOKEN`; `security-events` is for code scanning, not Dependabot alerts. The token also needs permission to read pull requests and write issues. A 403 can come from any of these operations or a repository/organization setting. The error now identifies the API endpoint and reports GitHub's message when available. Confirm that alerts and Issues are enabled, and inspect the job's effective token permissions before changing credentials. Failed alert reads fail the job; they are not treated as an empty alert list.

If the alert endpoint still denies the workflow token, a repository administrator can create a repository-scoped fine-grained token with **Dependabot alerts: read** for this repository and save it as the Actions secret `DEPENDABOT_ALERTS_TOKEN`. The token's owner must have access to the repository's security alerts, and organization approval may be required. Both automation workflows use this optional secret only for reading Dependabot alerts; the regular `GITHUB_TOKEN` still handles pull requests and issue writes. Leave the secret unset when the workflow token already has access. Rotate the secret when needed.

For events initiated by Dependabot, GitHub applies separate rules to secrets and token permissions. Some `pull_request_target` runs have a read-only token and no secrets; see [Dependabot on GitHub Actions](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-on-actions) when diagnosing those runs.

An authorized collaborator can comment `/PR-RESOLVE` on an associated issue while a linked pull request to `develop` or `main` remains open. The command rechecks the commenter's access, the linked pull request, and the alert. For supported GitHub Actions alerts it creates a draft fix pull request targeting the linked PR's branch. If several linked PRs are open, it uses the one with the lowest PR number. It never merges; unsupported fixes require manual work. Existing legacy alert issues and draft branches remain supported.

GitHub creates the normal PR check run for a draft opened using `GITHUB_TOKEN`; that run may require a maintainer's approval. For an existing draft, rerun its PR checks from GitHub if needed. The command no longer dispatches checks for a branch without a PR.

Commit and push these workflows through normal team review. GitHub must have the `pull_request_target` workflow available on the repository default branch and the trusted scripts available on `main`; the issue-command workflow must also exist on the default branch. Changes to those trusted files take effect after they reach the default branch, including for PRs targeting `develop`. Enable GitHub Actions, allow issue writes and allow Actions to create pull requests. Local pipeline checks do not verify live repository permissions or execute GitHub events.

The PR that introduces these changes to `main` still runs the old trusted workflow. If its required alert check fails, an administrator must restore the existing workflow's access or use the team's approved exception process to unblock that initial merge. After the changes reach `main`, open, update, or retarget a PR to trigger a new run with the updated workflow.

## Coverage

The dependency graph recognizes the GitHub Actions used by the workflows. Exact semantic action versions are used because GitHub does not generate Dependabot alerts for SHA-versioned actions. The Docker and devcontainer entries prevent automatic update PRs for those manifests; they do not turn Dependabot into an operating-system package scanner. COBOL, Ubuntu packages, and the image's contents do not have complete vulnerability coverage through Dependabot. No unsupported language manifests have been added to imply coverage.

References: [workflow permissions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#permissions), [Dependabot alert API](https://docs.github.com/en/rest/dependabot/alerts#list-dependabot-alerts-for-a-repository), [Dependabot options](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#open-pull-requests-limit), [security update settings](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configure-security-updates), and [supported dependency graph ecosystems](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems).