# **GIT ISSUES AND FINAL ZIP SIGN-OFF**
## **PURPOSE**

This document defines the repository-level review gate that occurs after implementation and testing, and before the final computation of the project ZIP file and the corresponding Jira sign-offs. It applies to code, tests, documentation, configuration, data files, and any other change that will be included in the submitted repository.

Jira remains the system of record for scope, ownership, status, acceptance criteria, and sprint decisions. Git issues provide the repository evidence and approval record needed to confirm that the change is ready to be included in the final ZIP.

## **REQUIRED LINKS**

Every Git issue must link to:

- The applicable [Jira issue](JIRA.md) and sprint;
- The applicable Epic objective document;
- The changed files and relevant test paths;
- The build or test command and its result;
- The commits or change set being reviewed; and
- Any related Bug, decision, blocker, or deferred work.

For Epic-specific requirements and ownership questions, use the linked references below:

| **Epic** | **Objective Document** | **Sprint Role Owners** |
| --- | --- | --- |
| **Epic 1: Log In, Part 1** | [EPIC-1.md](epic-objectives/EPIC-1.md) | Sprint 1 assignments in the Epic |
| **Epic 2: User Profile Creation** | [EPIC-2.md](epic-objectives/EPIC-2.md) | Sprint 2 assignments in the Epic |
| **Epic 3: Profile Viewing & Basic Search** | [EPIC-3.md](epic-objectives/EPIC-3.md) | Sprint 3 assignments in the Epic |
| **Epic 4: Connection Requests** | [EPIC-4.md](epic-objectives/EPIC-4.md) | Sprint 4 assignments in the Epic |

If the work spans multiple Epics, link every affected Epic and state which acceptance criteria belong to each one.

## **MINIMUM APPROVAL GATE**

A Git issue is not ready for final ZIP inclusion until it has approval from all three required role groups for the active sprint:

| Required approver | Minimum approval | Approval responsibility |
| --- | --- | --- |
| **Development** | At least one assigned Developer 1 or Developer 2 | Confirms the implementation, changed files, and technical approach are complete. |
| **Testing** | At least one assigned Tester 1 or Tester 2 | Confirms the documented test evidence and expected behavior. |
| **Scrum Master** | The Scrum Master assigned to the active sprint | Confirms scope, traceability, unresolved risks, and release readiness. |

The active sprint assignments must be verified against [ROLE-TRACKER.md](ROLE-TRACKER.md). Approvals must be recorded by name, role, date, and a short approval note in the Git issue and mirrored in the linked Jira issue. A person may add additional review, but additional review does not replace any of the three required role groups.

## **GIT ISSUE WORKFLOW**

### **1. Open**

Create the issue before the change begins. Record the Epic, Jira issue, sprint, owner, change scope, acceptance criteria, affected files, intended validation, and any open questions.

### **2. In Progress**

Update the issue as implementation proceeds. Record scope changes, blockers, design decisions, new files, and links to related issues. Keep the linked Jira issue current.

### **3. Ready for Review**

Before requesting approval, attach or link:

- The final changed-file list or commit;
- The exact build and test commands;
- Expected and actual results;
- Test inputs, output files, screenshots, or other evidence as applicable;
- Known limitations and unresolved risks; and
- The Jira status and acceptance-criteria result.

### **4. Approved for ZIP**

Set this state only after the minimum Development, Testing, and Scrum Master approvals are present. Confirm that all required links work, the repository builds or tests as documented, and no unresolved blocker prevents inclusion.

### **5. Included in Final ZIP**

At final packaging, record the ZIP file name, creation date, commit or tag used, included Git issue IDs, and the final Jira sign-off status. The Scrum Master confirms that the ZIP was computed from the approved change set.

## **APPROVAL RECORDS**

Use this record in each Git issue. Replace the placeholders with the active sprint owners from [ROLE-TRACKER.md](ROLE-TRACKER.md).

| Role group | Approver | Date | Approval note |
| --- | --- | --- | --- |
| Development | `<Developer 1 or Developer 2>` | `YYYY-MM-DD` | Implementation and changed files reviewed. |
| Testing | `<Tester 1 or Tester 2>` | `YYYY-MM-DD` | Test evidence and expected behavior reviewed. |
| Scrum Master | `<Active Sprint Scrum Master>` | `YYYY-MM-DD` | Scope, traceability, risks, and ZIP readiness reviewed. |

## **FINAL ZIP CHECKLIST**

- [ ] Every included change has a linked Git issue and Jira issue.
- [ ] Each Git issue identifies its Epic objective document.
- [ ] Acceptance criteria are complete or explicitly marked as deferred.
- [ ] At least one assigned Developer has approved.
- [ ] At least one assigned Tester has approved.
- [ ] The active Sprint Scrum Master has approved.
- [ ] Build and test commands, inputs, expected output, and actual output are recorded.
- [ ] Related Bugs are fixed, retested, or explicitly excluded with a documented decision.
- [ ] Unresolved risks, limitations, and carry-over work are recorded in Jira.
- [ ] The final ZIP name, source commit or tag, and included Git issues are recorded.

## **QUESTIONS & EXCEPTIONS**

Questions about requirements should be raised against the relevant Epic objective document and Jira issue before implementation continues.

Questions about role ownership should be checked against [ROLE-TRACKER.md](ROLE-TRACKER.md).

Questions about handoffs, testing evidence, or sprint closeout should be checked against [PROCEDURES.md](PROCEDURES.md).

An exception to the minimum approval gate requires a written Jira decision from the Scrum Master and must identify the missing approval, reason, risk, compensating review, and final approver.

An exception does not silently remove the requirement; it documents why the project accepted the risk for that release.