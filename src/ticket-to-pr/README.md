# ticket-to-pr — GitHub issue to pull request

This optional plugin provides a focused workflow for implementing a GitHub
issue in an existing repository. It derives the implementation boundary from
the issue, runs implementation and tests, then performs test-quality, security,
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
   questions into an implementation brief. The ticket is the agreed scope, so
   the brief needs no separate confirmation.
3. Generate requirements from the brief, generate an implementation plan, and
   implement it with tests.
4. Build and run the tests, then pass the test-quality review.
5. Pass security, coding standards, and AI slop reviews in that order. Each
   review fixes its findings and reviews again, for at most three fix rounds;
   findings left after the third round stop the workflow.
6. Prepare and create a GitHub pull request with the ticket linked.

## Approvals

The person approves Reverse Engineering and Requirements Analysis. Approving
Requirements Analysis switches Construction to autonomous mode, so Code
Generation, Build and Test, the four reviews, and the pull request stage
complete without further approval questions. Plan approval is off. Failures
and an exhausted review loop still stop the workflow.

The AIDLC core engine requires a human reply for the first Construction-stage
review (Code Generation) even in autonomous mode. To skip it, record the
bypass in the host project:

```sh
aidlc config flags --bypass AIDLC_SKIP_HUMAN_PRESENCE_GUARD
```

The bypass applies to every workflow in that project: the engine stops
verifying that a person replied before any gate is approved, although the
workflow still asks the Reverse Engineering and Requirements Analysis
questions. Without it, the workflow shows the Code Generation approval as
usual.

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
