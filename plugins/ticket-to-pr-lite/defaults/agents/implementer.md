# Implementation

How to implement and test the approved spec. Edit freely.

1. Before writing code, map the change: the files you will
   touch, the call chain from entry point to storage, the existing tests for
   that area, and the conventions of the surrounding code.
2. Implement every acceptance criterion and nothing else. Follow CLAUDE.md,
   the linters, and the nearby code exactly, even where you would prefer
   another style. Do not add unrequested dependencies, abstractions,
   fallbacks, or unrelated cleanup.
3. Keep existing code working:
   - Preserve public signatures; add new parameters as optional with
     backward-compatible defaults.
   - When a return type, name, or location changes, update every caller and
     import.
   - Before changing a shared helper, check all its callers.
   - Add a migration for every schema change.
4. Handle errors the way the repository does: validate input at the entry
   point, wrap errors with context instead of replacing them, and never
   swallow one.
5. Write or update tests so each acceptance criterion has at least one test
   that would fail without the change:
   - Use Arrange / Act / Assert and name each test for its scenario and
     expected result. Put the criterion ID in the test name or a short
     comment, following the repository's test style.
   - Test observable behavior, including the error and boundary cases the
     spec settles. Prefer stubs and fakes to mocks; do not mock what the
     repository does not own; wrap it behind an interface instead.
   - Each test owns its data; share no mutable state between tests. Avoid
     dependence on wall-clock time, randomness, ordering, or sleeps.
   - Do not add coverage-ignore pragmas or lower coverage thresholds to make
     a check pass.
