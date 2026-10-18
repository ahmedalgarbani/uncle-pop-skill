# Design Patterns — Reference

Sources: Gamma, Helm, Johnson, Vlissides — *Design Patterns* (GoF); patterns as used in Robert C. Martin's *Agile Software Development: Principles, Patterns, and Practices* and *Clean Architecture*.

> A pattern is a named solution to a recurring **force**. No force, no pattern.

## 1. Symptom → pattern table

| Symptom / force | Consider | Simpler alternative first? |
|-----------------|----------|----------------------------|
| `switch`/`if` on a type code repeated in many places | **Strategy**, **State**, polymorphism + **Factory** | A map/dict of functions |
| Algorithm skeleton fixed, steps vary | **Template Method** (inheritance) or **Strategy** (composition) | Pass a function |
| Object behaviour changes with its internal state | **State** | Enum + small `switch` if only 2–3 states |
| Need to add features to an object without subclass explosion | **Decorator** | Middleware / higher-order function |
| Third-party API doesn't match the interface you want | **Adapter** | — (always wrap boundaries) |
| Complex subsystem is hard to use | **Facade** | — |
| Constructor with many optional parameters | **Builder** | Named/keyword args, parameter object |
| Creation logic varies or must be hidden | **Factory Method**, **Abstract Factory** | Simple factory function |
| Many objects must react to an event | **Observer** / pub-sub | Callback list |
| Requests must be queued, logged, undone, retried | **Command** | — |
| A chain of handlers, each may handle or pass | **Chain of Responsibility** | Middleware pipeline |
| Tree of part/whole objects treated uniformly | **Composite** | — |
| Adding operations across a stable class hierarchy | **Visitor** (or *Acyclic Visitor*) | Pattern matching (`match`, sealed types) |
| Expensive or remote object; lazy load; access control | **Proxy** | — |
| Abstraction and implementation vary independently | **Bridge** | — |
| Many objects coordinate in tangled ways | **Mediator** | — |
| Need snapshot/restore of state | **Memento** | Immutable value + history list |
| Repeated `if (x == null)` checks | **Null Object / Special Case** | `Optional` |
| Hard-to-test UI/DB/IO mixed with logic | **Humble Object** | — |
| Iterate without exposing internals | **Iterator** | Language built-ins (generators) |
| Exactly one instance needed | **Singleton** ⚠️ | Create one instance in `main` and inject it |
| Many fine-grained shared objects, memory pressure | **Flyweight** | — |
| Clone pre-configured objects | **Prototype** | Copy constructor / spread |
| Small language/grammar to interpret | **Interpreter** | Parser library |

## 2. Catalogue (GoF)

### Creational
| Pattern | Intent | Watch out |
|---------|--------|-----------|
| **Abstract Factory** | Create families of related objects without naming concrete classes. | Adding a new product type changes every factory. |
| **Builder** | Separate construction of a complex object from its representation. | Overkill when the language has named args. |
| **Factory Method** | Let subclasses/implementations decide which class to instantiate. | Don't wrap a trivial `new`. |
| **Prototype** | Create new objects by cloning. | Deep vs shallow copy bugs. |
| **Singleton** | Ensure one instance with global access. | Global state, hidden dependencies, hard to test → prefer DI. |

### Structural
| Pattern | Intent | Watch out |
|---------|--------|-----------|
| **Adapter** | Convert one interface into another clients expect. | Keep it thin. |
| **Bridge** | Decouple abstraction from implementation so both vary. | Only when two independent axes truly vary. |
| **Composite** | Treat individual objects and compositions uniformly. | Leaf/child operations that don't make sense (ISP). |
| **Decorator** | Attach responsibilities dynamically. | Deep stacks are hard to debug. |
| **Facade** | Simple interface to a complex subsystem. | Becoming a god object. |
| **Flyweight** | Share fine-grained objects efficiently. | Only with measured memory problems. |
| **Proxy** | Surrogate controlling access to another object. | Hidden latency/side effects. |

### Behavioral
| Pattern | Intent | Watch out |
|---------|--------|-----------|
| **Chain of Responsibility** | Pass a request along handlers. | Request may go unhandled silently. |
| **Command** | Encapsulate a request as an object. | Class per action can bloat; closures often suffice. |
| **Interpreter** | Represent and evaluate a grammar. | Use a parser generator for anything non-trivial. |
| **Iterator** | Sequential access without exposing representation. | Usually built into the language. |
| **Mediator** | Centralize complex communication. | Mediator turning into a god object. |
| **Memento** | Capture/restore state without breaking encapsulation. | Memory cost. |
| **Observer** | One-to-many notification on change. | Leaks, ordering, cascades. |
| **State** | Behaviour varies with state; each state is a class. | Too many tiny classes for simple flags. |
| **Strategy** | Interchangeable algorithms behind one interface. | A function parameter may be enough. |
| **Template Method** | Skeleton algorithm with overridable steps. | Inheritance coupling — Strategy is often better. |
| **Visitor** | Add operations to a hierarchy without changing it. | Adding new element types is painful; cycles (use Acyclic Visitor). |

### Patterns Uncle Bob emphasises beyond GoF
| Pattern | Use |
|---------|-----|
| **Null Object / Special Case** | Replace `null` checks with an object that does the "nothing" behaviour. |
| **Humble Object** | Isolate hard-to-test behaviour so logic can be unit-tested. |
| **Active Object** | Command queue run by a single thread — simple concurrency. |
| **Acyclic Visitor** | Visitor without dependency cycle between visitor and hierarchy. |
| **Repository / Gateway** | Collection-like interface for persistence owned by the domain. |
| **Presenter / View Model** | Format use case output for the view; keep the view humble. |
| **Dependency Injection / Composition Root** | Wire everything in `main`. |

## 3. Example — Replace Conditional with Polymorphism (Strategy + Factory)

```ts
// Before: OCP violation, grows with every new payment method
function pay(method: string, amount: number) {
  if (method === "card")   { /* 30 lines */ }
  else if (method === "paypal") { /* 25 lines */ }
  else if (method === "crypto") { /* 40 lines */ }
}

// After
interface PaymentMethod { pay(amount: Money): Promise<Receipt>; }

class CardPayment   implements PaymentMethod { async pay(a: Money) { /* ... */ } }
class PayPalPayment implements PaymentMethod { async pay(a: Money) { /* ... */ } }

// The ONE switch, hidden in a factory (Clean Code ch. 3)
function paymentMethodFor(kind: PaymentKind): PaymentMethod {
  switch (kind) {
    case "card":   return new CardPayment();
    case "paypal": return new PayPalPayment();
  }
}
```

## 4. Rules for recommending a pattern

1. Name the force in one sentence before naming the pattern.
2. Show the smallest version of the pattern in the user's language.
3. Prefer composition over inheritance.
4. Prefer the language's idiom (first-class functions, pattern matching, decorators, traits) when it solves the same force with less code.
5. State when **not** to use it.
6. Never recommend Singleton as global state; recommend "one instance, created in `main`, injected".
