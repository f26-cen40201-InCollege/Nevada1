# **JIRA TOOL PROJECT REFERENCE GUIDE**

## Purpose

Jira is the project system of record for the 10-sprint In-College project. Every feature, implementation task, test task, bug, decision, and handoff should be traceable to a Jira issue. The repository contains the source code and supporting evidence; Jira contains the work status, ownership, scope, and links to that evidence.

## Work Hierarchy

Use the following Jira hierarchy for project work:

| Jira item | Project use |
| --- | --- |
| **`EPIC`** | A major project area or course epic, such as account management, profiles, search, or testing infrastructure. |
| **`FEATURE`** | A related group of user-visible requirements within an Epic. |
| **`USER STORY`** | A user-visible capability or requirement that can be demonstrated and accepted. |
| **`TASK`** | A concrete development, documentation, setup, or test activity supporting a story. |
| **`BUG`** | A reproducible defect found during development or testing. Link it to the affected story or epic. |
| **`SUB-TASK`** | A smaller piece of a task assigned to one person when the work needs to be split. |

Create or confirm the Epic before adding its Features. Each Feature should state the user behavior, acceptance criteria, files or modules likely to change, and the test evidence required for completion. Do not use an Epic as a substitute for individual tasks or bugs.

## Sprint Organization

There are 10 total sprints. Each sprint is one weekly planning and delivery cycle. The role rotation is always:

`Scrum Master -> Developer 1 -> Developer 2 -> Tester 1 -> Tester 2`

The person listed for a role in [ROLE-TRACKER.md](ROLE-TRACKER.md) owns that role for the corresponding sprint. At sprint planning, assign each in-scope Jira issue to the correct person and set the sprint field. At the end of the sprint, all completed issues must link to code, test output, or documentation evidence.

Use a single sprint goal that describes the user-facing outcome. Move issues through a consistent workflow such as `To Do -> In Progress -> In Review -> In Test -> Done`. A Developer may not mark a Feature `Done` without tester evidence, and a Tester may not close a Bug without confirming the expected behavior.

## Role Instructions

### Scrum Master

1. Create the sprint and record its goal, scope, and role assignments.
2. Confirm that every Feature has acceptance criteria and that implementation and testing tasks are linked.
3. Monitor the board during the week, remove blockers, and record decisions or scope changes in Jira.
4. Run the planning, stand-up, review, and retrospective checkpoints.
5. Before closing the sprint, verify that completed work has references to commits, files, test cases, and results.

### Developer 1 and Developer 2

1. Select an assigned Task or Feature from the sprint backlog and move it to `In Progress`.
2. Add a short implementation note describing the intended code path and the documentation consulted.
3. Link the work to the relevant Epic and Feature, then reference the changed files or commit.
4. Add or update tests and provide the exact command or procedure used to validate the change.
5. Move the issue to `In Review` only after the change and its documentation references are ready for review.

### Expected Responsibilities: Tester 1 | Tester 2

1. Review the Feature acceptance criteria and the Developer's implementation and test references.
2. Create or link a test case that states the input, expected result, actual result, and test data setup.
3. Run the test from the appropriate test directory and attach or reference the output.
4. Move the issue to `Done` only when the expected behavior is confirmed.
5. For a failure, create a Bug linked to the Feature, include reproduction steps and evidence, and move the Feature back to `In Progress` or `In Test` as appropriate.

## Handling Testing & Bugs

Tests should be organized under the Epic and Feature they validate. Use the repository's nested test directories for test inputs and expected outputs, and reference those paths in the Jira issue. A bug report must include:

- a concise failure summary;
- the affected Epic, Feature, and sprint;
- exact reproduction steps and input files;
- expected versus actual output;
- environment or build command details;
- severity, owner, and a proposed regression test.

When fixed, the Developer links the changed code and regression test. The Tester reruns the original reproduction and the regression test, records the result, and only then closes the Bug.

## Sprint Closeout

The Scrum Master closes a sprint only after the board, test evidence, open bugs, decisions, and handoff notes are current. Unfinished work is moved to the next sprint with a clear status and remaining-work note; it is not silently carried over.