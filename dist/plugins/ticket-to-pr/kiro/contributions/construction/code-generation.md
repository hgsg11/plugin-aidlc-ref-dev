---
target: code-generation
plugin: ticket-to-pr
adds:
  scopes:
    - ticket-to-pr-work-item
fragments:
  - anchor: after-step:1
    order: 100
  - anchor: after-step:7
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

## fragment: after-step:7

For the `ticket-to-pr` scope, when `Construction Autonomy Mode` is
`autonomous` in the state file, do not ask the completion question. Present the
summary, run
`aidlc engine orchestrate report --stage code-generation --result awaiting-approval`,
then report `--result approved` without `--user-input` and continue to Build
and Test. If the engine refuses because a reply from the person is required
(the project has not recorded the `AIDLC_SKIP_HUMAN_PRESENCE_GUARD` bypass),
present the ordinary approval gate instead.
