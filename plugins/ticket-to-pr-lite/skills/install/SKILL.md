---
name: install
description: Installs ticket-to-pr-lite into the current repository by placing its agent instructions and config in .claude/ticket-to-pr/, or updates them after a plugin update without touching files the repository edited. Use when the person asks to install, set up, or update ticket-to-pr for a repository.
allowed-tools: ["Bash", "Read", "Grep", "Glob", "Write"]
---

# Install ticket-to-pr-lite

Place everything the `ticket-to-pr` skill uses in `.claude/ticket-to-pr/` at
the repository root. Write messages to the person in the language they use.

## 1. Place the agent instructions

1. Find the plugin root: two levels above this skill's base directory, which
   Claude Code shows when it loads this skill. If it is not shown, use the
   newest directory matching `~/.claude/plugins/cache/*/ticket-to-pr-lite/*/`.
2. Run `sh <plugin root>/skills/install/install.sh <plugin root> <repository root>`.
   Do not copy or rewrite the files yourself. The script:
   - adds missing default files to `.claude/ticket-to-pr/agents/`;
   - updates a default file the repository has not edited;
   - keeps a file the repository edited, and prints a `diff` command to
     compare it with the new default;
   - does not re-add a default file the repository deleted;
   - never touches files the repository added, such as extra review aspects;
   - records what it installed in `.claude/ticket-to-pr/.installed`.

## 2. Write config.json

Skip this step if `.claude/ticket-to-pr/config.json` exists. Otherwise detect
the settings and write it:

- **verify**: the commands CI runs for tests, lint, type checks, and format
  checks, from `Makefile`, `package.json` scripts, `go.mod`,
  `pyproject.toml`, `Cargo.toml`, and `.github/workflows/*.yml`. Prefer a
  Makefile or package script target over the raw command. These commands
  must not modify files.
- **fix**: the formatters and linters with a fix mode that the repository
  already configures, such as `gofmt -w`, `goimports -w`, `eslint --fix`,
  `prettier --write`, or `ruff check --fix`. Use `{files}` for the changed
  files and set `glob` to the file types each tool accepts.
- **baseBranch**: the default branch, from `gh repo view --json defaultBranchRef`.
- **prTemplate**: `.github/pull_request_template.md` if it exists; otherwise
  omit the key.

```json
{
  "fix": [{ "name": "format", "run": "gofmt -w {files}", "glob": "*.go" }],
  "verify": [{ "name": "test", "run": "go test ./..." }],
  "baseBranch": "main",
  "branchName": "ticket/{id}-{slug}"
}
```

## 3. Report

Show the script's output and the detected commands, and ask the person to
check the commands. Then explain:

- `.claude/ticket-to-pr/agents/<agent>.md` is each agent's whole set of
  instructions; edit it directly to change what that agent does or checks.
- Adding `agents/reviewer-<aspect>.md` adds a review aspect that runs in
  parallel with the others; deleting a `reviewer-*.md` file removes that
  aspect.
- Commit `.claude/ticket-to-pr/` so the whole team uses the same files.
- After a plugin update, run this skill again to bring in new defaults.
