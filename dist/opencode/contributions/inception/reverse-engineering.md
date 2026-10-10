---
target: reverse-engineering
plugin: backlog-refinement
adds:
  scopes:
    - backlog-refinement-story
fragments:
  - anchor: end-of-steps
    order: 100
---

## fragment: end-of-steps

For the `backlog-refinement` scope, focus the investigation on the user story's
affected screens, interactions, components, routes, data, and tests. Record the
current behavior and relevant source locations in the existing Reverse
Engineering artifacts. Distinguish observed behavior from assumptions and do
not implement changes during this investigation.
