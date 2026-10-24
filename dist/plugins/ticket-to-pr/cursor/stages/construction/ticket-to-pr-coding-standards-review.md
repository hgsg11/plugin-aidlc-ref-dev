---
slug: ticket-to-pr-coding-standards-review
number: 3.8
name: Ticket Coding Standards Review
plugin: ticket-to-pr
phase: construction
execution: ALWAYS
condition: Executes after the security review passes.
lead_agent: aidlc-quality-agent
support_agents: []
mode: inline
produces:
  - ticket-to-pr-coding-standards-review-report
consumes:
  - artifact: ticket-to-pr-security-review-report
    required: true
  - artifact: requirements
    required: true
requires_stage:
  - ticket-to-pr-security-review
scopes:
  - ticket-to-pr-work-item
inputs: Implemented source diff, repository standards, approved requirements, and prior review report
outputs: ticket-to-pr-coding-standards-review-report.md (under this stage's record dir, engine-resolved)
---

# Ticket Coding Standards Review

## Steps

### Step 1: Review the Change

Inspect the current branch diff and relevant repository guidance, such as
project instructions, formatter/linter configuration, and nearby code. Check
naming, formatting, error handling, test conventions, layering, and consistency
with established patterns. Limit findings to actionable violations in changed
code; do not impose personal style preferences or recommend broad rewrites.

Do not modify source files while reviewing; Step 3 applies fixes. Verify any
claimed lint or format result by running the repository's documented command
when available.

### Step 2: Record Findings

Write `ticket-to-pr-coding-standards-review-report.md` with verdict `PASS` or
`CHANGES REQUIRED`, each finding's file and line, the violated repository rule
or concrete inconsistency, and a specific correction. Include checks run and
limitations. Use `PASS` only when no actionable coding-standards findings
remain. Every finding requires a fix regardless of severity, including minor
naming, wording, comment, or formatting issues. Do not mark any finding
optional, non-blocking, or a nit, and do not return `PASS` while any finding
remains.

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
`{{INVOKE}} engine orchestrate report --stage ticket-to-pr-coding-standards-review --result awaiting-approval`.
When `Construction Autonomy Mode` is `autonomous` in the state file, report
`--result approved` without `--user-input` and continue without asking the
person. Otherwise present the report and record the person's response
through the orchestrator.

## Sensors

This stage produces `ticket-to-pr-coding-standards-review-report.md` under its
engine-resolved record directory.

## Learn

When the active protocol enables learnings, follow its learning instructions.
