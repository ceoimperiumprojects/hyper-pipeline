# Example: Adding Feature to Existing Project

Scenario: SimpleSurplus — add lead scoring to existing FastAPI + React app.

```
You: /hp-go "add AI lead scoring — when I enter a property address and value,
      score the lead 1-100 based on location, value, and owner type"

🤖 CODEBASE SCAN
   "SimpleSurplus: FastAPI + React + SQLite
    15 API endpoints, 8 components, JWT auth
    Reusable: Lead model, auth middleware, test fixtures"

🤖 PLAN (respects existing patterns)
   - New endpoint: POST /api/v1/leads/score (follows existing /api/v1/ pattern)
   - New component: ScoreDisplay (follows existing component structure)
   - New test: test_lead_scoring.py (follows existing pytest patterns)
   - Reuses: Lead model, JWT auth, error handling middleware
   - Feature branch: hp/lead-scoring

🤖 GIT SAFETY
   git checkout -b hp/lead-scoring
   npm test → 23/23 passing (baseline)

✋ YOU REVIEW PLAN
   "Looks good, also add batch scoring for CSV upload"

🤖 BUILD (on feature branch)
   feat: add LeadScore model + migration → commit
   feat: add POST /api/v1/leads/score endpoint → commit
   feat: add batch scoring endpoint → commit
   feat: add ScoreDisplay component → commit
   test: add scoring unit + integration tests → commit
   All tests: 28/28 passing (23 old + 5 new)

✋ YOU REVIEW DESIGN
   DESIGN-SPEC.md with score visualization, batch upload UI

🤖 BUILD FRONTEND
   feat: add ScoreDisplay with gauge chart → commit
   feat: add CSV batch upload page → commit

🤖 EVAL
   Backend Quality: 8/10
   - Zod validation on scoring input ✓
   - Tests cover edge cases (zero value, invalid address) ✓
   - Batch endpoint paginated ✓
   Visual Quality: 7/10 (custom gauge, not default)

✋ YOU REVIEW EVAL
   "Fix the loading state on batch upload, rest is fine"

🤖 FIX → RE-EVAL → PASS

🤖 MERGE
   git checkout main && git merge hp/lead-scoring
   All tests: 28/28 passing ✓
   Total: ~45 min, 5 commits on feature branch
```
