# InCollege pipeline checks and dependency alerts

The `COBOL build and pipeline checks` workflow runs on pushes to `develop`, pull requests targeting `develop` or `main`, and manual dispatch. It runs only the pipeline automation checks under `.github/scripts/` and compiles the application using `.github/Dockerfile` with Ubuntu 22.04 and GnuCOBOL. Build and pipeline logs are preserved as workflow artifacts, and failures return a nonzero status. Application acceptance tests remain the assigned testers' responsibility; the workflow does not execute application scenarios or change tester files.

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

The `Dependabot issues` workflow runs only when a pull request targeting `main` is opened, reopened, updated, or retargeted. It checks the pull request is still open against `main` through the GitHub API before reading open Dependabot alerts. It creates one issue per alert, associates existing open issues with the pull request, and leaves closed issues closed. The workflow executes only trusted code checked out from `main`, never pull request code. Dependabot alerts themselves describe the repository's default branch; they are not a scan of the pull request's changed dependencies.

An authorized collaborator can comment `/PR-RESOLVE` on an associated issue while a linked pull request to `main` remains open. The command rechecks the commenter's access, the linked pull request, and the alert. For supported GitHub Actions alerts it creates a draft fix pull request targeting `main` and dispatches the build pipeline. It never merges; unsupported fixes require manual work. Existing legacy alert issues are associated with a main pull request when that pull request triggers the issue workflow.

Commit and push these workflows through normal team review. GitHub must have the `pull_request_target` workflow available on the repository default branch and the trusted scripts available on `main`; the issue-command workflow must also exist on the default branch. Enable GitHub Actions, allow issue writes and allow Actions to create pull requests. Local pipeline checks do not verify live repository permissions or execute GitHub events.

## Coverage

The dependency graph recognizes the GitHub Actions used by the workflows. Exact semantic action versions are used because GitHub does not generate Dependabot alerts for SHA-versioned actions. The Docker and devcontainer entries prevent automatic update PRs for those manifests; they do not turn Dependabot into an operating-system package scanner. COBOL, Ubuntu packages, and the image's contents do not have complete vulnerability coverage through Dependabot. No unsupported language manifests have been added to imply coverage.

References: [workflow permissions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#permissions), [Dependabot alert API](https://docs.github.com/en/rest/dependabot/alerts#list-dependabot-alerts-for-a-repository), [Dependabot options](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#open-pull-requests-limit), [security update settings](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configure-security-updates), and [supported dependency graph ecosystems](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems).