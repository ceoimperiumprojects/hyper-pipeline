---
description: Collaborative pipeline mode. You and Claude work together — you make key decisions, Claude handles the heavy lifting. Best for existing projects and when you want control. Automates what can be automated, asks you when it matters.
---

# /hp-go — Collaborative Mode

You drive. Claude executes. Together you're unstoppable.

## Usage

```
/hp-go "Add real-time notifications system"
/hp-go docs/FEATURE.md
/hp-go                                        # Asks what you want to do
```

## How It Works

```
┌─ YOU ─────────────────────────────────────────────────────┐
│                                                           │
│  1. Describe what you want                                │
│  2. Review and approve the plan    ← DECISION POINT ✋    │
│  3. (optional) Approve design      ← DECISION POINT ✋    │
│  4. Watch build progress, intervene if needed             │
│  5. Review eval results            ← DECISION POINT ✋    │
│  6. Decide: fix, accept, or iterate                       │
│                                                           │
└───────────────────────────────────────────────────────────┘

┌─ CLAUDE ──────────────────────────────────────────────────┐
│                                                           │
│  1. 🤖 Scans codebase (auto)                             │
│  2. 🤖 Generates plan + contract (auto)                   │
│  3. ✋ Presents plan → WAITS for your approval            │
│  4. 🤖 Builds features one by one (auto)                  │
│     └→ Shows progress: "Feature 3/7: Adding API..."      │
│  5. 🤖 Evaluates with Playwright (auto)                   │
│  6. ✋ Shows EVAL-REPORT → WAITS for your decision        │
│     └→ "Fix bugs and re-eval?" / "Accept and continue?"  │
│                                                           │
└───────────────────────────────────────────────────────────┘
```

## Decision Points (where YOU are involved)

### ✋ Decision 1: Plan Review
After Planner generates PLAN.md + SPRINT-CONTRACT.md:
- You see the full plan with features, architecture, sprint contracts
- You can: **Approve** / **Modify** (change scope, priorities) / **Reject** (start over)
- Claude asks: "Plan izgleda ovako. Šta kažeš?"

### ✋ Decision 2: Design Review (optional)
If design phase is needed:
- Claude asks: "Stitch MCP ili ručno?"
- If ručno: Claude gives you DESIGN-SPEC.md, you create in Stitch
- If MCP: Claude shows generated designs for approval

### ✋ Decision 3: Eval Review
After Evaluator grades the build:
- You see EVAL-REPORT.md with scores (Functionality, Code Quality, UX, Innovation)
- You see bug list with severity
- You decide:
  - "Fix critical bugs" → Generator fixes, re-eval
  - "Looks good, ship it" → Done
  - "Also change X" → Additional instructions

### Auto Parts (no user input needed)
- Codebase scanning
- Plan generation (you review, but don't write it)
- Feature building (one by one, with commits)
- Testing (TDD per feature, verification loop)
- Eval execution (Playwright navigation + grading)
- Bug fixing (if you approve the fix round)

## Existing Project Support

`/hp-go` shines on existing projects because it:

1. **Understands your codebase first**
   - Scans structure, patterns, conventions
   - Identifies what to REUSE vs what to CREATE
   - Generates CODEBASE-CONTEXT.md

2. **Respects existing architecture**
   - Matches your component organization
   - Uses your existing API patterns
   - Follows your testing approach
   - Reuses your utility functions

3. **Asks smart questions**
   - "You have an existing auth middleware. Should the new feature use it?"
   - "Found 2 similar components. Should I extend ProductCard or create new?"
   - "Your project uses Zustand for state. Want me to add a new store?"

4. **Doesn't break things**
   - Runs existing tests before AND after changes
   - Generator never breaks the build
   - Verification loop checks compatibility

## Flow for Existing Projects

```
/hp-go "Add lead scoring to SimpleSurplus"

🤖 CODEBASE SCAN
   "I see SimpleSurplus uses FastAPI + React + SQLite.
    Found 15 existing API endpoints, 8 React components,
    23 test files. Auth uses JWT middleware.
    I'll build the new feature using these patterns."

🤖 PLAN
   PLAN.md generated with:
   - New endpoint: POST /api/leads/score (follows existing /api/leads/ pattern)
   - New component: ScoreDisplay (follows existing component structure)
   - New test: test_lead_scoring.py (follows existing test patterns)
   - Reuses: existing Lead model, JWT auth, API error handling

✋ YOU REVIEW
   "Looks good, but add batch scoring too"

🤖 PLAN UPDATED + BUILD STARTS
   feat: add scoring model fields → commit
   feat: add POST /api/leads/score endpoint → commit
   feat: add batch scoring endpoint → commit
   feat: add ScoreDisplay component → commit
   feat: add score integration tests → commit

🤖 EVAL
   Functionality: 9/10
   Code Quality: 8/10 — "one function exceeds 50 lines"
   UX: 7/10 — "no loading state on batch scoring"

✋ YOU DECIDE
   "Fix the loading state, the long function is fine for now"

🤖 FIX + RE-EVAL → PASS ✓
```

## vs Other Modes

| | `/hp-auto` | `/hp-go` | Manual (`/hp-plan` + ...) |
|--|-----------|---------|--------------------------|
| User involvement | 0% | ~20% (key decisions) | 100% (every step) |
| Best for | Clear specs, overnight | Existing projects, daily dev | Learning, complex decisions |
| Speed | Fastest | Fast | Slowest |
| Control | None | At decision points | Full |
| Existing project support | Good | **Best** | Good |
| Risk of wrong direction | Higher | Low (you course-correct) | Lowest |

## When to Use

- **Daily dev on existing projects** — You know the codebase, want Claude to do the work, but want approval on direction
- **Features that touch multiple areas** — Claude handles the complexity, you verify
- **When you want to learn** — See Claude's plan, understand the approach, then let it execute
- **When you're not sure about requirements** — Collaborative discovery + execution

## When NOT to Use

- You have a crystal clear spec and don't want interruptions → `/hp-auto`
- Quick one-off fix → `/build-fix` or `/tdd`
- You want to control every file edited → manual `/hp-plan` + `/hp-build`
