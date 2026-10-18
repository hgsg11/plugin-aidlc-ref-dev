---
slug: backlog-refinement-implementation-map
number: 2.95
name: Implementation Map
plugin: backlog-refinement
phase: inception
execution: ALWAYS
condition: Executes after the screen prototype is reviewed and accepted.
lead_agent: aidlc-delivery-agent
support_agents:
  - aidlc-product-agent
  - aidlc-design-agent
mode: inline
summary_confirmation: required
produces:
  - backlog-refinement-implementation-map
consumes:
  - artifact: requirements
    required: true
  - artifact: stories
    required: true
  - artifact: code-structure
    required: false
  - artifact: backlog-refinement-readiness
    required: true
  - artifact: backlog-refinement-screen-preview
    required: true
requires_stage:
  - backlog-refinement-screen-prototype
scopes:
  - backlog-refinement-story
inputs: Approved story and screen prototype, existing implementation findings, requirements, and readiness review
outputs: Reviewed implementation map in the project-selected destination and a Markdown record under this stage's engine-resolved record directory
---

# Implementation Map

## Steps

### Step 1: Choose the Deliverable Format and Destination

Inspect project instructions and existing refinement/design artifacts for the
team's preferred deliverable format and destination. Reuse an established
format or connected destination when there is clear evidence for it. If the
choice is unclear, ask the person which available format and destination they
want (for example, a diagram file, repository document, or connected document
workspace). Do not assume a service such as Box is connected, and do not
create a new external document without the person's direction.

Keep the map content independent of its export format so it can be rendered in
the available tool. Record the chosen format, destination, and any unavailable
export capability.

### Step 2: Build the Story-to-Implementation Map

Map the approved user story and each acceptance criterion to:

- current behavior and the relevant existing screen, component, route, data,
  API, or source location found during Reverse Engineering;
- the approved mockup screen and screenshot;
- proposed behavior and interaction states;
- implementation area or dependency likely to change;
- verification evidence that will demonstrate the criterion;
- unresolved decisions, dependencies, and explicit out-of-scope items.

Use evidence from the repository and approved artifacts. Mark unknown locations
or decisions as unresolved; do not guess. Keep the mapping at refinement level
and do not implement the product change.

### Step 3: Render and Review the Deliverable

Write the durable Markdown record
`backlog-refinement-implementation-map.md` under this stage's record directory,
then render or export the map to the selected project destination and format
when the necessary tool is available. Include the approved screenshot or a
working reference to it. Present the deliverable to the person and revise it
from their feedback. If an export cannot be produced in the chosen environment,
explain the exact limitation and provide the Markdown record for review; do
not claim that the external export exists.

### Step 4: Complete the Stage

After the person accepts the map, run
`{{INVOKE}} engine orchestrate report --stage backlog-refinement-implementation-map --result awaiting-approval`, present the output and destination, and record the person's response through the orchestrator.

## Sensors

The Markdown record and any selected-format deliverable document this stage's
outputs. The map is an implementation-planning artifact; it does not modify
application source code.

## Learn

When the active protocol enables learnings, follow its learning instructions.
