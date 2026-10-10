---
target: build-and-test
plugin: ticket-to-pr
adds:
  scopes:
    - ticket-to-pr-work-item
fragments:
  - anchor: end-of-steps
    order: 100
---

## fragment: end-of-steps

For the `ticket-to-pr` scope, report the exact build and test commands run and
their results. Keep the ticket's acceptance criteria linked to the checks or
manual evidence that verify them. The downstream review stages require this
summary and do not treat unrun checks as passing. The test-quality review runs
after this stage and before security, coding standards, and AI slop reviews.
