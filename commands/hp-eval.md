---
description: Run QA evaluation on the running app using Playwright. Invokes the hp-evaluator agent (Opus ultrathink). Tests every interaction, grades on 4 criteria, writes EVAL-REPORT.md.
---

# /hp-eval

This command invokes the **hp-evaluator** agent to QA the running application.

## What This Command Does

1. Reads `docs/SPRINT-CONTRACT.md` for acceptance criteria
2. Starts navigating the running app via Playwright MCP
3. Tests every interaction from the sprint contract
4. Probes edge cases (invalid input, mobile, error states)
5. Grades on 4 criteria: Functionality, Code Quality, UX/Design, Innovation
6. Writes `docs/EVAL-REPORT.md` with scores, bugs, and recommendations

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
