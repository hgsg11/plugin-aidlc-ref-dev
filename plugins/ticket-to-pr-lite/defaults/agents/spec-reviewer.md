# Spec check

What the spec check looks for. Edit freely: this file is the whole checklist.

## What to check

1. **Internal contradictions**: criteria, constraints, or assumptions that
   cannot all hold at once.
2. **Conflicts with the code**: behavior the spec requires that contradicts
   existing types, API contracts, persisted data, tests, or callers. Verify
   against the code; cite file and line.
3. **Conflicts with documentation**: README, design documents, or other
   features' stated behavior.
4. **Ambiguity**: wording two engineers could implement differently, such as
   "appropriately", "fast", or "handle errors". A quality target needs a
   number ("under 200 ms at p95", not "fast").
5. **Untestable criteria**: a criterion with no pass/fail outcome.
6. **Ticket fidelity**: the spec drops, broadens, or reinterprets something
   the ticket says; every criterion traces to the ticket.
7. **Unbounded scope**: what is out of scope is not stated.
8. **Unsettled corners**: see below.

## Corners

Most defects that survive a careful spec are corners: one component meeting
one unusual condition. Sweep for them instead of guessing:

1. Settle the deployment shape from the code: single or multi-user, local or
   networked, one tenant or many. Skip identity, tenant, and personal-data
   rows when the shape rules them out.
2. List the components the spec touches. Do not invent new ones.
3. Cross each component with the surfaces it touches below. Every condition
   that applies must end as an acceptance criterion, an assumption with a
   reason, or an out-of-scope item. A condition left silent is a finding.

- **Files and paths**: missing path, permission denied, two spellings of one
  path, odd names, escaping the root, half-written file, disk full, unknown
  files, changed after check.
- **Parsed formats**: one malformed record among good ones, truncated input,
  unknown or missing fields, delimiters inside values, encodings, empty input,
  duplicate keys, hostile input (bombs, unsafe deserialization).
- **Text**: empty or whitespace-only, very long, emoji and right-to-left,
  markup or control sequences, values that look equal but are not.
- **Numbers and money**: zero denominator, boundaries (0, 1, negative, max,
  inclusive vs exclusive), rounding that must add up, units, unknown vs zero,
  money as integer minor units or decimals, never floats.
- **Time**: time zones and daylight saving, clock skew, period edges (month
  end, leap day), ties and out-of-order events, implausible timestamps,
  behavior exactly at a deadline.
- **Identity of things**: two things with one name, one thing with several
  names, dangling references, records with no owner, external ids kept as
  opaque strings.
- **Collections**: empty, exactly one, very many (paging or a stated cap),
  some sources failed, deterministic ordering, group totals that reconcile.
- **Network**: timeouts, service down, unexpected status or body, retries
  that must not repeat side effects, rate limits, version skew.
- **Storage and state**: store unavailable, interrupted multi-step write,
  concurrent edits, two copies of one fact, cache freshness, migrations and
  rollback.
- **Concurrency and jobs**: two actors on one item, a job running twice or
  overlapping itself, killed mid-work, stuck work, a stale response arriving
  last, feedback loops.
- **Screens and input**: loading vs empty vs error, stale data, destructive
  actions, invalid input that keeps what was typed, double submit, unsaved
  input, client rules also enforced on the server, keyboard and screen
  reader access.
- **Configuration**: missing or invalid setting, conflicting sources, first
  run with no data, a missing or hanging external tool.
- **Security and personal data**: session expiry mid-flow, per-object
  authorization, revoked rights, tenant isolation, secrets, sensitive data in
  logs or URLs, retention and erasure.
- **AI output**: malformed output, ungrounded claims, untrusted content
  steering the model, context limits, consequential actions.
