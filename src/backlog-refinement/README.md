# backlog-refinement — AIDLC backlog refinement plugin

This optional plugin turns a user story into a reviewed, implementation-ready
refinement package for an existing product. It investigates the relevant
implementation, raises questions, creates and revises a browser-viewable screen
mockup with a screenshot for review, and outputs a story-to-implementation map.
It also records readiness gaps, dependencies, and unresolved questions without
inventing product decisions.

Enable the plugin and select the `backlog-refinement-story` scope for a refinement
run. The final map has a stable Markdown source, with an optional export chosen
to fit the project's existing tools and the person's environment (for example,
a diagram file or an available document workspace). The plugin does not assume
that a particular external service is installed or connected.

## Layout

```text
plugins/backlog-refinement/
  .aidlc-plugin/plugin.json
  contributions/inception/reverse-engineering.md
  contributions/inception/requirements-analysis.md
  contributions/inception/user-stories.md
  scopes/backlog-refinement-story.md
  stages/inception/backlog-refinement-screen-prototype.md
  stages/inception/backlog-refinement-implementation-map.md
```

Build and validate it with the AIDLC plugin authoring tools before publishing
updated generated packages.
