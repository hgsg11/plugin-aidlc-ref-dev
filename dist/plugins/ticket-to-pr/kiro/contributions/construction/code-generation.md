---
target: code-generation
plugin: ticket-to-pr
adds:
  scopes:
    - ticket-to-pr-work-item
fragments:
  - anchor: after-step:1
    order: 100
---

## fragment: after-step:1

For the `ticket-to-pr` scope, implement only the approved requirements and
acceptance criteria from the ticket brief. Follow repository-local coding
standards and conventions discovered during Reverse Engineering. Do not add
unrequested dependencies, abstractions, fallback paths, or unrelated cleanup.
Complete the implementation stage's required test artifacts; the following
Build and Test stage executes those tests. Keep each test linked to an accepted
criterion and follow the repository's existing test conventions.
