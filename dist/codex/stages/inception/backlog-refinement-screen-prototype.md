---
slug: backlog-refinement-screen-prototype
number: 2.85
name: Screen Prototype Review
plugin: backlog-refinement
phase: inception
execution: ALWAYS
condition: Executes for user-story refinement work that includes a screen or UI interaction.
lead_agent: aidlc-design-agent
support_agents:
  - aidlc-product-agent
mode: inline
summary_confirmation: required
produces:
  - backlog-refinement-screen-preview
consumes:
  - artifact: requirements
    required: true
  - artifact: stories
    required: true
  - artifact: code-structure
    required: false
  - artifact: backlog-refinement-readiness
    required: true
requires_stage:
  - user-stories
scopes:
  - backlog-refinement-story
inputs: Confirmed requirements and stories, readiness findings, and existing implementation analysis
outputs: Mockup source and screenshot under this stage's engine-resolved record directory
---

# Screen Prototype Review

## Steps

### Step 1: Resolve Screen Questions

Compare the accepted user story with the current screens and behavior found in
Reverse Engineering. Ask only questions whose answers change the screen,
interaction, visible state, or acceptance criteria. Record answers and any
remaining assumptions. Do not invent product decisions.

### Step 2: Create the Prototype

Create a runnable, low-fidelity screen prototype under this stage's
engine-resolved record directory. Use the project's existing visual patterns,
labels, and design tokens where they can be identified. Keep the prototype
isolated from application source files and do not add dependencies. Include the
states and interactions needed to explain the accepted story, including
relevant empty, error, loading, or confirmation states.

Use the project's existing preview/browser tooling when available. Otherwise,
make the prototype self-contained and use a browser or visual preview tool
available in the current environment. Do not invent or install a preview tool.

### Step 3: Capture and Show the Preview

Capture a screenshot of the rendered prototype under this stage's record
directory. Show the screenshot itself to the person in the current harness, and
include the mockup and screenshot paths. A file path alone is not a visual
review. If this harness cannot render or attach the screenshot, say so and
provide the prototype path for the person to open; do not report the visual
review as complete until the person has seen it.

### Step 4: Revise from Feedback

Ask the person to approve the screen or describe changes. Apply their feedback
to the prototype, capture a fresh screenshot, and show the new version. Repeat
until they approve. Preserve the approved screenshot and note the decisions it
reflects. Do not change application source code as part of this refinement.

### Step 5: Complete the Stage

Record the approved prototype, screenshot, unresolved questions, and revision
notes in the stage artifacts. Run
`{{INVOKE}} engine orchestrate report --stage backlog-refinement-screen-prototype --result awaiting-approval`, present the paths, and record the person's response through the orchestrator.

## Sensors

This stage's mockup source and screenshot are outputs under its
engine-resolved record directory.

## Learn

When the active protocol enables learnings, follow its learning instructions.
