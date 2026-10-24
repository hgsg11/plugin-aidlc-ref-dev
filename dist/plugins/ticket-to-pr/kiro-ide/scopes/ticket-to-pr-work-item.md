---
name: ticket-to-pr-work-item
plugin: ticket-to-pr
depth: Standard
keywords:
  - ticket to pr
  - issue to pr
  - implement github issue
description: Implement a GitHub issue, pass four reviews, and open a pull request
skeleton: off
existing_code: true
runner: true
review_cap: advisory
guard_policy: off
sensors: on
learnings: off
summary_confirmation: off
plan_approval: off
collaborators: off
---

# Ticket to PR scope

Use for a bounded change from a GitHub issue in an existing codebase. The
workflow derives the ticket's acceptance criteria and implementation boundary
without a separate confirmation step, then implements and verifies the change,
performs four independent reviews, and opens a GitHub pull request.

## Membership

Initialization and reverse-engineering precede Requirements Analysis, where
the ticket is turned into an implementation brief and requirements. The
consolidated summary confirmation is off: the ticket is the agreed scope.
Code Generation implements the accepted scope and creates tests; Build and Test executes them.
Test review runs first, followed by security, coding standards, and AI slop
reviews. Each review fixes its own findings and reviews again, for at most
three fix rounds; findings left after the third round stop the workflow.
Every review must pass before the pull request stage is reached.

Plan approval is off. Approving Requirements Analysis also lets Construction
run autonomously, so after that approval only failures and an exhausted review
loop stop for the person. The core engine still requires a human reply for the
first Construction-stage review (Code Generation) unless the host project
records the `AIDLC_SKIP_HUMAN_PRESENCE_GUARD` bypass.
Broader ideation, deployment, and operational stages are skipped for this
ticket-sized change.
