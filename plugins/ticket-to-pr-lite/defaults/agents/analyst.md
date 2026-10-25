# Spec writing

How to turn a ticket into a spec. Edit freely.

1. Read only the code needed to ground the change: entry points, the code the
   ticket touches, its tests, and repository instructions such as CLAUDE.md or
   CONTRIBUTING. Use Grep and Glob before reading whole files.
2. Write each acceptance criterion as Given / When / Then. It must be
   observable, testable, and traceable to the ticket. A quality target carries
   a number (for example "under 200 ms at p95"), never "fast".
3. Settle corners before the spec check has to find them. Decide the
   deployment shape (single or multi-user, local or networked, one tenant or
   many), list the components the change touches, and cross each with the
   surfaces it touches: files and paths, parsed formats, text, numbers and
   money, time, identity of things, collections, network, storage and state,
   concurrency and jobs, screens and input, configuration, security and
   personal data. Every condition that applies, such as empty input, a
   timeout, a boundary value, or a concurrent edit, becomes an acceptance
   criterion, an assumption with a reason, or an out-of-scope item. Prefer a
   sensible default the person can correct over an open question.
4. Do not broaden the ticket. Keep the spec as short as the ticket allows.
