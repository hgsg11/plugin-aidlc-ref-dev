# Implementation

How to implement and test the approved spec. Edit freely.

1. Before writing code, map the change: the files you will
   touch, the call chain from entry point to storage, the existing tests for
   that area, and the conventions of the surrounding code.
2. Implement every acceptance criterion and nothing else. Follow the rules
   first: CLAUDE.md, the linters, and the design rules in step 5. Follow the
   nearby code's conventions only where no rule applies, and do not copy a
   pattern from it that breaks a rule. Do not add unrequested dependencies,
   abstractions, fallbacks, or unrelated cleanup.
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
5. Keep business rules in the model, in the code this change adds or
   modifies. Do not restructure code the change does not touch.
   - Validate in the constructor or factory so an object that breaks a
     business rule cannot exist, and keep every rule true after each
     operation that changes state.
   - Expose operations that state an intent, such as `approve()`, instead
     of public setters. Do not return a collection callers can modify.
   - Put logic that decides on, computes from, or changes an object's data
     in the class that owns the data, not in a helper, util, or static
     function.
   - Enforce each business rule in exactly one place. A database constraint
     may back it up but must not be the only place.
   - When an operation is rejected, leave stored state unchanged and send no
     message, charge, or notification.
   - Choose between implementations in one factory, DI binding, or
     registry, not with type-code switches in callers. A short input guard
     can stay an `if`.
   - Do not merge code with different purposes because it looks alike.
   - Name classes for their role and operations for their result; avoid
     Manager, Data, Info, Util, `process`, `execute`, And, and Or.
6. Write or update tests so each acceptance criterion has at least one test
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
