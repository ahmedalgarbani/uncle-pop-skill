# Example — Review mode

## User prompt

> Review this code

```ts
export class OrderService {
  async process(o: any, sendMail: boolean) {
    // check items
    if (!o.items || o.items.length == 0) return -1;
    let t = 0;
    for (const i of o.items) t += i.price * i.qty;
    if (o.country == "DE") t = t * 1.19;
    const db = new PgClient(process.env.DB_URL);
    await db.query(`INSERT INTO orders VALUES ('${o.id}', ${t})`);
    if (sendMail) await new SmtpMailer().send(o.email, "Order received");
    return t;
  }
}
```

## Expected Uncle Pop answer

## 🧓 Uncle Pop Review

**Verdict:** It works for the happy path, but `process` does five jobs, has a SQL-injection hole, and can't be tested without a real database.
**Score:** 3 / 10  (Clean Code 3 · SOLID 2 · Architecture 2 · Tests 0)

### Findings
| # | Severity | Location | Principle | Problem | Fix |
|---|----------|----------|-----------|---------|-----|
| 1 | 🔴 | `` `INSERT ... '${o.id}'` `` | Security, G26 | SQL built by string interpolation → injection | Parameterised query inside a repository adapter |
| 2 | 🔴 | `new PgClient(...)`, `new SmtpMailer()` | DIP, Dependency Rule | Business logic creates infrastructure; untestable | Inject `OrderRepository` and `OrderNotifier` ports |
| 3 | 🟠 | `process(...)` | SRP, G30 | Validates, prices, taxes, persists and notifies | Split into a use case calling small functions |
| 4 | 🟠 | `sendMail: boolean` | F3 Flag argument | Function does two different things | Separate decision; notifier always called by the use case or by an event |
| 5 | 🟠 | `return -1` | Error handling | Error code mixed with a valid total | Throw `EmptyOrderError` |
| 6 | 🟠 | `1.19`, `"DE"` | G25, OCP | Magic number; every new country edits this method | `TaxPolicy` strategy / rate table |
| 7 | 🟡 | `o`, `t`, `i`, `any` | N1 | Names hide intent; no types | `order`, `total`, `item`; typed `Order` |
| 8 | 🟡 | `// check items` | C3 | Redundant comment | Extract `ensureHasItems(order)` |
| 9 | 🟡 | `==` | G26 | Loose equality | `===` |

### Refactored code
```ts
export class PlaceOrder {
  constructor(
    private readonly orders: OrderRepository,
    private readonly taxes: TaxPolicy,
    private readonly notifier: OrderNotifier,
  ) {}

  async execute(order: Order): Promise<Money> {
    ensureHasItems(order);
    const total = this.taxes.applyTo(order.subtotal(), order.country);
    await this.orders.save(order.withTotal(total));
    await this.notifier.orderReceived(order);
    return total;
  }
}

function ensureHasItems(order: Order): void {
  if (order.items.length === 0) throw new EmptyOrderError(order.id);
}
```

### What is already good
- The flow is short and readable top-to-bottom.
- `async/await` is used consistently.

### Next steps
1. Fix the SQL injection now (parameterised query) — smallest safe change.
2. Add tests for `PlaceOrder` with in-memory fakes of the three ports.
3. Extract `TaxPolicy` and move the rates to configuration.
4. Move `PgClient`/`SmtpMailer` into adapters wired in `main.ts`.
