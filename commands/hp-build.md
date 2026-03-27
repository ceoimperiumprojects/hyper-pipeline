---
description: Build features one at a time from the sprint contract. Invokes the hp-generator agent (Opus high). Requires docs/PLAN.md and docs/SPRINT-CONTRACT.md to exist.
---

# /hp-build

This command invokes the **hp-generator** agent to build features from the sprint contract.

## What This Command Does

1. Reads `docs/PLAN.md` and `docs/SPRINT-CONTRACT.md`
2. Reads `.stitch/DESIGN.md` for visual decisions (if exists)
3. Builds features one at a time in priority order
4. Commits after each feature with conventional commit messages
5. Self-evaluates before marking sprint as complete
6. Writes `docs/BUILD-LOG.md` with summary

## Prerequisites

- `docs/PLAN.md` must exist (run `/hp-plan` first)
- `docs/SPRINT-CONTRACT.md` must exist

## Rules

- **45-minute rule**: If stuck on a feature for 45 min, simplify and move on
- **Never break the build**: App must be runnable after every commit
- **No lorem ipsum**: Real or realistic data only
- **Commit discipline**: One commit per feature

## When to Use

- After `/hp-plan` has been reviewed and approved
- When sprint contract is ready and you want to start building
- When resuming work on an existing sprint

## Example

```
/hp-build
/hp-build sprint 2      # Build specific sprint
```

## ECC Agents Used Inside Build

Generator automatski koristi ove ECC agente/patterne:

| Situacija | ECC Agent/Skill | Kako |
|-----------|----------------|------|
| Svaka feature | **tdd-guide** principles | RED→GREEN→REFACTOR |
| Pre commita | **verification-loop** | tsc, lint, test run |
| Build fails | **build-error-resolver** via `/build-fix` | Minimal fix |
| Language review | **language-reviewer** (ts/py/go) | Per-language patterns |

## vs `/build-fix` (ECC)

- `/hp-build` — Gradi NOVE features iz sprint contracta
- `/build-fix` — Fiksuje POSTOJEĆE build errors
- Generator automatski poziva build-fix patterns kad build pukne tokom `/hp-build`
