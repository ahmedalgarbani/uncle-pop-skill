# Uncle Pop Review Checklist

Walk through every section. Skip a section only if it truly does not apply (say so).

## 0. Context
- [ ] Language, framework, and purpose of the code understood
- [ ] Is this a script, library, service, or app? (scale the advice)
- [ ] Correctness first: any bugs, wrong edge cases, race conditions, security holes? (🔴)

## 1. Names (N1–N7)
- [ ] Names reveal intent; no `data`, `info`, `tmp`, `mgr`, single letters in wide scope
- [ ] Classes are nouns, functions are verbs, booleans read as predicates (`isActive`, `hasStock`)
- [ ] One word per concept, consistent across the codebase
- [ ] Side effects are named (`getOrCreateUser`, not `getUser`)
- [ ] No encodings / Hungarian notation

## 2. Functions (F1–F4, G30, G34)
- [ ] Small; does one thing; one level of abstraction
- [ ] ≤ 2–3 arguments; no flag/boolean selector arguments; no output arguments
- [ ] Command–Query Separation respected
- [ ] No hidden side effects or temporal coupling (G31)
- [ ] Nesting depth ≤ 2; guard clauses instead of arrow code

## 3. Comments & formatting (C1–C5)
- [ ] Comments explain *why*, not *what*
- [ ] No commented-out code, no changelog/author comments, no noise
- [ ] Consistent formatting (formatter/linter configured)
- [ ] Related code is vertically close; callers above callees

## 4. Error handling
- [ ] Exceptions/Result types instead of error codes
- [ ] No swallowed exceptions (`catch {}`), no generic `catch Exception` without reason
- [ ] Errors carry context
- [ ] No `null` returned or passed where avoidable; Special Case / Optional used
- [ ] Third-party exceptions wrapped at the boundary

## 5. General smells (G-series)
- [ ] No duplication (G5)
- [ ] No magic numbers/strings (G25)
- [ ] No dead code (G9) or clutter (G12)
- [ ] Conditionals encapsulated and positive (G28, G29)
- [ ] No feature envy (G14) or train wrecks (G36)
- [ ] Money/precision handled correctly (G26)
- [ ] Configuration kept at high levels (G35)

## 6. Classes & SOLID
- [ ] SRP — one actor / reason to change per class/module
- [ ] OCP — new variants added without editing existing `switch`/`if` chains
- [ ] LSP — no type checks on subtypes; overrides honour contracts
- [ ] ISP — no fat interfaces; no `NotImplemented` methods
- [ ] DIP — business logic depends on abstractions it owns; no `new Concrete()` of volatile things inside policy
- [ ] High cohesion; small public surface (G8)
- [ ] Composition preferred over inheritance

## 7. Architecture
- [ ] Dependency Rule: domain/use cases do not import framework, ORM, HTTP, UI, SDK types
- [ ] Ports (interfaces) are owned by the inner layer
- [ ] DTOs cross boundaries, not ORM entities / request objects
- [ ] Single composition root wires dependencies
- [ ] No cyclic module dependencies (ADP)
- [ ] Folder structure screams the domain
- [ ] Architecture proportional to project size (no speculative layers)

## 8. Design patterns
- [ ] Repeated type-switches → candidate for Strategy/State/Polymorphism
- [ ] Patterns present are justified by a real force (no Speculative Generality)
- [ ] No Singleton used as global mutable state

## 9. Tests (T1–T9)
- [ ] Tests exist for the changed behaviour, including boundaries (T5)
- [ ] F.I.R.S.T.; one concept per test; AAA structure; behavioural names
- [ ] Business logic testable without DB/network
- [ ] No skipped tests without explanation (T4)

## 10. Output
- [ ] Every finding has severity, location (or quoted fragment), principle/ID, problem, fix
- [ ] Refactored code for the most important finding is complete and runnable
- [ ] "What is already good" is specific
- [ ] Next steps ordered smallest-safe-first
