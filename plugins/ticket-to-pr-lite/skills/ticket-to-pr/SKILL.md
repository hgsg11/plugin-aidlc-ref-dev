---
name: ticket-to-pr
description: Implements a GitHub issue (URL, number, or pasted ticket text) by looping implementation, verification, and reviews in fresh-context agents until clean. By default it asks the person nothing, treats the ticket as the spec, and ends with a commit; config.json can add a spec check, a one-time approval, and a pull request. Use when the person asks to implement an issue or ticket.
argument-hint: "<issue URL | issue number | ticket text>"
allowed-tools: ["Bash", "Read", "Write", "Agent", "Task", "AskUserQuestion"]
---

# Ticket to PR (lite)

Request: $ARGUMENTS

You are the coordinator. Your job is to move files between agents and decide
the next step; the agents do the reading and writing. Keep this conversation
small:

- Never read source files, diffs, full logs, instruction files, or whole
  agent reports. Read only the short summaries agents return and the counts they
  report.
- Pass work between agents by file path, never by pasting content.
- Ask the person something only when `spec` is `approve`, and only in the
  step that says so.
- Write messages to the person in the language they use.

## Repository settings

Everything this workflow uses from the repository is in
`.claude/ticket-to-pr/` at the repository root. Look nowhere else for
settings or instructions.

- `config.json` holds these keys; every key is optional:
  - `spec`: how the spec is made. `ticket` (default) uses the ticket text as
    the spec. `check` has the analyst write a spec and the spec reviewer
    check it, and settles open decisions by the recommended option without
    asking. `approve` does the same check and then asks the person once.
  - `delivery`: how the run ends. `commit` (default) commits and stops. `pr`
    also pushes and opens a pull request.
  - `fix` and `verify`: each a list of `{"name", "run"}` commands; a `fix`
    command may also set `glob`, such as `"*.go"`.
  - `baseBranch`; `branchName`, a template with `{id}` and `{slug}`, default
    `ticket/{id}-{slug}`; and `prTemplate`, a path used when `delivery` is
    `pr`.
- `agents/<agent>.md` holds each agent's instructions. Each agent reads its
  own file; do not read them yourself.
- Review aspects are the names of the `agents/reviewer-<aspect>.md` files.

Before anything else, read `config.json` if it exists and check that
`.claude/ticket-to-pr/agents/` contains `implementer.md` and at least one
`reviewer-*.md`, plus `analyst.md` and `spec-reviewer.md` when `spec` is
`check` or `approve`. When `spec` is `ticket`, `config.json` must also have
at least one `verify` command. If any of this is missing, or `spec` or
`delivery` has another value, stop and tell the person to run
`/ticket-to-pr-lite:install` or fix `config.json`. If an agent returns
`error=missing <path>`, stop and tell the person the same.

## Setup

1. Resolve the ticket. For a URL or number, run
   `gh issue view <ref> --json number,title,url` to get the number and title.
   For pasted text, use `local-<yyyymmdd-hhmm>` as the ticket id and save the
   text as `ticket.md` in the work directory.
2. Create the work directory `.ticket-to-pr/<ticket id>/` and make sure git
   ignores it: add `.ticket-to-pr/` to `.git/info/exclude` if it is not there.
3. The base branch is `baseBranch`, otherwise the repository's default branch.
4. If the current branch is the base branch or the default branch, create and
   switch to a branch named from `branchName`. Record the base commit with
   `git merge-base HEAD origin/<base branch>` in `<workdir>/base.txt`.

## Phase 1: Spec

### When `spec` is `ticket`

Write the spec without reading it: for an issue, run
`gh issue view <ref> --json title,body --template '# {{.title}}{{"\n\n"}}{{.body}}' > <workdir>/spec.md`;
for pasted text, copy `<workdir>/ticket.md` to `<workdir>/spec.md`. Go to
Phase 2.

### When `spec` is `check` or `approve`

1. Dispatch `ticket-to-pr-lite:analyst` in `write` mode with the ticket
   reference and the work directory. It writes `<workdir>/spec.md`.
2. Spec review loop, at most three rounds:
   - Dispatch `ticket-to-pr-lite:spec-reviewer` with the work directory and
     the round number. It writes `<workdir>/spec-findings-<round>.md` and
     returns the number of `resolvable` and `decision` findings.
   - If there are no `resolvable` findings, leave the loop.
   - Otherwise dispatch the analyst in `revise` mode with that findings file.
     It fixes the resolvable findings from evidence and records how.
   - Findings still `resolvable` after the third round become `decision`
     findings.
3. When `spec` is `check` and there are `decision` findings, dispatch the
   analyst in `revise` mode with the last findings file and the instruction
   to apply the recommended option of each `decision` finding. It records
   each one under `## Decisions` as not confirmed by the person. Do not ask
   the person.
4. When `spec` is `approve`, ask the person once with `AskUserQuestion`:
   - one question per `decision` finding (at most three; if there are more,
     list the rest in the message and ask for them in a single free-text
     question), using the options the spec reviewer proposed;
   - a final question: approve the spec (`Approve` / `Request changes`),
     showing the acceptance criteria IDs with one line each and the auto-fix
     and verification commands.

   If the person answered decisions or requested changes, dispatch the
   analyst in `revise` mode with their answers, then run the spec reviewer
   once more. Ask again only if new `decision` findings appear or the person
   asked for changes. Do not start Phase 2 without an explicit `Approve`.
5. If `config.json` has no `fix` or no `verify`, write the auto-fix and
   verification commands from the spec into it, creating the file if needed.

## Phase 2: Implement and verify

Run at most four rounds: the first implementation plus three fix rounds.

1. Dispatch `ticket-to-pr-lite:implementer` with the work directory and, from
   the second round on, the path of `<workdir>/findings-<previous round>.md`.
2. Stage all changes with `git add -A` so reviewers see new files in
   `git diff <base>`.
3. Run each `fix` command. Replace `{files}` in it with the changed files from
   `git diff --cached --name-only --diff-filter=ACMR <base> -- '<glob>'`
   (omit `-- '<glob>'` when the command has no `glob`), space-separated and
   shell-quoted; skip a command that uses `{files}` when there are none.
   Run it as `<run> > <workdir>/fix-<round>-<name>.log 2>&1`. A fix command
   that exits non-zero does not fail the round; verification decides. Then
   stage again with `git add -A`.
4. Run each verification command yourself:
   `<run> > <workdir>/verify-<round>-<name>.log 2>&1; echo "exit=$?"`.
   Read only the exit codes. If any command fails, write
   `<workdir>/findings-<round>.md` listing each failed command and its log
   path, and go to the next round without running the reviewers.
5. When every command passes, dispatch `ticket-to-pr-lite:reviewer` once per
   review aspect, all in parallel, each with the aspect name, the work
   directory, and the round. Each writes
   `<workdir>/review-<round>-<aspect>.md` and returns its finding count.
6. If every reviewer reports zero findings, go to Phase 3. Otherwise write
   `<workdir>/findings-<round>.md` listing the review files that have
   findings, and go to the next round.
7. If the fourth round still has failures or findings, stop. Do not commit,
   push, or open a PR. Tell the person which checks or findings remain and
   where the files are.

## Phase 3: Deliver

1. Commit the staged changes with a message that names the ticket.
2. When `delivery` is `commit`, stop here. Do not push or open a pull
   request; delivery belongs to whoever started this workflow. Report the
   commit, the verification commands that passed, the number of rounds, and
   the path of `<workdir>/traceability.md`.
3. When `delivery` is `pr`:
   1. Push the branch with `git push -u origin HEAD`.
   2. Write the PR body to `<workdir>/pr-body.md`. If `prTemplate` is set,
      fill in that template's sections. Otherwise state what changed, list
      the verification commands that passed and the number of review rounds,
      and append `<workdir>/traceability.md` with `cat >>` without reading
      it. End with `Closes #<number>` when the ticket is a GitHub issue.
   3. Create the PR with
      `gh pr create --base <base branch> --body-file <workdir>/pr-body.md`
      and a title that names the change.
   4. Report the PR URL to the person.
