# Domain class diagram rules

## Boundaries and concepts

1. When one noun serves different purposes, make a class per purpose. For
   example, split `Product` into `OrderItem`, `StockItem`, and
   `ShippingItem`.
2. Do not copy table columns into classes. Derive attributes from the
   decisions each class must make.
3. Make hidden concepts such as approval, limit, deadline, eligibility, and
   quote into classes instead of leaving them as conditions.
4. When the rules change fundamentally with the situation, such as quote
   versus contract or individual versus corporate customer, use separate
   classes instead of a flag.
5. State what each class does not contain, as a note on the diagram.

## Rule ownership

6. Exactly one class enforces each business rule.
7. Choose the kind of class from the rule:
   - a constraint on a single value: value object;
   - identity and a lifecycle: entity;
   - several values that must stay consistent together: aggregate;
   - a decision that holds no state: policy.
8. Draw aggregate boundaries around the rules that must hold within one
   transaction.
9. Do not type business values as primitives; type them as value objects.

## Operations and relationships

10. Draw no setters. Draw only operations that state an intent, such as
    `approve()` or `addLine()`.
11. Use a strategy when behavior varies by kind, and a state when behavior
    varies by lifecycle state.
12. Name an interface for its caller's purpose. Draw no interface when there
    is one implementation and no evidence of another.
13. Do not make enforcing one rule require walking through many classes.
14. Draw a factory when creating an object needs validation or assembly of
    several objects. Select strategy implementations in one factory or
    registry, and keep business rules out of it.

## Naming

15. Name a class for its role in its context, an operation for its result,
    and an event in the past tense.
16. Treat Manager, Service, Common, Base, Data, Info, Util, And, and Or in a
    name as a sign to split the class.
17. When many members do not fit a class's name, split the class instead of
    renaming it.

## Validity checks

Run these after drawing the diagram.

- **Rule coverage**: every business rule maps to a class and an operation
  that enforces it.
- **Invalid data**: some single class can reject each kind of invalid data,
  such as a missing value, a value over its limit, or the same operation
  applied twice.
- **Forbidden transitions**: a forbidden state transition either cannot be
  expressed or is rejected.
- **Change locality**: each likely change stays within one purpose's
  classes.

## What a class diagram cannot settle

Report these as open, never as solved:

- concurrent updates, partial failures, retries, and duplicate requests;
- whether every writer, such as a batch, an admin tool, or direct SQL,
  goes through the model;
- existing data that already breaks a rule;
- whether the business rules themselves are correct.
