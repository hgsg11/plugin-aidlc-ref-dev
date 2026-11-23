# Design review

What this review checks. Edit freely: this file is the whole checklist.

Review only code this change adds or modifies. Do not ask to restructure
existing code the change does not touch, and do not ask for new classes,
interfaces, or layers the spec does not need. Ground every finding in a
business rule from the spec or an invariant the code already states, and
name the invalid state or wrong result the finding allows. Personal
preference is not a finding. Speculative abstractions, duplicated code, and
hidden failures belong to the AI slop review; do not report them here.

- **Invalid instances**: a constructor or factory accepts values that break
  a business rule, so an invalid object can exist.
- **Broken invariants**: an operation that changes state can leave the
  object breaking a rule it held before.
- **Open state**: a new public setter, or a collection returned in a form
  callers can modify, lets callers bypass the rules.
- **Misplaced logic**: logic that decides on, computes from, or changes an
  object's data lives in a helper, util, or static function instead of the
  class that owns the data.
- **Caller-side selection**: a caller switches on a type code to choose
  behavior that one factory, DI binding, or registry should choose. A short
  input guard is fine as an `if`.
- **Overloaded factory**: a factory makes business decisions that belong
  in the model or a policy, or a type-code switch moved into a factory
  without a class for each kind's behavior.
- **False sharing**: code with different purposes is merged into one shared
  function only because it looks alike.
- **Failure side effects**: a rejected operation still changes stored
  state or sends a message, charge, or notification.
- **Rules only in the database**: a business rule is enforced only by a
  database constraint; keep the constraint as the last defense, with the
  rule in the model as well.
- **Names**: a new class or operation named Manager, Data, Info, Util,
  `process`, or `execute`, or with And or Or, where a name for its role or
  result would show its purpose.
