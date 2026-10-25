# ticket-to-pr-lite

A Claude Code plugin that takes a GitHub issue to a pull request without AIDLC.
It checks the spec for contradictions before any code is written, asks the
person once, then loops implementation, verification, and review until the
change is clean.

## Install in a repository

Install the plugin, then run its install skill once in each repository:

```text
/plugin install ticket-to-pr-lite@aidlc-ref-dev
/ticket-to-pr-lite:install
```

The install skill places everything the workflow uses in one directory and
detects the repository's commands:

```text
.claude/ticket-to-pr/
  config.json              fix, verify, baseBranch, branchName, prTemplate
  agents/
    analyst.md             how specs are written
    spec-reviewer.md       what the spec check looks for
    implementer.md         how to implement and test
    reviewer-tests.md      tests review
    reviewer-security.md   security review
    reviewer-standards.md  standards review
    reviewer-slop.md       AI slop review
  .installed               what the install skill placed, for updates
```

At run time the workflow reads only this directory. Commit it so the whole
team uses the same files.

## Run

```text
/ticket-to-pr-lite:ticket-to-pr https://github.com/owner/repo/issues/123
```

Asking Claude to implement an issue and open a PR also starts it.

## Flow

1. **Spec.** The analyst writes `spec.md` with acceptance criteria (`AC1`,
   `AC2`, ...). A separate spec reviewer checks it for contradictions,
   conflicts with the code and documentation, ambiguity, untestable criteria,
   and unsettled corner cases. Findings the code answers are fixed
   automatically, for at most three rounds.
2. **One approval.** The person answers the design decisions the spec reviewer
   raised and approves the spec.
3. **Implement and verify.** The implementer writes the change, its tests,
   and `traceability.md` (criterion to tests). The coordinator runs the `fix`
   commands, then the `verify` commands; only when they pass do the reviewers
   run in parallel, one per `agents/reviewer-*.md` file. Every finding must be
   fixed, however minor. The loop allows the first implementation plus three
   fix rounds; anything left after that stops the run without a PR.
4. **Pull request.** The coordinator commits, pushes, and opens the PR with
   the criterion-to-test mapping.

## Customize

- **Change what an agent does or checks**: edit its file in
  `.claude/ticket-to-pr/agents/`. The file is the agent's whole set of
  instructions.
- **Add a review aspect**: add `agents/reviewer-<aspect>.md`, for example
  `reviewer-performance.md`, with its checklist.
- **Remove a review aspect**: delete its `reviewer-*.md` file.
- **Commands and branches**: edit `config.json`.

```json
{
  "fix": [
    { "name": "format", "run": "gofmt -w {files}", "glob": "*.go" }
  ],
  "verify": [
    { "name": "lint", "run": "golangci-lint run" },
    { "name": "test", "run": "go test ./..." }
  ],
  "baseBranch": "main",
  "branchName": "ticket/{id}-{slug}",
  "prTemplate": ".github/pull_request_template.md"
}
```

`fix` commands correct formatting and lint issues in place before `verify`
runs, so they never use up a review round. `{files}` is replaced with the
files the ticket changed and `glob` limits them to the types the tool
accepts. `verify` commands only check and must not modify files.

The plugin keeps only the contract each agent has with the coordinator: the
files it reads and writes, the line it returns, its tools, and safety rules.
Editing the instruction files cannot break the workflow's flow.

## Update

After a plugin update, run `/ticket-to-pr-lite:install` again. It updates the
files the repository has not edited, keeps edited files and prints a `diff`
command for each, does not re-add files the repository deleted, and never
touches files the repository added.

## Why it is cheap

Each agent starts with a fresh context and passes work through files in
`.ticket-to-pr/<ticket>/`, which is added to `.git/info/exclude`. The
coordinator never reads source, diffs, logs, or instruction files, so its
conversation stays small however many rounds run. Verification commands run
before any AI review, so a failing test costs no review tokens. Each reviewer
reads only its own checklist.

The default checklists adapt material from AWS AI-DLC's knowledge files: the
corner checklist, the testing and security guides, the brownfield code
generation guide, and the reviewer guides.

## Requirements

- Claude Code
- GitHub CLI (`gh`), authenticated, for issues and pull requests
