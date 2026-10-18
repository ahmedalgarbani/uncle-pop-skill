# Clean Architecture — Reference

Source: Robert C. Martin, *Clean Architecture: A Craftsman's Guide to Software Structure and Design*.

> "The goal of software architecture is to minimize the human resources required to build and maintain the required system."

## 1. Two values of software

- **Behaviour** — it does what's needed today.
- **Structure (architecture)** — it is easy to change tomorrow. This is the *greater* value: a system that works but cannot be changed becomes worthless when requirements change; a system that doesn't work but is easy to change can be made to work.

## 2. The Dependency Rule

```
        ┌──────────────────────────────────────────────┐
        │ Frameworks & Drivers (Web, DB, UI, devices)  │
        │   ┌──────────────────────────────────────┐   │
        │   │ Interface Adapters                   │   │
        │   │ (Controllers, Presenters, Gateways)  │   │
        │   │   ┌──────────────────────────────┐   │   │
        │   │   │ Use Cases (Application rules) │   │   │
        │   │   │   ┌──────────────────────┐   │   │   │
        │   │   │   │ Entities (Enterprise │   │   │   │
        │   │   │   │ business rules)      │   │   │   │
        │   │   │   └──────────────────────┘   │   │   │
        │   │   └──────────────────────────────┘   │   │
        │   └──────────────────────────────────────┘   │
        └──────────────────────────────────────────────┘
              Source code dependencies point INWARD only
```

**Nothing in an inner circle can know anything about something in an outer circle** — no names of classes, functions, variables, data formats, or frameworks.

| Layer | Contains | May import |
|-------|----------|-----------|
| **Entities** | Critical business rules and data; would exist even without software | Nothing outside itself (std-lib only) |
| **Use Cases** | Application-specific rules; orchestrate entities; define input/output ports and gateway interfaces | Entities |
| **Interface Adapters** | Controllers, presenters, view models, repository implementations, mappers | Use cases, entities |
| **Frameworks & Drivers** | Web framework, ORM, DB, UI, message bus, external APIs, `main` | Everything |

## 3. Crossing boundaries

When the flow of control goes outward (use case → database), use **Dependency Inversion**: the use case declares an interface (output port / gateway) and the outer layer implements it.

```
Controller ──> InputPort (interface) <── UseCaseInteractor ──> OutputPort (interface) <── Presenter
                                              │
                                              └──> Gateway (interface) <── SqlRepository
```

Data crossing a boundary is **simple data structures** (DTOs, request/response models), never ORM entities or framework objects.

## 4. Key ideas

- **Policy vs. details.** Business rules are policy. The database, web, frameworks, and UI are **details**. Defer decisions about details as long as possible.
- **The database is a detail.** Data model ≠ business model.
- **The web is a detail.** It's an I/O device.
- **Frameworks are details.** Don't marry the framework — keep it at arm's length behind adapters.
- **Screaming Architecture.** The top-level structure should scream *what the system does* (`orders/`, `billing/`, `inventory/`), not *which framework it uses* (`controllers/`, `models/`, `views/`).
- **Humble Object.** Split hard-to-test behaviour (UI, DB, network) into a humble part with almost no logic, and a testable part with all the logic (Presenter/View, Gateway/Interactor).
- **The Main component** is the dirtiest low-level plugin: it creates factories, wires dependencies, reads config, then hands control to the high-level policy.
- **Tests are part of the system** — the outermost circle. Don't couple tests to volatile structure; use a testing API.
- **Partial boundaries** (skip the last step, strategy, facade) are a legitimate cheaper option when a full boundary isn't justified yet.

## 5. Component principles

### Cohesion — which classes belong in a component?
| Principle | Meaning |
|-----------|---------|
| **REP** Reuse/Release Equivalence | The unit of reuse is the unit of release. |
| **CCP** Common Closure | Gather things that change for the same reasons at the same times (SRP for components). |
| **CRP** Common Reuse | Don't force users of a component to depend on things they don't need (ISP for components). |

### Coupling — how components relate
| Principle | Meaning |
|-----------|---------|
| **ADP** Acyclic Dependencies | No cycles in the component dependency graph. Break them with DIP or a new component. |
| **SDP** Stable Dependencies | Depend in the direction of stability. Instability I = Ce / (Ca + Ce). |
| **SAP** Stable Abstractions | A component should be as abstract as it is stable. Abstractness A = Na / Nc. |

**Main sequence:** components should sit near A + I = 1. Avoid the *Zone of Pain* (stable + concrete, e.g. a DB schema everyone depends on) and the *Zone of Uselessness* (abstract + nobody depends on it).

## 6. Recommended folder structure (feature-first)

```
src/
  orders/                      # screams the domain
    domain/                    # Entities, value objects, domain errors
      order.ts
      money.ts
    application/               # Use cases + ports (interfaces they own)
      place-order.ts
      ports/
        order-repository.ts
        payment-gateway.ts
    adapters/                  # Interface adapters
      http/order-controller.ts
      persistence/postgres-order-repository.ts
      payment/stripe-payment-gateway.ts
  billing/
    ...
  shared/                      # Only truly shared kernel types
  main.ts                      # Composition root — wiring only
tests/
  orders/
    place-order.test.ts        # Uses in-memory fakes of the ports
```

Equivalent names that are fine: `core/` + `infrastructure/`, hexagonal `ports/` + `adapters/`, onion `domain/` + `application/` + `infrastructure/`.

## 7. Scaling advice — don't over-architect

| Project | Advice |
|---------|--------|
| Script / CLI < ~500 lines | Clean functions and modules; no layers. |
| Small service / CRUD | Separate domain logic from framework handlers; one repository interface where you need a test seam. |
| Growing product, several teams | Full feature-first layering, ports for every external system, enforce with an import-lint rule (e.g. dependency-cruiser, import-linter, ArchUnit). |

## 8. Architecture review checklist

- [ ] Do entities/use cases import any framework, ORM, HTTP, or UI type?
- [ ] Are interfaces for persistence/external services declared in the inner layer?
- [ ] Do ORM models or HTTP request objects leak into use cases?
- [ ] Can the use cases be tested with in-memory fakes, no DB, no server?
- [ ] Does the folder structure scream the domain?
- [ ] Is there a single composition root wiring dependencies?
- [ ] Any dependency cycles between modules/packages?
- [ ] Is the amount of architecture proportional to the project's size and change rate?
