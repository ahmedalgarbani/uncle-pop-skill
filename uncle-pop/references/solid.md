# SOLID — Reference

Source: Robert C. Martin, *Agile Software Development: Principles, Patterns, and Practices* and *Clean Architecture* (Part III).

SOLID tells us how to arrange functions and data into classes/modules, and how those should be interconnected, so that software **tolerates change, is easy to understand, and is reusable**.

---

## S — Single Responsibility Principle (SRP)

> **A module should be responsible to one, and only one, actor.**

Not "do one thing" (that's for functions). It's about *who asks for changes*.

**Symptoms:** a class changes for unrelated reasons; merge conflicts between teams in the same file; names like `Manager`, `Utils`, `Helper`, `Service` with 30 methods.

```ts
// Bad: CFO (pay), COO (hours) and DBA (save) all change this class
class Employee {
  calculatePay() {}
  reportHours() {}
  save() {}
}

// Good: separate per actor; a facade can keep the API convenient
class PayCalculator   { calculatePay(e: EmployeeData) {} }
class HourReporter    { reportHours(e: EmployeeData) {} }
class EmployeeSaver   { save(e: EmployeeData) {} }
```

## O — Open–Closed Principle (OCP)

> **A software artifact should be open for extension but closed for modification.**

Add new behaviour by adding new code, not by editing old code. Achieved by separating things that change for different reasons (SRP) and organizing dependencies (DIP) so higher-level components are protected from lower-level changes.

**Symptoms:** every new type means editing the same `switch`/`if-else` chain in several places.

```py
# Bad
def area(shape):
    if shape.kind == "circle": return pi * shape.r ** 2
    if shape.kind == "square": return shape.side ** 2
    # every new shape edits this function

# Good
class Shape(Protocol):
    def area(self) -> float: ...

class Circle:
    def __init__(self, r: float): self.r = r
    def area(self) -> float: return pi * self.r ** 2
```

**Pragmatism:** apply OCP where change actually happens. Don't build plugin systems for things that never vary.

## L — Liskov Substitution Principle (LSP)

> **Subtypes must be substitutable for their base types** without the caller knowing or caring.

**Symptoms:** `instanceof`/type checks in callers; overridden methods that throw `NotImplemented`; subclasses that strengthen preconditions or weaken postconditions. Classic: `Square extends Rectangle` breaks `setWidth`/`setHeight` expectations.

LSP also applies to **interfaces and REST APIs**: every implementation of a contract must honour it, or the system fills up with special cases.

**Fix:** redesign the hierarchy, prefer composition, or split the interface so each implementer can honour it fully.

## I — Interface Segregation Principle (ISP)

> **Clients should not be forced to depend on methods they do not use.**

**Symptoms:** fat interfaces; implementers with empty or throwing methods; recompiling/redeploying a module because an unrelated method of an interface changed.

```java
// Bad
interface Worker { void work(); void eat(); }
class Robot implements Worker { public void eat() { throw new UnsupportedOperationException(); } }

// Good
interface Workable { void work(); }
interface Feedable { void eat(); }
class Robot implements Workable { public void work() { /*...*/ } }
```

At architecture level: don't depend on a module/framework that carries baggage you don't need.

## D — Dependency Inversion Principle (DIP)

> **High-level policy should not depend on low-level details. Both should depend on abstractions. Abstractions are owned by the high-level side.**

**Rules of thumb (Clean Architecture ch. 11):**
- Don't refer to volatile concrete classes; refer to interfaces. Use factories to create them.
- Don't derive from volatile concrete classes.
- Don't override concrete functions.
- Never mention the name of anything concrete and volatile.
- Stable things (e.g. `String`, standard library) are fine to depend on directly.

```ts
// Bad: use case depends on a concrete DB
class PlaceOrder {
  private db = new PostgresOrderTable();
}

// Good: use case owns the port; infrastructure implements it
interface OrderRepository { save(order: Order): Promise<void>; }  // in the core

class PlaceOrder {
  constructor(private readonly orders: OrderRepository) {}
}

class PostgresOrderRepository implements OrderRepository { /* in infrastructure */ }
```

---

## Quick diagnostic table

| You see… | Likely violated | Typical fix |
|----------|-----------------|-------------|
| Class changes for many unrelated reasons | SRP | Split by actor; Facade if needed |
| Same `switch` on type in many places | OCP | Polymorphism / Strategy / Factory |
| `if (x instanceof Special)` in client code | LSP | Fix hierarchy; composition |
| Implementers throw `NotImplemented` | ISP (and LSP) | Split interface by client |
| `new ConcreteThing()` inside business logic | DIP | Inject an abstraction owned by the core |
| Business code imports ORM/HTTP/framework | DIP + Dependency Rule | Port/Adapter |

## When NOT to apply

- One implementation, no test seam needed, no realistic change → an interface is noise.
- Scripts and throwaway prototypes.
- Languages with first-class functions often satisfy OCP/DIP with a plain function parameter instead of an interface + class.
