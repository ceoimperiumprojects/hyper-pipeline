---
name: pipeline-eval
description: QA evaluation skill using Playwright to navigate running apps, test interactions, and grade on 4 criteria with hard fail conditions.
origin: hyper-pipeline
---

# Pipeline Eval

Tests the running application via Playwright MCP, grades on 4 criteria, and produces a detailed evaluation report.

## When to Activate

- User invokes `/hp-eval`
- After `/hp-build` completes a sprint
- When you need to verify an app works end-to-end

## Core Principle

From Anthropic's Harness Design: "Separating the agent doing the work from the agent judging it proves to be a strong lever. Tuning a standalone evaluator to be skeptical turns out to be far more tractable than making a generator critical of its own work."

The Evaluator is SKEPTICAL. It does not approve mediocre work.

## 4 Grading Criteria

| Criterion | What it measures | Score |
|-----------|-----------------|-------|
| **Functionality** | Does everything work? Bugs? Edge cases? | 1-10 |
| **Code Quality** | Clean code? No dead code? Type-safe? | 1-10 |
| **UX/Design** | Intuitive? Responsive? Consistent? | 1-10 |
| **Innovation** | (hackathon only) AI genuine? Novel? | 1-10 |

## Hard Fail Conditions (sprint auto-fails)
- App crashes on normal usage
- Primary feature doesn't work
- AI features error without graceful handling
- UI broken on desktop
- Data doesn't persist when it should

## Pre-Flight Check

Before evaluating, verify the app is actually running:

```bash
# 1. Read BUILD-LOG.md for the start command and port
grep -E "port|PORT|localhost|start" docs/BUILD-LOG.md

# 2. Check if the app process is running
lsof -i :3000 2>/dev/null || lsof -i :5173 2>/dev/null || lsof -i :8080 2>/dev/null

# 3. Try to reach the app
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null
```

**If app is NOT running:**
1. Try to start it: read `package.json` scripts, run `npm run dev` or equivalent
2. Wait up to 15 seconds for startup
3. Re-check with curl
4. If still not running → write EVAL-REPORT with "BLOCKED — App failed to start" and include the error output. Do NOT proceed with Playwright testing against a dead server.

## Evaluation Process

1. Read `docs/SPRINT-CONTRACT.md` for acceptance criteria
2. **Run pre-flight check** (see above) — confirm app responds before proceeding
3. Navigate every page via Playwright MCP
4. Screenshot each page
5. Test every sprint contract behavior (PASS/FAIL each)
6. Probe edge cases (invalid input, mobile, errors)
7. Test AI features with various prompts
8. Check code quality (`tsc --noEmit`, grep for console.log)
9. Grade each criterion with detailed reasoning
10. Write `docs/EVAL-REPORT.md`

## Calibration

From Anthropic's research: "I calibrated the evaluator using few-shot examples with detailed score breakdowns."

**Good finding example:**
> "FAIL — Rectangle fill tool only places tiles at drag start/end points instead of filling the region. `fillRectangle` function exists at line 234 but isn't triggered properly on mouseUp."

**Bad finding example:**
> "The fill tool has some minor issues but overall works okay."

Be specific. Reference code. State what should happen vs what does happen.

## Output

Write `docs/EVAL-REPORT.md` with:
- Overall PASS/FAIL and score
- Hard fail check results
- Sprint contract verification table
- Per-criterion scores with detailed reasoning
- Bug list with severity, description, repro steps, suggested fix
- Specific recommendations with file references

## Feedback Loop

If FAIL → Generator reads EVAL-REPORT → fixes bugs → `/hp-eval` again.
Max 3 iterations to prevent infinite loops.
