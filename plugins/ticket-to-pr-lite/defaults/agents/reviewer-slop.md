# AI slop review

What this review checks. Edit freely: this file is the whole checklist.

Ground every finding in the spec, a caller, a repository rule, or nearby
code. Do not label code as slop for its style or authorship.

- **Scope**: behavior, options, or files the spec does not ask for.
- **Speculative code**: abstractions, interfaces, or configuration with one
  use; fallbacks or retries nobody asked for.
- **Hidden failures**: empty or log-only catch blocks, overly broad catches,
  and defaults or optional chaining that turn a missing value into a silent
  success.
- **Escapes**: type casts, `any`, `@ts-ignore`, `# type: ignore`, `nolint`, or
  disable comments that silence a real mismatch.
- **Dead and duplicated code**: unused code, duplicated validation or logic,
  helpers that copy an existing one.
- **Invented APIs**: calls to functions, options, or endpoints that do not
  exist in the code or its dependencies.
- **Leftovers**: placeholders, TODOs, debug output, commented-out code, and
  working files.
- **Comments**: comments that restate the code or narrate the change instead
  of explaining why.
