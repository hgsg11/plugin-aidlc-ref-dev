---
name: init
description: Sets up a repository for ticket-to-pr-lite by creating .claude/ticket-to-pr/config.json with detected verification commands and rule file templates for each agent. Use when the person asks to set up or initialize ticket-to-pr for a repository.
allowed-tools: ["Bash", "Read", "Grep", "Glob", "Write"]
---

# Set up ticket-to-pr-lite

Create the repository settings that the `ticket-to-pr` skill reads. Never
overwrite a file that already exists; report it as kept instead. Write
messages to the person in the language they use.

## 1. Detect the settings

- **Verification commands**: read the build and CI files that exist, such as
  `Makefile`, `package.json` scripts, `go.mod`, `pyproject.toml`,
  `Cargo.toml`, and `.github/workflows/*.yml`. Choose the commands CI runs for
  tests, lint, type checks, and formatting checks. Prefer a single Makefile or
  package script target over the raw command when one exists.
- **Auto-fix commands**: the formatters and linters with a fix mode that the
  repository already uses, such as `gofmt -w`, `goimports -w`,
  `eslint --fix`, `prettier --write`, `ruff check --fix`, or `ruff format`.
  Write them with `{files}`, which stands for the changed files, so they never
  touch unrelated files, and set `glob` to the file types each tool accepts.
  Include only tools the repository already configures.
- **Base branch**: the repository's default branch, from
  `gh repo view --json defaultBranchRef` or
  `git symbolic-ref refs/remotes/origin/HEAD`.
- **PR template**: `.github/pull_request_template.md` or
  `.github/PULL_REQUEST_TEMPLATE.md`, if one exists.
- **Existing conventions**: note whether `CLAUDE.md` exists. Do not copy its
  content into the rule files; the agents already read it.

## 2. Write the files

Create `.claude/ticket-to-pr/config.json`:

```json
{
  "fix": [{ "name": "format", "run": "<command> {files}", "glob": "*.<ext>" }],
  "verify": [{ "name": "test", "run": "<command>" }],
  "baseBranch": "<default branch>",
  "branchName": "ticket/{id}-{slug}",
  "prTemplate": "<path, or omit the key>"
}
```

Create these rule files in `.claude/ticket-to-pr/rules/`, each starting with
front matter `mode: append` followed by a short comment that says what the
file is for and gives one example rule. Leave the rule list itself empty for
the person to fill in:

| File | Read by | Example rule for the comment |
|---|---|---|
| `analyst.md` | spec writer | Write acceptance criteria as Given / When / Then. |
| `spec-reviewer.md` | spec checker | Any change to billing behavior is a `decision` finding. |
| `implementer.md` | implementer | Database access goes only through the repository layer. |
| `reviewer-tests.md` | tests review | Every new HTTP handler has a table-driven test. |
| `reviewer-security.md` | security review | Every external API call sets a timeout. |
| `reviewer-standards.md` | standards review | Wrap errors with context using `fmt.Errorf("...: %w", err)`. |
| `reviewer-slop.md` | slop review | No new helper used from only one place. |

Pick example rules that fit the repository's language; the ones above are
for Go.

Also create `.claude/ticket-to-pr/rules/README.md` explaining:

- each agent reads only its own file, so rules cost nothing elsewhere;
- `mode: append` adds to the built-in checks and `mode: replace` replaces
  them;
- adding `reviewer-<aspect>.md` (for example `reviewer-performance.md`) adds a
  review aspect that runs in parallel with the others, defined entirely by
  that file;
- a good rule states the reason and points to an example in the code.

## 3. Report

List the files created and the files kept. Show the detected auto-fix and
verification commands and ask the person to check them. Remind them to commit
`.claude/ticket-to-pr/` so the whole team uses the same settings.
