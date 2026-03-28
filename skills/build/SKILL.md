---
name: pipeline-build
description: Feature-by-feature building skill with commit discipline, 45-minute rule, and self-evaluation before handoff.
origin: hyper-pipeline
---

# Pipeline Build

Implements features from the sprint contract one at a time, maintaining a working application throughout.

## When to Activate

- User invokes `/hp-build`
- After `/hp-plan` has been approved
- When `docs/PLAN.md` and `docs/SPRINT-CONTRACT.md` exist

## Core Principle

From Anthropic's Harness Design: "The one-feature-at-a-time approach worked well for scope management." Build incrementally. Test as you go. Never break the build.

## Pre-Build Safety (Existing Projects)

Before building ANY feature on an existing project:
```bash
# 1. Create feature branch (if not already on one)
git checkout -b hp/$(echo "$FEATURE" | tr ' ' '-' | tr '[:upper:]' '[:lower:]') 2>/dev/null

# 2. Baseline test — run existing tests to confirm clean state
npm test 2>/dev/null || npx vitest run 2>/dev/null || python -m pytest 2>/dev/null
# Record pass/fail count for regression comparison later

# 3. Check git status — no uncommitted changes
git status --short
```

If baseline tests fail: STOP. Report to user. Do not build on a broken codebase.

## Process

### For Each Feature:
```
1. READ testable behavior from SPRINT-CONTRACT.md
2. PLAN approach (identify files to create/modify)
3. WRITE TEST first (unit or integration — what does success look like?)
4. IMPLEMENT the feature (make test pass)
5. ADD INPUT VALIDATION (Zod schema on every endpoint)
6. ADD ERROR HANDLING (try/catch on every async operation)
7. SELF-TEST: Does it match the testable behavior?
8. RUN ALL TESTS: npm test (everything must pass)
9. COMMIT: git commit -m "feat: [description]"
10. MOVE to next feature
```

### Project Types — Adapt Process:

**Web App (Next.js, React, etc.):**
- Full process above + UI Quality Standards from generator agent
- Backend Quality + Frontend Quality both enforced

**Automation / Script / Pipeline:**
- Same process but skip UI steps
- Focus on: error handling, retry logic, idempotency, logging
- External API calls MUST have: timeout, retry, error catch, rate limit respect
- Data validation at EVERY system boundary

**API Integration:**
- Same process but focus on: contract adherence, auth flow, error mapping
- Mock external APIs in tests (don't hit real services in CI)
- Document every endpoint consumed with expected response shape

**n8n Workflow:**
- Plan the workflow visually (describe nodes and connections)
- Implement with proper error handling on each node
- Test with sample data
- Document trigger conditions and expected outcomes

### Feature Priority Order:
1. Data model / database schema
2. API endpoints
3. Core business logic
4. UI components (only after backend works — respect UI timing)
5. AI integrations
6. Polish and edge cases

## Rules

### 45-Minute Rule
If a feature isn't working after 45 minutes:
1. Simplify to minimum viable version
2. Log in `docs/BLOCKERS.md` what was deferred and why
3. Move on immediately

### Commit Discipline
- One commit per working feature
- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`
- App must run after every commit
- Never commit broken code

### Code Quality
- No `console.log` in production code
- Error handling for all async operations
- Loading states for UI
- Real data, never lorem ipsum
- Follow `.hyper/brand.md` for visual decisions (colors, fonts, spacing). Also check `.stitch/DESIGN.md` and `docs/DESIGN-SPEC.md` if they exist
- **UI Quality (CRITICAL)**: Apply Uncodixfy (`~/.claude/skills/Uncodixfy/SKILL.md`) + frontend-design (`frontend-design:frontend-design`) when building ANY frontend. Default framework styling is NEVER acceptable. See generator agent for Anthropic's 4 criteria, banned patterns, and UI iteration loop (up to 5 rounds until Visual Quality 7+).

### Self-Evaluation Before Handoff
Before marking sprint complete:
- [ ] All sprint contract features implemented
- [ ] App starts without errors
- [ ] Primary user flow works end-to-end
- [ ] No build/type errors
- [ ] No console.log in source

Write summary in `docs/BUILD-LOG.md`.

## Handoff
When complete, the Evaluator takes over via `/hp-eval`.
