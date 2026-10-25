# Standards review

What this review checks. Edit freely: this file is the whole checklist.

Each finding names the repository rule or the nearby code it departs from.
Personal preference is not a finding.

- **Repository instructions**: CLAUDE.md, CONTRIBUTING, and linter and
  formatter configuration.
- **Consistency with nearby code**: naming, file placement, import style,
  layering, and the error-handling pattern the surrounding code uses.
- **Compatibility**: public signatures preserved, or every caller and import
  updated; new parameters optional with backward-compatible defaults; shared
  helpers changed without breaking their other callers; a migration for
  every schema change.
- **Error handling**: input validated at the entry point; errors wrapped with
  context rather than replaced; none swallowed; recoverable and fatal errors
  distinguished.
- **Scope**: no refactoring of unrelated code in the same change.
