---
description: Collaborative pipeline mode. You and Claude work together — you make key decisions, Claude handles the heavy lifting. Best for existing projects and when you want control. Automates what can be automated, asks you when it matters.
---

# /hp-go — Collaborative Mode (True Harness Design)

You drive. Claude executes. Generator and Evaluator are PHYSICALLY SEPARATED (separate agents, fresh context).

## Usage

```
/hp-go "Add real-time notifications system"
/hp-go docs/FEATURE.md
/hp-go                                        # Asks what you want to do
```

## Architecture: True Harness Design

```
THIS PROCESS (Orchestrator)
├─ STEP 1: Plan (inline — read-only analysis)
├─ STEP 2: ✋ User approves plan
├─ STEP 3: Spawn Generator Agent (SEPARATE process, fresh 200K context)
├─ STEP 4: Spawn Evaluator Agent (SEPARATE process, fresh 200K context)
├─ STEP 5: ✋ User reviews eval
└─ STEP 6: Fix loop or merge
```

**WHY separation matters:** From Anthropic's research — "Out of the box, Claude is a poor QA agent. I watched it identify legitimate issues, then talk itself into deciding they weren't a big deal." Physical separation prevents this bias.

## STEP 0: CONTEXT WIZARD (before anything else)

**EXISTING PROJECT** (has code):
- "Šta radimo?" → novi feature / bug fix / redesign / full build
- "Imaš spec ili da opišeš?" → file path ili opis
- "Scope?" → samo dev / dev + GTM / full pipeline

**NEW PROJECT** (empty dir):
- "Šta praviš?" → idea
- "Ko su korisnici?" → target audience
- "Tech stack?" → ili "da sam izaberem"
- **Brand wizard** if no `.hyper/brand.md`:
  1. "Koji arhetip? (Innovator/Sage/Hero/Creator/Explorer/Rebel/...)" → defines personality
  2. "Primary color?" → or auto-pick from industry (blue=trust, green=growth, etc.)
  3. "Mood?" → (bold, minimal, playful, editorial, brutalist, etc.)
  4. Save to `.hyper/brand.md` — ALL visual decisions flow from this file

Ask these BEFORE proceeding. Use AskUserQuestion tool for structured choices.

## STEP 1: PLANNING (mandatory — NEVER skip)

**You MUST generate these files before ANY building starts:**

1. Read existing codebase: structure, patterns, tech stack, conventions
2. Read user's spec/prompt
3. Generate `docs/PLAN.md`:
   - Product overview, features (prioritized), architecture
   - Sprint plan with feature grouping
   - For existing projects: what to REUSE vs CREATE
4. Generate `docs/SPRINT-CONTRACT.md`:
   - Testable acceptance criteria for EVERY feature
   - Format per behavior:
     ```
     - [ ] BEHAVIOR: [exact user action]
       - TEST: [how to verify]
       - EXPECTED: [exact expected result]
     ```

**HARD RULE: If `docs/PLAN.md` and `docs/SPRINT-CONTRACT.md` don't exist after this step, STOP. Do not proceed to building.**

5. Present plan to user with AskUserQuestion:
   - Show feature list, sprint structure, key decisions
   - User approves, modifies, or rejects

## Error Handling

- If the generator agent won't start or is unavailable, fallback to inline building within this process
- If eval agent fails with HARD FAIL, log the error and retry once before escalating to user
- Always handle errors gracefully — never leave the project in a broken state

## STEP 2: GIT SAFETY

**NEW PROJECT (no .git/):**
```bash
git init
git add . && git commit -m "init: project scaffold"
git checkout -b hp/[feature-name]
```

**EXISTING PROJECT:**
```bash
git checkout -b hp/[feature-name]
# Run existing tests as baseline check
npm test || echo "No tests yet"
```

All work goes on feature branch. Never directly on main.

## STEP 3: BUILD — Spawn Generator Agent

**CRITICAL: Use the Agent tool to spawn a SEPARATE generator process.**

Launch an Agent with this prompt (adapt the spec details):

```
You are the Hyper-Pipeline Generator. Build features from the plan.

READ THESE FILES FIRST:
- docs/PLAN.md — product spec
- docs/SPRINT-CONTRACT.md — acceptance criteria
- .hyper/brand.md — brand identity (if exists)

RULES:
1. Build ONE feature at a time
2. TDD: write test → make it pass → refactor
3. Git commit after EACH feature: "feat: [description]"
4. 45-minute rule: if stuck, simplify or cut. Log in docs/BLOCKERS.md
5. NEVER break the build — app must run after every commit
6. Self-evaluate before finishing: check your own work
7. Write docs/BUILD-LOG.md with what you built

After building ALL features, write a summary in docs/BUILD-LOG.md.
```

**Do NOT use isolation: "worktree" for the generator** — it needs to commit to the feature branch in the real repo.

Wait for the generator agent to complete. Read `docs/BUILD-LOG.md` for results.

## STEP 4: DESIGN REVIEW (if frontend) ✋

After backend build, before frontend:
- Ask user: "Stitch MCP ili ručni dizajn?"
- Present design spec for approval
- Then spawn generator again for frontend features

## STEP 5: EVAL — Spawn Skeptical Evaluator Agent

**CRITICAL: Use the Agent tool to spawn a SEPARATE evaluator process with FRESH context.**

Launch an Agent with this prompt:

```
You are the Hyper-Pipeline Evaluator. You are SKEPTICAL by default.

You have NEVER seen the generator's code or process. You judge the OUTPUT only.

READ THESE FILES:
- docs/SPRINT-CONTRACT.md — these are your acceptance criteria
- docs/BUILD-LOG.md — what was supposedly built (verify, don't trust)

YOUR JOB:
1. PHASE A — Static Analysis:
   - npx tsc --noEmit (compilation check)
   - npm test (existing tests must pass)
   - grep for console.log, TODO, FIXME, hardcoded secrets
   - Check file sizes (>800 lines = flag)

2. PHASE B — Runtime Testing (Playwright):
   - Start the app
   - Navigate EVERY page, screenshot each
   - Test EVERY sprint contract behavior
   - Test edge cases: empty inputs, errors, mobile (375px), rapid clicks
   - Use REAL data, not "test123"

3. PHASE C — Visual Audit (if frontend):
   - Screenshot every page
   - Check: alignment, typography, color, spacing, brand consistency
   - AI Slop Detection: default shadcn = FAIL, purple gradients = FAIL
   - Dribbble test: would this get engagement? If NO → max 6
   - Framework test: can you tell which framework? If YES → max 5

4. PHASE D — Grading (4 × 10 = 40):
   - Functionality: does everything work E2E?
   - Code/Backend Quality: API design, tests, security, architecture
   - Visual Quality: design + originality + craft (≤6 = AUTO FAIL)
   - Innovation: AI depth, creative decisions

WRITE docs/EVAL-REPORT.md with:
- Overall PASS/FAIL + score
- Each behavior: PASS/FAIL
- Bugs with severity, repro steps, suggested fix (file:line)
- Visual audit per page with screenshots

BE SKEPTICAL. When you find an issue, it IS an issue. Do not rationalize.
Do not say "minor" when it affects UX. Do not approve mediocre work.
```

Wait for the evaluator agent to complete. Read `docs/EVAL-REPORT.md`.

## STEP 6: DECISION ✋

Present EVAL-REPORT to user:
- Show overall score
- Show PASS/FAIL per behavior
- Show bug list
- Show visual audit summary

Ask user:
- **"Fix bugs"** → Go back to STEP 3 (max 3 rounds)
  - Check score trends: improving → REFINE, stagnating → PIVOT
- **"Ship it"** → Merge feature branch to main
- **"Also change X"** → Add to sprint contract, back to STEP 3

```bash
# On ship:
git checkout main
git merge hp/[feature-name]
```

## Decision Points Summary

| Step | Who | What |
|------|-----|------|
| 1. Plan | ✋ You | Approve/modify/reject the plan |
| 3. Build | 🤖 Agent | Separate generator builds features |
| 4. Design | ✋ You | Approve design direction (if frontend) |
| 5. Eval | 🤖 Agent | Separate skeptical evaluator grades |
| 6. Decision | ✋ You | Fix / Ship / Change |

## vs Other Modes

| | `/hp-auto` | `/hp-go` | `/hp-build` + `/hp-eval` |
|--|-----------|---------|--------------------------|
| User involvement | 0% | ~20% | 100% |
| Agent separation | Yes | **Yes** | Manual |
| Best for | Clear specs | Daily dev, existing projects | Learning |
| Planning enforced | Yes | **Yes** | Manual |
