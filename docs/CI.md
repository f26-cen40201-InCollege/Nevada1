# InCollege pipeline checks and dependency alerts

The `COBOL build and pipeline checks` workflow runs for pull requests targeting `develop` or `main`, including when a PR is retargeted to one of those branches. It compiles the application using `.github/Dockerfile` with Ubuntu 22.04 and GnuCOBOL, and executes 19 isolated messaging acceptance checks against the compiled program. Build logs, check logs, and per-run input/output evidence are preserved as workflow artifacts, and failures return a nonzero status. Assigned testers continue to own their scenario fixtures and submission archives.

Run the pipeline checks locally:

```bash
docker build --file .github/Dockerfile --tag incollege-ci .
docker run --rm --network none incollege-ci python3 -B /opt/incollege/check_messages.py
```

## Application evidence and legacy harness

The Docker acceptance checks cover received-message formatting, exact recipient filtering, different senders, 200-character content, 125 messages, empty and missing storage, storage failures, repeated views, main-menu navigation, input exhaustion, and real send/restart/view persistence. Every application run compares standard output byte for byte with `InCollege-Output.txt`. Test storage is temporary; repository data and assigned testers' files are never overwritten.

In Actions, `test-results/` contains each run's input, console output, output file, and available account/connection/message fixtures. The container runs without network access and writes evidence as the runner's user. For local evidence, create a writable results directory and bind-mount it at `/results` with `INCOLLEGE_TEST_RESULTS=/results`, following the command in `.github/workflows/tests.yml`.

The existing `test-main.cob` harness remains available through the VS Code tasks. Before Epic 9 implementation, an isolated run of the committed harness reported **11 passed and 53 failed**. Its active scenarios and expected transcripts cover older Epic 6 behavior. These pre-existing failures require tester review; the new workflow does not claim that this historical suite passes or replace its expected files with generated output.

## Dependabot alerts

The custom workflows that mirrored Dependabot alerts into issues and responded to `/PR-RESOLVE` have been removed. They no longer create or update issues, open fix pull requests, or run as PR checks. Existing issues are not changed, and the application pipeline does not make Dependabot API calls.

GitHub's built-in dependency graph, Dependabot alerts, and security-update PRs are governed by repository and organization settings, which this change does not alter or verify. A team member with access to those settings should confirm whether alerts are enabled and monitored. The checked-in `dependabot.yml` disables configured version-update PRs; it does not disable security-update PRs.

The `pull_request_target` workflow from `main` can still run on the PR that removes it. If the old mirror check is required, a maintainer must use the team's approved process to unblock that merge and remove the obsolete check from branch protection; otherwise future PRs can remain pending.

## Coverage

The dependency graph recognizes the GitHub Actions used by the workflows. Exact semantic action versions are used because GitHub does not generate Dependabot alerts for SHA-versioned actions. The Docker and devcontainer entries prevent automatic update PRs for those manifests; they do not turn Dependabot into an operating-system package scanner. COBOL, Ubuntu packages, and the image's contents do not have complete vulnerability coverage through Dependabot. No unsupported language manifests have been added to imply coverage.

References: [Dependabot options](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#open-pull-requests-limit), [security update settings](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configure-security-updates), and [supported dependency graph ecosystems](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems).
