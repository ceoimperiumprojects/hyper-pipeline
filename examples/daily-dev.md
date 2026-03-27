# Daily Dev Workflow — Example

## Scenario: SimpleSurplus Lead Scoring System

**Context:** Working on SimpleSurplus B2B lead generation platform. Need to add AI-powered lead scoring.

**User prompt:** "Treba lead scoring sistem. AI score-uje lead 1-100 na osnovu property value, location, owner type. Mora da radi end-to-end, sa testovima."

---

## Step 1: /hp-plan

Planner reads SimpleSurplus codebase, understands existing architecture, and generates:

### docs/PLAN.md (generated)
```markdown
# SimpleSurplus Lead Scoring — Product Spec

## Overview
AI-powered lead scoring that rates Florida property leads 1-100 based on
property value, geographic location desirability, and owner type indicators.
Integrates Claude API for intelligent scoring with explainable reasoning.

## Core Features
1. **Scoring API** — POST /api/score with property data, returns score + reasoning (P0)
   - AI Integration: Claude analyzes property data with domain-specific tools
2. **Score Display** — UI component showing score with color-coding (P0)
3. **Batch Scoring** — Process multiple leads, <30s for 100 leads (P1)
4. **Score History** — Track score changes over time (P2)

## Architecture
- Backend: FastAPI (existing)
- AI: Claude API with tool use (analyze_property, check_location, assess_owner)
- Database: SQLite (existing)

## Sprint Plan
### Sprint 1: Backend & API
- Scoring API endpoint
- Claude AI integration with tools
- Database schema for scores

### Sprint 2: Frontend & Polish
- Score display component
- Batch scoring UI
- Score history view
```

### docs/SPRINT-CONTRACT.md (generated)
```markdown
## Sprint 1: Backend

### Testable Behaviors
- [ ] POST /api/score accepts {address, value, owner_type} returns {score: 1-100, reasoning: string}
- [ ] Score is between 1-100, higher = better lead
- [ ] Reasoning explains why the score is what it is
- [ ] Invalid input returns 400 with validation error
- [ ] Batch endpoint POST /api/score/batch accepts array, returns array of scores

## Sprint 2: Frontend

### Testable Behaviors
- [ ] Score displayed with color: red (<30), yellow (30-70), green (>70)
- [ ] Batch scoring shows progress bar
- [ ] Score history shows timeline chart
```

## Step 2: User Reviews Plan

User: "Ok, cepaj. Skip score history za sad, to je P2."

## Step 3: /hp-build

Generator builds feature by feature:
1. `feat: add scoring API endpoint` → commit
2. `feat: add Claude AI scoring with tool use` → commit
3. `feat: add batch scoring endpoint` → commit
4. `feat: add score display component` → commit
5. `feat: add batch scoring UI with progress` → commit

## Step 4: /hp-eval

Evaluator opens app with Playwright:
- Navigates to scoring page
- Enters test property → verifies score appears with color
- Tests invalid input → verifies 400 error
- Tests batch → verifies progress bar and results
- Checks mobile → verifies responsiveness

### docs/EVAL-REPORT.md (generated)
```markdown
## Overall: FAIL — Score: 28/30

## Bugs Found
| # | Severity | Description |
|---|----------|-------------|
| 1 | Major | Invalid location returns 500 instead of 400 validation error |
| 2 | Minor | Batch progress bar doesn't show percentage |
```

## Step 5: Fix and Re-Eval

Generator fixes Bug #1 (validation) → commit → /hp-eval again → PASS ✓

---

## Total Time: ~45 minutes
- Plan: 5 min
- Build: 25 min
- Eval + Fix: 15 min
