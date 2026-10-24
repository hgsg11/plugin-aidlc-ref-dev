---
slug: ticket-to-pr-test-review
number: 3.65
name: Ticket Test Review
plugin: ticket-to-pr
phase: construction
execution: ALWAYS
condition: Executes after Build and Test and before the other reviews.
lead_agent: aidlc-quality-agent
support_agents: []
mode: inline
produces:
  - ticket-to-pr-test-review-report
consumes:
  - artifact: requirements
    required: true
  - artifact: build-test-results
    required: true
requires_stage:
  - build-and-test
scopes:
  - ticket-to-pr-work-item
inputs: Acceptance criteria, test source diff, and build/test results
outputs: ticket-to-pr-test-review-report.md (under this stage's record dir, engine-resolved)
---

# Ticket Test Review

## Steps

### Step 1: Review Test Quality

Inspect the tests added or changed for this ticket and the build/test results.
Check that each accepted criterion has a meaningful assertion, tests exercise observable
behavior rather than implementation details, and failure cases are covered
where the criterion requires them. Look for vacuous assertions, tests that
always pass, and mocking that removes the behavior under test.

Do not modify application or test files while reviewing; Step 3 applies
fixes. Report only actionable findings tied to an acceptance criterion or a
concrete test-quality defect.

### Step 2: Record Findings

Write `ticket-to-pr-test-review-report.md` with verdict `PASS` or `CHANGES
REQUIRED`, each finding's test file and line, the criterion or test property at
issue, and a specific correction. Include checks run and limitations. Use
`PASS` only when every applicable criterion has meaningful test coverage. Every
finding requires a fix regardless of severity, including minor naming, wording,
comment, or formatting issues. Do not mark any finding optional, non-blocking,
or a nit, and do not return `PASS` while any finding remains.

### Step 3: Resolve Findings

When the verdict is `CHANGES REQUIRED`, do not end the stage and do not ask the
person whether to fix the findings. Fix every finding, rerun the tests recorded
in the Build and Test results, and repeat Steps 1 and 2 against the updated
change. Record each round's number and the findings it fixed in the report.
Allow at most three fix rounds. If the verdict is still `CHANGES REQUIRED`
after the third round's review, stop the workflow: do not report this stage
complete, run later stages, or create a pull request. Present the remaining
findings to the person and end the turn.

### Step 4: Complete the Stage

Once the verdict is `PASS`, run
`{{INVOKE}} engine orchestrate report --stage ticket-to-pr-test-review --result awaiting-approval`.
When `Construction Autonomy Mode` is `autonomous` in the state file, report
`--result approved` without `--user-input` and continue without asking the
person. Otherwise present the report and record the person's response
through the orchestrator.

## Sensors

This stage produces `ticket-to-pr-test-review-report.md` under its
engine-resolved record directory.

## Learn

When the active protocol enables learnings, follow its learning instructions.
