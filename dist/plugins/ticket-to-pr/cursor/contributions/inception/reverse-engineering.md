---
target: reverse-engineering
plugin: ticket-to-pr
adds:
  scopes:
    - ticket-to-pr-work-item
fragments:
  - anchor: end-of-steps
    order: 100
---

## fragment: end-of-steps

For the `ticket-to-pr` scope, keep the scan focused on the ticket's named
behavior and likely change paths. Record the relevant components, tests,
conventions, and risks that the ticket intake stage needs. Do not expand the
ticket's requested product behavior during repository analysis.
