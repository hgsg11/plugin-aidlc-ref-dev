---
target: user-stories
plugin: backlog-refinement
adds:
  scopes:
    - backlog-refinement-story
  produces:
    - backlog-refinement-readiness
fragments:
  - anchor: after-step:8
    order: 100
---

## fragment: after-step:8

### Backlog refinement review (backlog-refinement plugin)

Create `backlog-refinement-readiness.md` in this stage's engine-resolved record
directory. Review each generated story and record its ID, priority, size or
relative size when the team has supplied one, readiness (`Ready` or `Needs
clarification`), and any specific unresolved question or dependency.

Check that each story:

- names a user or system actor, an outcome, and the value of that outcome;
- has acceptance criteria that describe observable results and cover relevant
  alternate or failure paths;
- is small enough to estimate and deliver as one coherent change, or records
  why it remains larger;
- identifies dependencies and decisions that affect implementation.

Use the team's stated sizing method and readiness policy when available. Do not
invent estimates, priorities, product behavior, or a definition of ready. Mark
missing information as `Needs clarification` and name the question. A human may
accept an unresolved item or request changes at the stage approval gate; the
readiness labels are evidence, not an automatic gate. Keep the story's meaning
and priority unchanged unless the user directs a revision.
