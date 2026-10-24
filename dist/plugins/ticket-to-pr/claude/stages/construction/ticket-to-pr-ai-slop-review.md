---
slug: ticket-to-pr-ai-slop-review
number: 3.9
name: Ticket AI Slop Review
plugin: ticket-to-pr
phase: construction
execution: ALWAYS
condition: Executes after the coding standards review passes.
lead_agent: ticket-to-pr-ai-slop-reviewer-agent
support_agents: []
mode: inline
produces:
  - ticket-to-pr-ai-slop-review-report
consumes:
  - artifact: ticket-to-pr-coding-standards-review-report
    required: true
requires_stage:
  - ticket-to-pr-coding-standards-review
scopes:
  - ticket-to-pr-work-item
inputs: Implemented source diff, original ticket, repository instructions, and prior review reports
outputs: ticket-to-pr-ai-slop-review-report.md (under this stage's record dir, engine-resolved)
---

# Ticket AI Slop Review

## Steps

### Step 1: Review the Change

Read the AI Slop Reviewer persona. Inspect the current branch diff and the
original ticket. Check for unsupported assumptions, scope creep, speculative
abstractions or fallbacks, swallowed failures, type or lint escapes, dead
code, duplicated validation, invented APIs, placeholders, leftover working
artifacts, mock-only tests, and comments that merely restate or narrate the
implementation. Ground every finding in the request, a caller, a repository
invariant, or nearby code.

Do not modify source files while reviewing; Step 3 applies fixes. Do not label
code as slop based on style, author, or use of AI.

### Step 2: Record Findings

Write `ticket-to-pr-ai-slop-review-report.md` with verdict `PASS` or `CHANGES
REQUIRED`, each finding's file and line, the missing requirement or concrete
redundancy, and the smallest correction. Include limitations. Use `PASS` only
when no evidence-backed findings remain. Every finding requires a fix
regardless of severity, including minor naming, wording, comment, or formatting
issues. Do not mark any finding optional, non-blocking, or a nit, and do not
return `PASS` while any finding remains.

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
`{{INVOKE}} engine orchestrate report --stage ticket-to-pr-ai-slop-review --result awaiting-approval`.
When `Construction Autonomy Mode` is `autonomous` in the state file, report
`--result approved` without `--user-input` and continue without asking the
person. Otherwise present the report and record the person's response
through the orchestrator.

## Sensors

This stage produces `ticket-to-pr-ai-slop-review-report.md` under its
engine-resolved record directory.

## Learn

When the active protocol enables learnings, follow its learning instructions.
