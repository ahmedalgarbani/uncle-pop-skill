# Code Smells & Heuristics — Catalogue

Source: Robert C. Martin, *Clean Code*, Chapter 17 "Smells and Heuristics". Cite the ID in reviews (e.g. `G30`).

## Comments
| ID | Smell |
|----|-------|
| C1 | Inappropriate information (changelogs, authors, ticket history in comments) |
| C2 | Obsolete comment |
| C3 | Redundant comment (says what the code already says) |
| C4 | Poorly written comment |
| C5 | Commented-out code — delete it |

## Environment
| ID | Smell |
|----|-------|
| E1 | Build requires more than one step |
| E2 | Tests require more than one step |

## Functions
| ID | Smell |
|----|-------|
| F1 | Too many arguments |
| F2 | Output arguments |
| F3 | Flag arguments |
| F4 | Dead function |

## General
| ID | Smell |
|----|-------|
| G1 | Multiple languages in one source file |
| G2 | Obvious behaviour is unimplemented (principle of least surprise) |
| G3 | Incorrect behaviour at the boundaries |
| G4 | Overridden safeties (disabled warnings, skipped tests) |
| G5 | Duplication |
| G6 | Code at the wrong level of abstraction |
| G7 | Base classes depending on their derivatives |
| G8 | Too much information (wide interfaces, many public members) |
| G9 | Dead code |
| G10 | Vertical separation (variables/functions defined far from use) |
| G11 | Inconsistency |
| G12 | Clutter (unused vars, empty constructors, noise) |
| G13 | Artificial coupling |
| G14 | Feature envy |
| G15 | Selector arguments |
| G16 | Obscured intent |
| G17 | Misplaced responsibility |
| G18 | Inappropriate static |
| G19 | Use explanatory variables |
| G20 | Function names should say what they do |
| G21 | Understand the algorithm |
| G22 | Make logical dependencies physical |
| G23 | Prefer polymorphism to if/else or switch/case |
| G24 | Follow standard conventions |
| G25 | Replace magic numbers with named constants |
| G26 | Be precise (floats for money, unchecked nulls, ignored concurrency) |
| G27 | Structure over convention |
| G28 | Encapsulate conditionals |
| G29 | Avoid negative conditionals |
| G30 | Functions should do one thing |
| G31 | Hidden temporal couplings |
| G32 | Don't be arbitrary |
| G33 | Encapsulate boundary conditions |
| G34 | Functions should descend only one level of abstraction |
| G35 | Keep configurable data at high levels |
| G36 | Avoid transitive navigation (Law of Demeter) |

## Java (generalise to any language)
| ID | Smell |
|----|-------|
| J1 | Avoid long import lists by using wildcards |
| J2 | Don't inherit constants |
| J3 | Constants versus enums — prefer enums |

## Names
| ID | Smell |
|----|-------|
| N1 | Choose descriptive names |
| N2 | Choose names at the appropriate level of abstraction |
| N3 | Use standard nomenclature where possible (pattern names, domain terms) |
| N4 | Unambiguous names |
| N5 | Use long names for long scopes |
| N6 | Avoid encodings (Hungarian, prefixes) |
| N7 | Names should describe side effects |

## Tests
| ID | Smell |
|----|-------|
| T1 | Insufficient tests |
| T2 | Use a coverage tool |
| T3 | Don't skip trivial tests |
| T4 | An ignored test is a question about an ambiguity |
| T5 | Test boundary conditions |
| T6 | Exhaustively test near bugs |
| T7 | Patterns of failure are revealing |
| T8 | Test coverage patterns can be revealing |
| T9 | Tests should be fast |

## Common refactoring smells (Fowler vocabulary, often used alongside)
| Smell | Typical refactoring |
|-------|---------------------|
| Long Function | Extract Function |
| Large Class / God Object | Extract Class (by actor — SRP) |
| Long Parameter List | Introduce Parameter Object |
| Primitive Obsession | Replace Primitive with Value Object (`Money`, `Email`) |
| Data Clumps | Extract Class |
| Shotgun Surgery | Move Function / Move Field — gather what changes together (CCP) |
| Divergent Change | Split by reason to change (SRP) |
| Feature Envy | Move Function to the data it uses |
| Switch Statements | Replace Conditional with Polymorphism |
| Message Chains | Hide Delegate (Law of Demeter) |
| Speculative Generality | Remove unused abstractions (YAGNI) |
| Refused Bequest | Replace Inheritance with Delegation (LSP) |
