# Testing & TDD — Reference

Sources: *Clean Code* ch. 9, *The Clean Coder* ch. 5–8, *Clean Architecture* ch. 28.

## The Three Laws of TDD

1. You may not write production code until you have written a failing unit test.
2. You may not write more of a unit test than is sufficient to fail (not compiling is failing).
3. You may not write more production code than is sufficient to pass the currently failing test.

Cycle: **Red → Green → Refactor**, in seconds-to-minutes loops.

## F.I.R.S.T.

| Letter | Meaning |
|--------|---------|
| **F**ast | Run in milliseconds; you run them constantly. |
| **I**ndependent | No test depends on another or on run order. |
| **R**epeatable | Same result in any environment, offline, any time zone. |
| **S**elf-validating | Pass/fail boolean — no reading logs. |
| **T**imely | Written just before the production code. |

## Clean tests

- **Readability** is the most important property of a test.
- **One concept per test**; few asserts that all describe that concept.
- **Arrange – Act – Assert** (or Given – When – Then), visually separated.
- Build a **domain-specific testing language** (helpers like `givenCustomerWithOverdueInvoice()`).
- Test names describe behaviour: `rejects_order_when_stock_is_insufficient`, not `testOrder2`.
- Test code follows the same quality rules as production code (except efficiency).

```py
def test_rejects_withdrawal_exceeding_balance():
    # Arrange
    account = Account(balance=Money(100))

    # Act / Assert
    with pytest.raises(InsufficientFunds):
        account.withdraw(Money(150))
```

## Test doubles

| Double | Purpose |
|--------|---------|
| **Dummy** | Passed but never used. |
| **Stub** | Returns canned answers. |
| **Spy** | Stub that records how it was called. |
| **Mock** | Spy with expectations built in. |
| **Fake** | Working lightweight implementation (in-memory repository). |

Prefer **fakes for ports you own** (in-memory repository) and verify state over interactions. Don't mock what you don't own — wrap it in an adapter and fake the adapter.

## Test pyramid (Clean Coder)

```
          /\        Manual exploratory (few)
         /  \       System / end-to-end (~10%)
        /----\      Integration (~20%)
       /------\     Component / acceptance (~50%)
      /--------\    Unit tests (~100% of business logic)
```

## Architecture & tests

- Tests are the outermost circle of the architecture; they depend inward, nothing depends on them.
- **Fragile Test Problem:** tests coupled to UI/structure break on every change. Test business rules through use case APIs (a *testing API*), not through the GUI.
- If business logic can't be tested without a DB/server, the Dependency Rule is broken.

## Test smells

| Smell | Fix |
|-------|-----|
| Slow tests (DB, network, sleep) | Fakes behind ports; inject clock |
| Order-dependent tests | Fresh fixtures per test |
| Logic in tests (`if`, loops) | Parametrised tests |
| Mystery guest (hidden fixture files) | Build data in the test |
| Over-mocking, asserting call sequences | Assert outcomes/state |
| Ignored/skipped tests | Fix or delete; an ignored test is an unanswered question (T4) |
| Testing private methods | Test through public behaviour; extract a class if needed |
| No boundary tests | Add tests for empty, one, many, min, max, off-by-one (T5) |
