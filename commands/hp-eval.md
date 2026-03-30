---
description: Run QA evaluation via SEPARATE skeptical agent. Spawns hp-evaluator with fresh context — no bias from generator. Tests every interaction, grades 4×10, writes EVAL-REPORT.md.
---

# /hp-eval — Skeptical Evaluator (Separate Agent)

**CRITICAL: This command spawns the evaluator as a SEPARATE agent with fresh context.**

The evaluator has NEVER seen the generator's work. It judges the OUTPUT only — like a skeptical code reviewer who only sees the deployed app.

## What This Command Does

1. Spawns a new Agent (fresh 200K context, no shared state with generator)
2. Agent reads `docs/SPRINT-CONTRACT.md` for acceptance criteria
3. Navigates the running app via Playwright MCP
4. Tests every interaction from the sprint contract
5. Probes edge cases (invalid input, mobile, error states, rapid clicks)
6. Grades on 4 criteria: Functionality, Backend Quality, Visual Quality, Innovation
7. Writes `docs/EVAL-REPORT.md` with scores, bugs, and recommendations

**WHY separate:** From Anthropic — "I watched it identify legitimate issues, then talk itself into deciding they weren't a big deal." Physical separation prevents this.

## Prerequisites

- App must be running (dev server started)
- Playwright MCP must be configured
- `docs/SPRINT-CONTRACT.md` must exist with testable behaviors

## Hard Fail Conditions (auto-fail if any are true)

- App crashes on normal usage
- Primary feature doesn't work
- AI features error without graceful handling
- UI is broken on desktop

## When to Use

- After `/hp-build` completes a sprint
- When you want to verify the app works end-to-end
- Before deploying or presenting
- After making fixes to re-verify

## Example

```
/hp-eval                  # Evaluate current sprint
/hp-eval --strict         # Extra strict scoring
```

After evaluation, if bugs are found, the Generator reads EVAL-REPORT.md and fixes them, then you run `/hp-eval` again until it passes.

## vs `/code-review` i `/eval` (ECC)

| | `/hp-eval` | `/code-review` | `/eval` |
|--|-----------|---------------|--------|
| **Tip** | Runtime QA (Playwright) | Statički code review | Agent capability tracking |
| **Testira** | Running app — klikovi, navigacija | Source code — security, quality | Claude agent reliability |
| **Output** | EVAL-REPORT.md (scores + bugs) | Review (CRITICAL/HIGH/LOW) | pass@k metrics |
| **Kad** | Posle `/hp-build` | Pre PR/commit | Za tracking agent performance |

**Proper sequence:** `/hp-build` → `/hp-eval` (runtime) → `/code-review` (static) → PR
