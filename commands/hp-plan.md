---
description: Generate a comprehensive product spec and sprint contracts from a short prompt. Invokes the hp-planner agent (Opus ultrathink).
---

# /hp-plan

This command invokes the **hp-planner** agent to expand your request into a full product spec with sprint contracts.

## What This Command Does

1. Reads existing codebase to understand current state
2. Takes your short description and expands it into `docs/PLAN.md`:
   - Product overview, features (prioritized), architecture, sprint plan
   - AI integration points, demo script outline, innovation argument
3. Generates `docs/SPRINT-CONTRACT.md` with testable acceptance criteria
4. Presents plan for your review before any building starts

## When to Use

- Starting a new feature or project
- When you have a vague idea and need it structured
- Before `/hp-build` — always plan first
- When you need testable acceptance criteria defined

## Example

```
/hp-plan Add a lead scoring system that rates properties 1-100 based on value, location, and owner type
```

The planner will read your codebase, design the scoring API, UI components, and define exactly what "done" looks like.

## vs `/plan` (ECC)

| | `/hp-plan` | `/plan` |
|--|-----------|--------|
| **Za** | Nove projekte, scope expansion, hackathon | Incremental features na postojećem kodu |
| **Output** | `docs/PLAN.md` + `docs/SPRINT-CONTRACT.md` (persistent) | In-chat implementation plan |
| **Model** | Opus ultrathink | Opus |
| **Fokus** | ŠTA da se napravi + testable "done" | KAKO da se implementira |

Ako ne znaš koji → koristi `/hp-plan` (comprehensive).
