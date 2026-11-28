# ticket-to-pr-lite

A Claude Code plugin that implements a GitHub issue without AIDLC. It loops
implementation, verification, and review until the change is clean.

By default it asks the person nothing: it treats the issue as the spec and
ends with a commit, without pushing or opening a pull request, so the caller
decides how the change is delivered. In a Paracell cell, `paracell review`
opens the pull request. `config.json` can add a spec check, a one-time
approval, and a pull request.

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
  config.json              spec, delivery, fix, verify, baseBranch,
                           branchName, prTemplate
  agents/
    analyst.md             how specs are written (spec: check, approve)
    spec-reviewer.md       what the spec check looks for (spec: check, approve)
    implementer.md         how to implement and test
    reviewer-tests.md      tests review
    reviewer-security.md   security review
    reviewer-standards.md  standards review
    reviewer-slop.md       AI slop review
    reviewer-design.md     design review
  .installed               what the install skill placed, for updates
```

At run time the workflow reads only this directory. Commit it so the whole
team uses the same files.

## Run

```text
/ticket-to-pr-lite:ticket-to-pr https://github.com/owner/repo/issues/123
```

Asking Claude to implement an issue also starts it. With the default
`spec: ticket`, the run never stops to ask: write the issue with its
acceptance criteria or a completion checklist before starting it.

## Flow

1. **Spec**, by `spec` in `config.json`:
   - `ticket` (default): the coordinator saves the issue title and body as
     `spec.md` without reading it. Nothing is checked or asked. The
     implementer numbers the acceptance criteria `AC1`, `AC2`, ... when they
     have no IDs.
   - `check`: the analyst writes `spec.md` with acceptance criteria. A
     separate spec reviewer checks it for contradictions, conflicts with the
     code and documentation, ambiguity, untestable criteria, and unsettled
     corner cases. Findings the code answers are fixed automatically, for at
     most three rounds. Design decisions take the reviewer's recommended
     option and are recorded in the spec as not confirmed. Nothing is asked.
   - `approve`: the same check, then the person answers the design decisions
     and approves the spec once.
2. **Implement and verify.** The implementer writes the change, its tests,
   and `traceability.md` (criterion to tests). The coordinator runs the `fix`
   commands, then the `verify` commands; only when they pass do the reviewers
   run in parallel, one per `agents/reviewer-*.md` file. Every finding must be
   fixed, however minor. The loop allows the first implementation plus three
   fix rounds; anything left after that stops the run without a commit.
3. **Deliver**, by `delivery` in `config.json`:
   - `commit` (default): the coordinator commits the change and reports the
     criterion-to-test mapping in `traceability.md`. It does not push or open
     a pull request.
   - `pr`: the coordinator also pushes and opens the PR with the
     criterion-to-test mapping, filling `prTemplate` when it is set.

## Coding rules

The implementer follows rules first and the nearby code second:

1. CLAUDE.md and the linters.
2. The design rules in `implementer.md`: validate in constructors so an
   invalid object cannot exist, expose intent-revealing operations instead
   of setters, keep logic in the class that owns the data, enforce each
   business rule in one place, leave state unchanged when an operation is
   rejected, choose implementations in one place instead of caller-side
   switches, keep business decisions out of factories, do not merge code
   with different purposes, and name classes for their role and operations
   for their result.
3. The nearby code's conventions, only where no rule applies. A pattern in
   the nearby code that breaks a rule is not copied.

The design rules apply to the code a ticket adds or modifies; untouched code
is not restructured. The standards review follows the same order and does not
report code that departs from nearby code to follow a rule.

Each review aspect checks its own concern, without overlap:

| Aspect | Checks |
|---|---|
| `design` | The design rules above |
| `slop` | Unrequested scope, speculative abstractions, duplicated code, hidden failures, and leftovers |
| `standards` | Repository instructions, consistency with nearby code, compatibility, and error handling |
| `tests` | Criterion coverage, assertion strength, error and boundary cases, test doubles, and isolation |
| `security` | Access control, injection, input validation, secrets, sensitive data, and dependencies |

## Customize

- **Change what an agent does or checks**: edit its file in
  `.claude/ticket-to-pr/agents/`. The file is the agent's whole set of
  instructions.
- **Add a review aspect**: add `agents/reviewer-<aspect>.md`, for example
  `reviewer-performance.md`, with its checklist.
- **Remove a review aspect**: delete its `reviewer-*.md` file.
- **Spec, delivery, commands, and branches**: edit `config.json`.

```json
{
  "spec": "ticket",
  "delivery": "commit",
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

From 0.3.0 the default no longer asks for approval or opens a pull request.
To keep the 0.2 behavior, set `"spec": "approve"` and `"delivery": "pr"` in
`config.json`.

## Why it is cheap

Each agent starts with a fresh context and passes work through files in
`.ticket-to-pr/<ticket>/`, which is added to `.git/info/exclude`. The
coordinator never reads source, diffs, logs, or instruction files, so its
conversation stays small however many rounds run. Verification commands run
before any AI review, so a failing test costs no review tokens. Each reviewer
reads only its own checklist.

The default checklists adapt material from AWS AI-DLC's knowledge files: the
corner checklist, the testing and security guides, the brownfield code
generation guide, and the reviewer guides. The design rules adapt the
purpose-driven design ideas from minodriven's public talks.

## Requirements

- Claude Code
- GitHub CLI (`gh`), authenticated, for issues and pull requests
