# ticket-to-pr-lite

A Claude Code plugin that takes a GitHub issue to a pull request without AIDLC.
It checks the spec for contradictions before any code is written, asks the
person once, then loops implementation, verification, and review until the
change is clean.

```text
/ticket-to-pr-lite:ticket-to-pr https://github.com/owner/repo/issues/123
```

It is a skill, so asking Claude to implement an issue and open a PR, for
example "implement issue #123 and open a PR", also starts it.

## Flow

1. **Spec.** The analyst writes `spec.md` with testable acceptance criteria
   (`AC1`, `AC2`, ...) grounded in the code. A separate spec reviewer checks
   it for contradictions, conflicts with the code and documentation,
   ambiguity, untestable criteria, and missing cases. Findings the code
   answers are fixed automatically, for at most three rounds.
2. **One approval.** The person answers the design decisions the spec reviewer
   raised and approves the spec.
3. **Implement and verify.** The implementer writes the change and tests. The
   coordinator runs the auto-fix commands, then the verification commands;
   only when they pass do the
   reviewers (tests, security, standards, slop, and any aspect the repository
   adds) run in parallel. Every finding
   must be fixed, however minor. The loop allows the first implementation plus
   three fix rounds; anything left after that stops the run without a PR.
4. **Pull request.** The coordinator commits, pushes, and opens the PR with
   the acceptance criteria mapped to tests.

## Why it is cheap

Each agent starts with a fresh context and passes work through files in
`.ticket-to-pr/<ticket>/`. The coordinator never reads source, diffs, or logs,
so its conversation stays small however many rounds run. Verification
commands run before any AI review, so a failing test costs no review tokens.

## Setup per repository

Run the init skill once in a repository:

```text
/ticket-to-pr-lite:init
```

It creates `.claude/ticket-to-pr/` with the detected verification commands and
an empty rule file for each agent. Commit the directory so the whole team uses
the same settings. Every file in it is optional.

```text
.claude/ticket-to-pr/
  config.json                fix, verify, baseBranch, branchName, prTemplate
  rules/
    analyst.md               how specs are written
    spec-reviewer.md         what the spec check looks for
    implementer.md           implementation rules
    reviewer-tests.md        tests review
    reviewer-security.md     security review
    reviewer-standards.md    standards review
    reviewer-slop.md         slop review
    reviewer-<aspect>.md     any extra review aspect, run in parallel
```

```json
{
  "fix": [
    { "name": "format", "run": "gofmt -w {files}", "glob": "*.go" },
    { "name": "imports", "run": "goimports -w {files}", "glob": "*.go" }
  ],
  "verify": [
    { "name": "test", "run": "go test ./..." },
    { "name": "lint", "run": "golangci-lint run" }
  ],
  "baseBranch": "main",
  "branchName": "ticket/{id}-{slug}",
  "prTemplate": ".github/pull_request_template.md"
}
```

`fix` commands correct formatting and lint issues in place, so they never use
up a review round. The coordinator runs them after each implementation round,
before `verify`. `{files}` is replaced with the files the ticket changed, so
unrelated files are never reformatted; `glob` limits them to the file types
the tool accepts. `verify` commands only check and must
not modify files.

Each agent reads only its own rule file, so rules for one agent add nothing
to the others' context. A rule file starts with `mode: append` (add to the
built-in checks, the default) or `mode: replace` (use instead of them):

```markdown
---
mode: append
---
- Every external API call sets a timeout. A missing timeout caused an outage
  before; see internal/client/http.go.
- Never log email or phone numbers; use mask.PII().
```

Adding `rules/reviewer-<aspect>.md`, for example `reviewer-performance.md`,
adds a review aspect defined entirely by that file.

Without `fix` or `verify`, the analyst proposes commands in the spec and they
are saved to `config.json` after the person approves them.

The work directory `.ticket-to-pr/` is added to `.git/info/exclude`, so it is
never committed.

## Requirements

- Claude Code
- GitHub CLI (`gh`), authenticated, for issues and pull requests
