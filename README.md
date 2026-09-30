<div align="center">

# **COBOL Software Engineering Semester Project**

<img src="./docs/inCollege.png" alt="LinkCluster Professional Profile" width="750">

| **`COURSE ID #`** | **`COURSE NAME`** | **`PROJECT`** | **`TEAM NAME`** |
| --- | --- | --- | --- |
| **CEN-4020** | **Software Engineering** | **In-College Project** | **Nevada** |

| **`TEAM MEMBER NAMES`** | **`USF EMAIL`** | **`USF ID #`** |
| --- | --- | --- |
| **Jude Joyson** | **jjoyson@usf.edu** | **U71904812** |
| **Aref Khondaker** | **arefkhondaker@usf.edu** | **U83734904** |
| **Tangil Khondaker** | **tangilkhondaker@usf.edu** | **U97178616** |
| **Ian Koratsky** | **ikoratsk@usf.edu** | **U54407179** |
| **Connor Kouznetsov** | **ckouznetsov@usf.edu** | **U30979013** |


## **PROJECT OVERVIEW**

This repository contains all functional code, testing, and documentation CEN-4020 Software Engineering In-College project.

The application is implemented in COBOL and is organized around incremental Epics, Features, testing, and sprint-based team ownership.

The project has **ten (10) weekly sprints** and **five (5) rotating responsibilities**:

`SCRUM MASTER → DEVELOPER #1 → DEVELOPER #2 → TESTER #1 → TESTER #2`

See [ROLE-TRACKER.md](docs/ROLE-TRACKER.md) for the owner of each role in every sprint.

## **PROJECT DOCUMENTATION**

| Document | Purpose |
| --- | --- |
| [JIRA.md](docs/JIRA.md) | Jira hierarchy, sprint organization, role workflows, testing, and bug management. |
| [PROCEDURES.md](docs/PROCEDURES.md) | Weekly responsibilities and required documentation handoffs before changes. |
| [ROLE-TRACKER.md](docs/ROLE-TRACKER.md) | The 10-sprint left-to-right role rotation. |
| [GIT-ISSUES.md](docs/GIT-ISSUES.md) | Repository issue tracking, review evidence, sign-off, and final ZIP readiness. |
| [EPIC Objectives](docs/epic-objectives/) | Scope, acceptance context, role ownership, and Git issue references for each Epic. |
| `tests/` | Nested Epic, tester, and scenario directories for test inputs and expected outputs. |

## **DEVELOPMENT WORKFLOW**

#### 1. Select the assigned Jira Feature, Task, or Bug for the active sprint.
#### 2. Before changing code or tests, document the requirement, affected files, relevant procedure, and intended validation.
#### 3. Implement the change and update or add focused tests in the appropriate test directory.
#### 4. Build and run the affected COBOL program, recording the exact command and result in Jira.
#### 5. Have the assigned Tester verify the acceptance criteria and attach test evidence.
#### 6. Close the issue only when the implementation, testing, documentation, and any linked bug work are complete.


## **TESTING IMPLEMENTATION**

The test suite uses nested directories organized by *Epic*, *Tester*, and *Scenario*. **COBOL** test inputs and expected outputs are processed sequentially.

In order to add and integrate new edge cases and testing features, utilize the following steps below:

#### 1. Identify the relevant Epic and Feature.
#### 2. Copy the appropriate test template into that Epic's tester directory.
#### 3. Give the scenario a descriptive name that states the behavior being checked.
#### 4. Add the input and expected output files required by the scenario.
#### 5. Record the test path and execution result in the linked Jira issue.

Build and Run the primary COBOL program with:

```bash
cobc -x -o InCollege InCollege.cob InCollege-Core.cob && ./InCollege
```

The `build test-main` and `run test-main` commands are also available as VS Code tasks for the test harness.

See the project documentation before making changes, and provide references to the requirement, procedure, affected files, and validation evidence during every handoff.

</div>