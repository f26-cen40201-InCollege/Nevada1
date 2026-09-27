# **WEEKLY TEAM PROCEDURES**

## Operating Model

The project has 10 weekly sprints and five rotating responsibilities. Each week, use the assignments in [ROLE-TRACKER.md](ROLE-TRACKER.md):

`Scrum Master -> Developer 1 -> Developer 2 -> Tester 1 -> Tester 2`

The assigned person owns the duties below for that sprint. Everyone is responsible for keeping Jira and the repository evidence synchronized.

## Required Documentation Handoff

Before every code, test, configuration, or process change, the assigned person must be prepared to hand over references to the documentation they used. At minimum, the handoff should identify the relevant Jira issue, requirement or acceptance criterion, source file or test path, and procedure or design document consulted. After the change, update the issue with the result and any new evidence.

Do not begin a change with an undocumented assumption. If the requirement or expected behavior is unclear, record the question in Jira and ask the Scrum Master to resolve it before implementation or testing continues.

## Scrum Master Procedure

1. Review the sprint goal, [JIRA.md](JIRA.md), open bugs, and unfinished work from the previous sprint.
2. Confirm the five role assignments and create or update the Jira sprint.
3. Break the sprint goal into Features, Tasks, and test work with clear acceptance criteria.
4. Run regular status checks and record blockers, scope changes, and decisions in Jira.
5. Before any team member changes the project, confirm they can reference the requirement and relevant procedure documentation.
6. At review, collect code links, test paths, commands, outputs, and unresolved risks.
7. At closeout, verify completed work, carry over unfinished issues explicitly, and record the retrospective.

## Developer 1 and Developer 2 Procedure

1. Select an assigned Jira issue and read its Epic, Feature, acceptance criteria, linked bugs, and prior comments.
2. Before editing, prepare the documentation handoff: cite the requirement, affected module or file, relevant procedure, and intended validation.
3. Move the issue to `In Progress` and implement the smallest change that satisfies the acceptance criteria.
4. Add or update focused tests and preserve the repository's existing test organization and conventions.
5. Build or run the affected program, record the exact command and result, and inspect the output for regressions.
6. Update Jira with changed files, test evidence, known limitations, and references to the implementation documentation.
7. Request review and move the issue to `In Review`; do not declare the Feature complete until tester evidence exists.

## Tester 1 and Tester 2 Procedure

1. Read the assigned Feature, acceptance criteria, linked implementation issue, and the Developer's documentation handoff.
2. Confirm that the expected behavior and test data are documented before running the test.
3. Prepare a test case in the appropriate repository test directory, including positive, negative, boundary, and regression coverage where applicable.
4. Run the documented build and test command, recording input files, expected output, actual output, and the result.
5. For a pass, attach or link the evidence in Jira and move the issue toward `Done`.
6. For a failure, create a linked Bug with reproducible steps, expected versus actual behavior, evidence, severity, and the proposed regression test.
7. Retest fixes against the original failure and related regression cases before closing the Bug or approving the Feature.

## Weekly Handoff Checklist

Before the sprint review, confirm:

- the Jira issue is linked to its Epic and sprint;
- the requirement and acceptance criteria are referenced;
- changed files and test paths are listed;
- the build and test commands are recorded;
- output or other validation evidence is available;
- open bugs and remaining work are explicit;
- the next owner can understand the work without relying on an undocumented conversation.