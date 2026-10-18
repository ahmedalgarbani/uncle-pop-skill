# 🧓 Uncle Pop — Clean Code Agent Skill

**Uncle Pop** is an agent skill that reviews, writes, refactors and architects code the way Robert C. Martin ("Uncle Bob") teaches in his books:

| Book | What Uncle Pop applies |
|------|------------------------|
| *Clean Code* | Naming, small functions, comments, formatting, error handling, code smells (C1…T9) |
| *Clean Architecture* | Dependency Rule, layers, ports & adapters, Screaming Architecture, component principles |
| *Agile Software Development: Principles, Patterns, and Practices* | SOLID |
| *The Clean Coder* | TDD discipline, professionalism, test pyramid |
| *Design Patterns* (GoF) | Picking the right pattern for a real problem — and saying when not to |

> **"The only way to go fast is to go well."**

Works with any language (TypeScript, Python, Java, C#, Go, Rust, PHP, Kotlin, …) and follows each language's own idioms. Built for Google Antigravity, and also works in Claude Code or any agent that loads `SKILL.md` skills.

---

## ⚡ Quick start

### 1. Get the skill

```bash
git clone https://github.com/ahmedalgarbani/uncle-pop-skill.git
cd uncle-pop-skill
```

### 2. Install it

| Agent | Command | Installs to |
|-------|---------|-------------|
| **Google Antigravity** (workspace) | `./install.sh antigravity` (run from your project root) | `.agent/skills/uncle-pop/` |
| **Claude Code** (all projects) | `./install.sh claude` | `~/.claude/skills/uncle-pop/` |
| **Claude Code** (this project only) | `./install.sh claude-project` | `.claude/skills/uncle-pop/` |
| **Any other agent** | `./install.sh /path/to/skills` | `/path/to/skills/uncle-pop/` |

Or copy it by hand — the skill is just the `uncle-pop/` folder:

```bash
cp -R uncle-pop /path/to/your/agent/skills/
```

#### Option: use the packaged `uncle-pop.skill` file

`uncle-pop.skill` (in the repo root) is the whole skill packed into one file — a zip archive with the `uncle-pop/` folder inside.

- **Claude apps (claude.ai / Claude Desktop):** open *Settings → Capabilities → Skills*, choose **Upload skill**, and select `uncle-pop.skill`.
- **Any folder-based agent:** unzip it into the skills folder:

  ```bash
  unzip uncle-pop.skill -d /path/to/your/agent/skills/
  ```

After you edit the skill, rebuild the file with `./package.sh`.

> If your Antigravity version reads skills from a different folder (for example a global skills directory), pass that folder: `./install.sh <that-folder>`.

### 3. Use it

Restart or reload your agent, then just ask:

```text
Review this file with uncle pop: src/orders/order-service.ts
```

The agent picks the skill automatically when you ask for a review, refactor, architecture or design-pattern advice. You can also call it by name (e.g. `/uncle-pop` in Claude Code).

---

## 🎯 What it can do — six modes

Uncle Pop detects the mode from your request:

| Mode | Say something like… | You get |
|------|---------------------|---------|
| **Review** | "review this", "what's wrong with this code" | Verdict, score /10, findings table (severity · location · principle · fix), refactored code, what's good, next steps |
| **Refactor** | "refactor", "clean this up", "make it SOLID" | Smell list with IDs → safe step plan → final code → tests → why it's better |
| **Write** | "implement", "create", "build" | Tests first (TDD), clean domain code, I/O behind interfaces, self-reviewed |
| **Architect** | "how should I structure…", "layers", "folders" | Entities/use cases/ports/adapters, dependency diagram, feature-first folder tree, trade-offs |
| **Pattern** | "which design pattern", "too many if/switch" | The force → the pattern → before/after code → when NOT to use it |
| **Teach** | "explain SRP", "what is the Dependency Rule" | Short explanation with a bad → good example in your language |

### Severity levels used in reviews

| Icon | Level | Meaning |
|------|-------|---------|
| 🔴 | Critical | Bugs, security issues, broken Dependency Rule, untestable core logic |
| 🟠 | Major | SOLID violations, functions doing many things, misleading names, duplication |
| 🟡 | Minor | Formatting, small naming fixes, redundant comments |
| 💡 | Suggestion | Optional pattern or structure improvement |

Every finding cites a principle or smell ID (e.g. `SRP`, `DIP`, `G30`, `N1`, `F3`) so you can look it up in `uncle-pop/references/`.

---

## 📘 Guideline — how to get the best results

### Prompts that work well

```text
Review src/payments/ with uncle pop. Focus on SOLID and the Dependency Rule.
Refactor this function step by step and keep behaviour identical. Add tests.
Write a use case "TransferMoney" in Python using TDD and clean architecture.
I have a switch on paymentType in 6 files. Which design pattern should I use?
Design the folder structure for a Go microservice that handles invoices.
Explain the Interface Segregation Principle with a Kotlin example.
Review only for naming and function size — skip architecture.
```

### Tips

1. **Give context.** Say the language, framework and what the code is for. A 50-line script and a 50-service platform need different advice — Uncle Pop scales its advice, but only if it knows.
2. **Point at files or paste the code.** Real code gets real line numbers; Uncle Pop never invents them.
3. **Narrow the focus when you want.** "Only security and error handling" gives a shorter, sharper review.
4. **Refactor in small steps.** Ask for "step 1 only" on big files, run your tests, then continue.
5. **Ask "why?"** Every finding is tied to a principle — ask Uncle Pop to teach it.
6. **Push back.** Uncle Pop is pragmatic: if a suggested interface or pattern feels like over-engineering, say so — it will explain the trade-off or drop it.

### The 12 core rules Uncle Pop always applies

1. Names reveal intent.
2. Functions are small and do one thing; 0–2 arguments, no flag arguments.
3. No hidden side effects; Command–Query Separation.
4. Comments explain *why*, never *what*.
5. Exceptions / Result types instead of error codes; avoid `null`.
6. DRY — but don't merge things that change for different reasons.
7. SOLID.
8. The Dependency Rule — business rules never import frameworks, DBs or UI.
9. Tests are first-class code: F.I.R.S.T., one concept per test, Arrange–Act–Assert.
10. Boy Scout Rule — leave the code cleaner than you found it.
11. Pragmatism over dogma — no pattern/layer without a real force.
12. Respect the language's idioms.

---

## 🗂️ Project structure

```
uncle-pop-skill/
├── README.md                         ← you are here
├── install.sh                        ← copies the skill into your agent's skills folder
├── package.sh                        ← rebuilds uncle-pop.skill
├── uncle-pop.skill                   ← the packaged skill (zip) for one-file upload
└── uncle-pop/                        ← THE SKILL (this folder is what gets installed)
    ├── SKILL.md                      ← entry point: persona, modes, core rules, workflows, output template
    ├── references/                   ← loaded on demand, only when the task needs them
    │   ├── clean-code.md             ← names, functions, comments, formatting, errors, classes, systems
    │   ├── solid.md                  ← SRP, OCP, LSP, ISP, DIP + diagnostic table + when NOT to apply
    │   ├── clean-architecture.md     ← Dependency Rule, layers, boundaries, component principles, folder layout
    │   ├── design-patterns.md        ← symptom → pattern table, all 23 GoF patterns, Uncle Bob favourites
    │   ├── code-smells.md            ← Clean Code ch. 17 catalogue (C, E, F, G, J, N, T IDs)
    │   ├── testing-tdd.md            ← Three Laws of TDD, F.I.R.S.T., test doubles, test smells
    │   └── review-checklist.md       ← the checklist walked on every review
    └── examples/                     ← sample outputs the agent imitates
        ├── review-example.md
        ├── refactor-example.md
        └── architecture-example.md
```

### How the skill works

1. The agent reads only the `name` + `description` in the front matter of `SKILL.md` to decide when to use the skill.
2. When triggered, it loads `SKILL.md` (persona, modes, rules, output format).
3. It then loads **only** the reference files the task needs (e.g. a pattern question loads `design-patterns.md`), which keeps context small and answers focused.

---

## 🛠️ Customising

- **Change the output format:** edit the template in `uncle-pop/SKILL.md` → *Review workflow*.
- **Add your team's rules:** add a file such as `uncle-pop/references/team-rules.md` and list it in the *Reference files* table of `SKILL.md`.
- **Add examples in your stack:** drop more before/after files into `uncle-pop/examples/`.
- **Change trigger words:** edit the `description` field in the front matter of `SKILL.md`.

After any change, re-run `./install.sh …` to copy the updated skill, and `./package.sh` to rebuild `uncle-pop.skill`.

---

## ❓ FAQ

**Does it only work for OOP languages?**
No. Principles are translated to the language's idioms — functions instead of classes in functional code, traits in Rust, interfaces in Go, protocols in Python.

**Will it rewrite my whole project?**
No. It proposes small, safe, ordered steps and protects behaviour with tests first.

**Is it strict?**
It is principled, not dogmatic. It will tell you when *not* to add a layer, interface or pattern.

---

## 📚 Credits

Principles come from the books of Robert C. Martin and from *Design Patterns* by Gamma, Helm, Johnson and Vlissides. This skill is an independent summary for practical use and is not affiliated with the authors. Read the books — they are worth it.

**Author:** Ahmed Algarbani
