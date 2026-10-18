# Example — Refactor mode

## User prompt

> Refactor this to be clean and SOLID

```py
def calc(emp, type):
    if type == "full":
        return emp["salary"] / 12
    elif type == "part":
        return emp["hours"] * emp["rate"]
    elif type == "contract":
        return emp["invoice"] - emp["invoice"] * 0.1
```

## Expected Uncle Pop answer

**Smells**
- G23 / OCP — `if/elif` on a type code; every new employee type edits `calc`.
- N1 — `calc`, `emp`, `type` (also shadows a built-in) don't reveal intent.
- G25 — magic numbers `12`, `0.1`.
- Primitive obsession — employee is an untyped `dict`.
- G2 — unknown type silently returns `None`.

**Steps**
1. Characterization tests for the three existing types.
2. Rename `calc` → `monthly_pay`.
3. Replace Magic Number with Constant.
4. Replace Conditional with Polymorphism (one class per pay model).
5. Factory for the one remaining type decision, raising on unknown types.

**Final code**
```py
from dataclasses import dataclass
from typing import Protocol

MONTHS_PER_YEAR = 12
CONTRACTOR_FEE_RATE = 0.10


class PayModel(Protocol):
    def monthly_pay(self) -> float: ...


@dataclass(frozen=True)
class Salaried:
    annual_salary: float

    def monthly_pay(self) -> float:
        return self.annual_salary / MONTHS_PER_YEAR


@dataclass(frozen=True)
class Hourly:
    hours: float
    rate: float

    def monthly_pay(self) -> float:
        return self.hours * self.rate


@dataclass(frozen=True)
class Contractor:
    invoice_amount: float

    def monthly_pay(self) -> float:
        return self.invoice_amount * (1 - CONTRACTOR_FEE_RATE)


class UnknownEmploymentType(ValueError):
    pass


def pay_model_for(record: dict) -> PayModel:
    kind = record["type"]
    if kind == "full":
        return Salaried(record["salary"])
    if kind == "part":
        return Hourly(record["hours"], record["rate"])
    if kind == "contract":
        return Contractor(record["invoice"])
    raise UnknownEmploymentType(kind)
```

**Tests**
```py
import pytest


def test_salaried_pay_is_annual_salary_split_over_twelve_months():
    assert Salaried(annual_salary=120_000).monthly_pay() == 10_000

def test_contractor_pay_deducts_fee():
    assert Contractor(invoice_amount=1_000).monthly_pay() == 900

def test_unknown_type_is_rejected():
    with pytest.raises(UnknownEmploymentType):
        pay_model_for({"type": "intern"})
```

**Why it is better**
- New pay models are new classes — `monthly_pay` callers never change (OCP).
- Each class has one reason to change (SRP).
- Unknown types fail loudly instead of returning `None` (G2).
- Note: for real money, use `Decimal`, not `float` (G26).
