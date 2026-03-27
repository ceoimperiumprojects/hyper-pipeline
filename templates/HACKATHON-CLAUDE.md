# CLAUDE.md — Hackathon Project

## Project Context
- **Hackathon:** [Name, Date, Location]
- **Theme:** [Theme]
- **Duration:** 24 hours
- **Team:** [Names]
- **Judging:** App Quality (33%), Innovation (33%), Presentation (33%)

## Current Phase
<!-- UPDATE AS YOU PROGRESS -->
- **PHASE:** [0-8]
- **SPRINT:** [1-2]
- **MODE:** [PLANNER / GENERATOR / EVALUATOR / PRESENTER]

## Critical Rules
1. **TIME IS THE ENEMY.** Never spend >45 min on a single feature. Simplify and move on.
2. **WORKING > PERFECT.** A working demo beats a beautiful broken app.
3. **AI IS CORE.** Every feature should have an AI angle. If it doesn't, cut it.
4. **DEMO FIRST.** If it won't be visible in the demo, deprioritize it.
5. **COMMIT OFTEN.** Commit after every working feature. Never lose work.
6. **NO LOREM IPSUM.** Use real or realistic data always.
7. **BACKEND FIRST.** Build API and data before UI. Design after you know the data.

## Architecture
- **Frontend:** [stack]
- **Backend:** [stack]
- **Database:** [stack]
- **AI:** Claude API with tool use
- **Deploy:** [platform]

## Key Files (source of truth — survives compaction)
- `docs/PLAN.md` — Product spec
- `docs/SPRINT-CONTRACT.md` — Current sprint acceptance criteria
- `docs/BUILD-LOG.md` — Build progress
- `docs/EVAL-REPORT.md` — QA findings
- `docs/DEMO-SCRIPT.md` — Presentation demo script
- `docs/BLOCKERS.md` — Deferred issues
- `.stitch/DESIGN.md` — Design system

## Pipeline Commands
- `/hp-plan` — Generate product spec and sprint contracts
- `/hp-build` — Build features from sprint contract
- `/hp-eval` — QA evaluation with Playwright
- `/hp-design` — Design phase (Stitch MCP or manual)
- `/hp-present` — Generate presentation materials
- `/pipeline hackathon` — Full orchestrated 24h workflow

## Phase Timeline
```
PHASE 0: Setup                     [Pre-start]       30 min
PHASE 1: Brainstorm & Plan         [T+0 → T+2:30]    2.5h
PHASE 2: Build Sprint 1 (Backend)  [T+2:30 → T+7:30] 5h
PHASE 3: Design (Stitch)           [T+7:30 → T+9]    1.5h
PHASE 4: Build Sprint 2 (UI+AI)   [T+9 → T+14:30]    5.5h
PHASE 5: Test & Refine             [T+14:30 → T+17:30] 3h
PHASE 6: Polish & Deploy           [T+17:30 → T+20]   2.5h
PHASE 7: Presentation              [T+20 → T+22:30]   2.5h
PHASE 8: Buffer & Rehearsal        [T+22:30 → T+24]   1.5h
```

## Context Management
- Compact at every phase transition
- After compaction: re-read docs/ directory
- All state is on disk, never only in context
