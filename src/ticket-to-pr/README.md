# ticket-to-pr — GitHub issue to pull request

This optional plugin provides a focused workflow for implementing a GitHub
issue in an existing repository. It clarifies the issue and implementation
boundary, runs implementation and tests, then performs test-quality, security,
coding standards, and AI slop reviews before creating a pull request.

The issue can be supplied as a GitHub issue URL or as pasted ticket text. The
plugin does not fetch tickets from other systems. Its pull request stage uses
the repository's GitHub CLI (`gh`) and only creates a PR after all four review
reports pass.

Enable the plugin and select the `ticket-to-pr-work-item` scope for this workflow. The
plugin adds stages and scope membership through the normal AIDLC compose
mechanism; it does not edit core files.

## Workflow

1. Reverse engineer the existing repository.
2. Extract the ticket's goal, acceptance criteria, constraints, and unresolved
   questions; have the person confirm the implementation boundary.
3. Confirm the implementation brief during Requirements Analysis, refine
   requirements, generate an implementation plan, and implement it with tests.
4. Build and run the tests, then pass the test-quality review.
5. Pass security, coding standards, and AI slop reviews in that order. Resolve
   findings and rerun the relevant review before proceeding.
6. Prepare and create a GitHub pull request with the ticket linked.

## Layout

```text
plugins/ticket-to-pr/
  .aidlc-plugin/plugin.json
  agents/ticket-to-pr-ai-slop-reviewer-agent.md
  contributions/inception/requirements-analysis.md
  contributions/inception/reverse-engineering.md
  contributions/construction/code-generation.md
  contributions/construction/build-and-test.md
  scopes/ticket-to-pr-work-item.md
  stages/construction/ticket-to-pr-test-review.md
  stages/construction/ticket-to-pr-security-review.md
  stages/construction/ticket-to-pr-coding-standards-review.md
  stages/construction/ticket-to-pr-ai-slop-review.md
  stages/construction/ticket-to-pr-open-pull-request.md
```

Build and validate it with the AIDLC plugin authoring tools before publishing
updated generated packages.
