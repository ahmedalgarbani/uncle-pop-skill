# Clean Code — Reference

Source: Robert C. Martin, *Clean Code: A Handbook of Agile Software Craftsmanship*.

> "Clean code reads like well-written prose." — Grady Booch (quoted in *Clean Code*)

## 1. Meaningful names

| Rule | Bad | Good |
|------|-----|------|
| Reveal intent | `int d; // elapsed days` | `int elapsedTimeInDays` |
| Avoid disinformation | `accountList` (it's a `Set`) | `accounts` |
| Make meaningful distinctions | `getActiveAccount()` / `getActiveAccountInfo()` | one clear name |
| Pronounceable & searchable | `genymdhms`, `7` | `generationTimestamp`, `MAX_CLASSES_PER_STUDENT` |
| No encodings | `strName`, `IShapeFactory`, `m_count` | `name`, `ShapeFactory`, `count` |
| Classes = nouns | `Manager`, `Processor`, `Data` | `Customer`, `InvoiceParser` |
| Methods = verbs | `amount()` (changes state) | `withdraw(amount)` |
| One word per concept | `fetch` / `retrieve` / `get` mixed | pick one |
| Use domain names | `list1` | `pendingOrders` |
| Length matches scope | `i` as a class field | `i` in a 3-line loop is fine |

## 2. Functions

- **Small.** Then smaller. Blocks inside `if`/`while` should usually be one line — a call.
- **Do one thing.** A function does one thing if you cannot extract another function from it with a name that is not merely a restatement.
- **One level of abstraction per function.** Don't mix `getHtml()` with `.append("\n")`.
- **Stepdown Rule.** Read top to bottom: each function is followed by those at the next level down.
- **Switch statements** are tolerated once, buried in a factory, creating polymorphic objects.
- **Arguments:** 0 ideal, 1 good, 2 OK, 3 needs justification, 4+ → introduce a parameter object.
- **No flag arguments.** `render(true)` → `renderForSuite()` / `renderForSingleTest()`.
- **No output arguments.** `appendFooter(report)` → `report.appendFooter()`.
- **No side effects.** `checkPassword()` must not also initialize the session.
- **Command–Query Separation.** Either change state or answer a question, not both.
- **Prefer exceptions to error codes.** Extract `try/catch` bodies into their own functions; error handling is "one thing".
- **DRY.** Duplication is the root of much evil in software.

```ts
// Bad: three levels of abstraction, flag argument, side effect
function process(user: User, save: boolean) {
  if (user.email.indexOf("@") < 0) throw new Error("bad");
  user.name = user.name.trim().toLowerCase();
  if (save) db.query(`INSERT INTO users ...`);
  mailer.send(user.email, "Welcome!");
}

// Good
function registerUser(user: User): void {
  validateEmail(user.email);
  const normalized = normalizeName(user);
  userRepository.save(normalized);
  welcomeNotifier.notify(normalized);
}
```

## 3. Comments

Comments are, at best, a necessary evil — they compensate for our failure to express ourselves in code.

**Good comments:** legal headers, explanation of intent ("why"), clarification of an obscure external API, warning of consequences, `TODO` with an owner, amplification of something that looks unimportant, public API docs.

**Bad comments:** mumbling, redundant (restating code), misleading, mandated (`@param name the name`), journal/changelog comments, noise, position markers (`/////// Actions //////`), closing-brace comments, attributions (`// added by Bob`), **commented-out code** (delete it — VCS remembers), HTML in comments, non-local information, too much information.

```py
# Bad
# check if employee is eligible for full benefits
if (employee.flags & HOURLY_FLAG) and employee.age > 65:

# Good
if employee.is_eligible_for_full_benefits():
```

## 4. Formatting

- **Newspaper metaphor:** high-level at the top, details below.
- **Vertical openness:** blank lines separate concepts.
- **Vertical density:** related lines stay together.
- **Vertical distance:** declare variables close to use; callers above callees.
- **Horizontal:** keep lines short (~100–120 chars).
- **Team rules beat personal taste.** Use the formatter (Prettier, Black, gofmt, rustfmt…) and never argue about it again.

## 5. Objects and data structures

- **Objects** hide data and expose behaviour. **Data structures** expose data and have no behaviour. Don't make hybrids.
- Procedural code makes adding functions easy; OO code makes adding types easy. Choose by which change you expect.
- **Law of Demeter:** a method should call methods only on itself, its arguments, objects it creates, and its fields. Avoid train wrecks: `ctx.getOptions().getScratchDir().getAbsolutePath()`.
- **DTOs** are fine at boundaries; keep them free of business logic.

## 6. Error handling

- Use exceptions (or the idiomatic `Result`/`Either`/`error` value) rather than return codes.
- Write the `try/catch/finally` first when writing code that can fail.
- Provide context with each exception: operation and failure reason.
- Define exception classes by how the caller needs to catch them; wrap third-party APIs.
- **Special Case pattern** (Null Object) instead of special-casing in callers.
- **Don't return null. Don't pass null.** Return empty collections, `Optional`, or a Special Case object.

## 7. Boundaries

- Wrap third-party code (maps, SDKs, HTTP clients) behind your own interface; don't let `Map<String, Sensor>` leak everywhere.
- Write **learning tests** for third-party APIs.
- Code against the interface you *wish* you had (Adapter) when the real one doesn't exist yet.

## 8. Unit tests

See `testing-tdd.md`. Short version: Three Laws of TDD, F.I.R.S.T., one concept per test, clean test code is as important as production code.

## 9. Classes

- Classes should be **small** — measured in *responsibilities*, not lines.
- Describe the class in ~25 words without "if", "and", "or", "but".
- **Cohesion:** methods use many of the class's fields. Low cohesion → split.
- Organize for change: Open–Closed and Dependency Inversion (see `solid.md`).
- Order: public static constants → private static vars → private instance vars → public functions → private helpers right after the public function that uses them.

## 10. Systems

- Separate **constructing** a system from **using** it. Wire dependencies in `main` / a composition root / DI container.
- Use **Dependency Injection**; don't `new` collaborators inside business logic.
- Scale up incrementally; architecture can grow if concerns are separated.
- Use standards wisely when they add demonstrable value.

## 11. Emergence — Kent Beck's four rules of simple design

In priority order, a design is simple if it:
1. Runs all the tests.
2. Contains no duplication.
3. Expresses the intent of the programmer.
4. Minimizes the number of classes and methods.

## 12. Concurrency

- Keep concurrency-related code separate from other code (SRP).
- Limit the scope of shared data; prefer copies and immutable data.
- Threads should be as independent as possible.
- Know your library (thread-safe collections, executors, async primitives).
- Keep synchronized sections small. Think about shutdown early.
- Test with more threads than processors; run on all target platforms; treat spurious failures as real.

## 13. Successive refinement

Write it dirty, then clean it. Working code is not enough — refactor in tiny steps with tests green after every step.
