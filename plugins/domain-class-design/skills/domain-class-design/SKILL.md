---
name: domain-class-design
description: Designs or reviews a domain model as a Mermaid class diagram, including class and operation names, then judges whether the diagram can solve the stated problem. Use when the person asks to design domain classes, value objects, entities, aggregates, or policies, to draw or check a class diagram, or to name domain classes. Do not use to explore why a problem matters, to write or review code, or to choose a system architecture.
allowed-tools: ["Read", "Grep", "Glob", "Write"]
---

# Domain class design

Request: $ARGUMENTS

Write to the person in the language they use.

1. Read `rules.md` in this skill's base directory, which Claude Code shows
   when it loads this skill. Apply its diagram rules and validity checks.
2. Take the problem, actors, and business rules from the request. If the
   person names existing code or tables, read them to find current rules and
   names. Do not ask the person to fill in a form; work from what is given.
   A business rule that is not stated or found in code is `unknown`; never
   invent one.
3. Draw the diagram as a Mermaid `classDiagram`. Group classes by purpose
   with `namespace`, type every attribute, show intent-revealing operations
   only, and attach each class's invariants and out-of-scope items as a
   `note`.
4. Judge the diagram with the validity checks and return:
   - the diagram;
   - a table mapping each business rule to the class and operation that
     enforce it, with `unknown` rules listed separately;
   - each validity check as pass or fail, with the reason for a failure;
   - the verdict: `solves`, `solves with open questions`, or `does not
     solve`;
   - what the diagram cannot settle, from `rules.md`.

Do not write implementation code. Write the result to a file only when the
person asks for one.
