# **SWE Semester Project**

| **`COURSE ID #`** | **`COURSE NAME`** | **`PROJECT`** |
| --- | --- | --- |
| **CEN-4020** | **SOFTWARE ENGINEERING** | **In-College Project** |

| **`TEAM MEMBER NAMES`** | **`USF EMAIL`** | **`USF ID #`** |
| --- | --- | --- |
| **Jude Joyson** | **jjoyson@usf.edu** |  |
| **Aref Khondaker** | **arefkhondaker@usf.edu** |  |
| **Tangil Khondaker** | **tangilkhondaker@usf.edu** |  |
| **Ian Koratsky** | **ikoratsk@usf.edu** |  |
| **Connor Kouznetsov** | **ckouznetsov@usf.edu** |  |

<div align="center">
  <img src="./docs/inCollege.png" alt="LinkCluster Professional Profile" width="1000">
  <p><i><strong>In-College Project Logo</strong></i></p>
</div>

## Project Overview

This repository contains the CEN-4020 Software Engineering In-College project. The application is implemented in COBOL and is organized around incremental Epics, Features, testing, and sprint-based team ownership.

The project has 10 weekly sprints and five rotating responsibilities:

`Scrum Master -> Developer 1 -> Developer 2 -> Tester 1 -> Tester 2`

See [ROLE-TRACKER.md](docs/ROLE-TRACKER.md) for the owner of each role in every sprint.

## Project Documentation

| Document | Purpose |
| --- | --- |
| [JIRA.md](docs/JIRA.md) | Jira hierarchy, sprint organization, role workflows, testing, and bug management. |
| [PROCEDURES.md](docs/PROCEDURES.md) | Weekly responsibilities and required documentation handoffs before changes. |
| [ROLE-TRACKER.md](docs/ROLE-TRACKER.md) | The 10-sprint left-to-right role rotation. |
| `tests/` | Nested Epic, tester, and scenario directories for test inputs and expected outputs. |

## Development Workflow

1. Select the assigned Jira Feature, Task, or Bug for the active sprint.
2. Before changing code or tests, document the requirement, affected files, relevant procedure, and intended validation.
3. Implement the change and update or add focused tests in the appropriate test directory.
4. Build and run the affected COBOL program, recording the exact command and result in Jira.
5. Have the assigned Tester verify the acceptance criteria and attach test evidence.
6. Close the issue only when the implementation, testing, documentation, and any linked bug work are complete.


## Tests

The test suite uses nested directories organized by Epic, tester, and scenario. COBOL test inputs and expected outputs are processed sequentially.

To add a test:

1. Identify the relevant Epic and Feature.
2. Copy the appropriate test template into that Epic's tester directory.
3. Give the scenario a descriptive name that states the behavior being checked.
4. Add the input and expected output files required by the scenario.
5. Record the test path and execution result in the linked Jira issue.

Build and run the primary COBOL program with:

```sh
cobc -x -o InCollege InCollege.cob InCollege-Core.cob && ./InCollege
```

The `build test-main` and `run test-main` commands are also available as VS Code tasks for the test harness.

See the project documentation before making changes, and provide references to the requirement, procedure, affected files, and validation evidence during every handoff.