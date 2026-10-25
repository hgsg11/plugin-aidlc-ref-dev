---
name: ticket-to-pr
description: Takes a GitHub issue (URL, number, or pasted ticket text) to a pull request. Checks the spec for contradictions before coding, asks the person once to approve it, then loops implementation, verification, and reviews in fresh-context agents until clean. Use when the person asks to implement an issue or ticket and open a PR.
argument-hint: "<issue URL | issue number | ticket text>"
allowed-tools: ["Bash", "Read", "Write", "Agent", "Task", "AskUserQuestion"]
---

# Ticket to PR (lite)

Request: $ARGUMENTS

You are the coordinator. Your job is to move files between agents and decide
the next step; the agents do the reading and writing. Keep this conversation
small:

- Never read source files, diffs, full logs, rule files, or whole agent
  reports. Read only the short summaries agents return and the counts they
  report.
- Pass work between agents by file path, never by pasting content.
- Write messages to the person in the language they use.

## Repository settings

Settings live in `.claude/ticket-to-pr/` at the repository root. Everything
there is optional.

- `config.json` may define `fix` and `verify` (each a list of
  `{"name", "run"}` commands; a `fix` command may also set `glob`, such as
  `"*.go"`), `baseBranch`, `branchName` (a template with `{id}` and `{slug}`, default
  `ticket/{id}-{slug}`), and `prTemplate` (a path).
- `rules/<agent>.md` holds the repository's rules for one agent: `analyst`,
  `spec-reviewer`, `implementer`, and `reviewer-<aspect>`.

When you dispatch an agent, check with `ls` whether its rules file exists and,
if it does, pass its path as `rules: <path>`. Do not read it yourself.

Review aspects are the built-in `tests`, `security`, `standards`, and `slop`,
plus one more for every other `rules/reviewer-<aspect>.md` file.

## Setup

1. Resolve the ticket. For a URL or number, run
   `gh issue view <ref> --json number,title,url` to get the number and title.
   For pasted text, use `local-<yyyymmdd-hhmm>` as the ticket id and save the
   text as `ticket.md` in the work directory.
2. Create the work directory `.ticket-to-pr/<ticket id>/` and make sure git
   ignores it: add `.ticket-to-pr/` to `.git/info/exclude` if it is not there.
3. Read `.claude/ticket-to-pr/config.json` if it exists. The base branch is
   its `baseBranch`, otherwise the repository's default branch.
4. If the current branch is the base branch or the default branch, create and
   switch to a branch named from `branchName`. Record the base commit with
   `git merge-base HEAD origin/<base branch>` in `<workdir>/base.txt`.

## Phase 1: Spec

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
3. Ask the person once with `AskUserQuestion`:
   - one question per `decision` finding (at most three; if there are more,
     list the rest in the message and ask for them in a single free-text
     question), using the options the spec reviewer proposed;
   - a final question: approve the spec (`Approve` / `Request changes`),
     showing the acceptance criteria IDs with one line each and the auto-fix
     and verification commands.
4. If the person answered decisions or requested changes, dispatch the analyst
   in `revise` mode with their answers, then run the spec reviewer once more.
   Ask again only if new `decision` findings appear or the person asked for
   changes. Do not start Phase 2 without an explicit `Approve`.
5. If `config.json` has no `fix` or no `verify`, write the approved auto-fix
   and verification commands from the spec into it, creating the file if
   needed.

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
   review aspect, all in parallel, each with its aspect name, the round, and
   its rules path if one exists. Each writes
   `<workdir>/review-<round>-<aspect>.md` and returns its finding count.
6. If every reviewer reports zero findings, go to Phase 3. Otherwise write
   `<workdir>/findings-<round>.md` listing the review files that have
   findings, and go to the next round.
7. If the fourth round still has failures or findings, stop. Do not commit,
   push, or open a PR. Tell the person which checks or findings remain and
   where the files are.

## Phase 3: Pull request

1. Commit the staged changes with a message that names the ticket, and push
   the branch with `git push -u origin HEAD`.
2. Write the PR body to `<workdir>/pr-body.md`. If `prTemplate` is set, fill
   in that template's sections. Otherwise state what changed, map each
   acceptance criterion ID to its tests, list the verification commands that
   passed and the number of review rounds. End with `Closes #<number>` when
   the ticket is a GitHub issue.
3. Create the PR with
   `gh pr create --base <base branch> --body-file <workdir>/pr-body.md` and a
   title that names the change.
4. Report the PR URL to the person.
