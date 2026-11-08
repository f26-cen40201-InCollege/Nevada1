# InCollege pipeline checks and dependency alerts

The `COBOL build and pipeline checks` workflow runs on pushes, pull requests, and manual dispatch. It runs only the pipeline automation checks under `.github/scripts/` and compiles the application using `.github/Dockerfile` with Ubuntu 22.04 and GnuCOBOL. Build and pipeline logs are preserved as workflow artifacts, and failures return a nonzero status. Application acceptance tests remain the assigned testers' responsibility; the workflow does not execute application scenarios or change tester files.

Run the pipeline checks locally:

```bash
python3 -B -m unittest discover -s .github/scripts -p 'test_*.py' -v
docker build --file .github/Dockerfile --tag incollege-ci .
```

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

The `Dependabot issues` workflow runs daily at 13:23 UTC and can be dispatched manually on the default branch. It reads all pages of open alerts, reads all pages of existing issues (including closed issues), and creates one issue per alert using a stable hidden marker. A manually closed issue is not reopened or duplicated. Check the linked alert's current state when resolving the issue. API errors and redirects fail the workflow instead of reporting a clean scan. Redirect rejection prevents credentials from following an unexpected location.

The scheduled `Dependabot issues` workflow uses GitHub's built-in token with `contents: read`, `issues: write`, and `vulnerability-alerts: read`; it cannot change code or create pull requests. The separate issue-command workflow runs only for a new exact `/PR-RESOLVE` comment by a repository owner, member, or collaborator, then checks that user's current repository permission is `write` or `admin`. It checks out only the trusted default branch, rechecks the alert through the API, and gives its job-scoped token only `actions: write`, `contents: write`, `issues: write`, `pull-requests: write`, and `vulnerability-alerts: read`. It does not evaluate issue text as code, run issue-provided scripts, or merge updates. GitHub runs triggered by `issue_comment` require the workflow to exist on the default branch.

Commit and push the workflows through the normal team review. Scheduled workflows and Dependabot configuration become active from the default branch. Enable GitHub Actions and allow issue writes in repository or organization policies. Run `Dependabot issues` manually once to verify the live settings and permissions. No live GitHub execution is implied by local test results.

## Coverage

The dependency graph recognizes the GitHub Actions used by the workflows. Exact semantic action versions are used because GitHub does not generate Dependabot alerts for SHA-versioned actions. The Docker and devcontainer entries prevent automatic update PRs for those manifests; they do not turn Dependabot into an operating-system package scanner. COBOL, Ubuntu packages, and the image's contents do not have complete vulnerability coverage through Dependabot. No unsupported language manifests have been added to imply coverage.

References: [workflow permissions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#permissions), [Dependabot alert API](https://docs.github.com/en/rest/dependabot/alerts#list-dependabot-alerts-for-a-repository), [Dependabot options](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#open-pull-requests-limit), [security update settings](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configure-security-updates), and [supported dependency graph ecosystems](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems).