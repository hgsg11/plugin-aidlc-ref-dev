# domain-class-design

A Claude Code plugin that designs a domain model as a Mermaid class diagram
and judges whether the diagram can solve the stated problem. It does not need
AIDLC.

## Install

```text
/plugin install domain-class-design@aidlc-ref-dev
```

## Run

```text
/domain-class-design:domain-class-design <problem, actors, and business rules>
```

Asking Claude to design domain classes, draw a class diagram, or name domain
classes also starts it. It does not explore why a problem matters, write
code, or choose a system architecture.

## Output

- A Mermaid `classDiagram` grouped by purpose, with each class's invariants
  and out-of-scope items as notes.
- A table mapping each business rule to the class and operation that enforce
  it. Rules that were not stated or found in code are listed as unknown.
- Four validity checks: rule coverage, invalid data, forbidden transitions,
  and change locality.
- A verdict: `solves`, `solves with open questions`, or `does not solve`.
- What a class diagram cannot settle, such as concurrency and existing data.

## Customize

The rules are in `skills/domain-class-design/rules.md`. The matching rules
for code are in `ticket-to-pr-lite`: its implementer follows them by default,
and its `design` review aspect checks them.

The rules adapt the purpose-driven design ideas from minodriven's public
talks: purpose-based boundaries, invariant-first modeling, purpose-centered
encapsulation, interface and implementation separation, and purpose-driven
naming.
