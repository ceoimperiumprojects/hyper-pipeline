---
description: Full autonomous pipeline. Give it a spec file or detailed description → it plans, builds, evaluates, fixes, and iterates until done. Zero user intervention needed. Works for new projects AND existing codebases.
---

# /hp-auto — Full Autonomous Mode

Give it a spec and walk away. It does everything.

## Usage

```
/hp-auto docs/SPEC.md              # From a spec file
/hp-auto "Build a REST API for..."  # From a description
/hp-auto                            # Reads docs/SPEC.md if exists
```

## What This Command Does

Runs the ENTIRE pipeline autonomously in a loop:

```
1. CODEBASE SCAN (existing project support)
   🤖 Reads entire codebase structure
   🤖 Identifies patterns, stack, conventions, existing tests
   🤖 Maps dependencies and architecture
   🤖 Generates CODEBASE-CONTEXT.md (what exists, what to reuse)

2. PLAN (hp-planner, opus/ultrathink)
   🤖 Reads spec + codebase context
   🤖 Generates PLAN.md respecting existing architecture
   🤖 Generates SPRINT-CONTRACT.md with testable behaviors
   🤖 NO USER INPUT — auto-approves plan

3. BUILD (hp-generator, opus/high)
   🤖 Feature by feature from contract
   🤖 TDD: write test → implement → verify
   🤖 Commit each feature
   🤖 45-min rule auto-enforced (simplify and continue)
   🤖 If build fails → auto-invoke build-error-resolver

4. BUILD→QA LOOP (Anthropic Harness Design V2 — 3 rounds max)
   Based on the paper's DAW example: Build 2h → QA 9m → Build 1h → QA 7m → Build 11m → QA 10m

   🤖 ROUND 1: Generator builds all features → Evaluator QAs with Playwright
      - Evaluator navigates live app, screenshots every page
      - Grades 4 criteria (Design Quality, Originality, Craft, Functionality)
      - Writes EVAL-REPORT.md with specific findings
   🤖 ROUND 2: Generator fixes all FAIL items → Evaluator re-QAs
      - Generator reads EVAL-REPORT, makes strategic decision: REFINE or PIVOT
      - Fixes all critical/major issues
      - Evaluator re-checks, finds remaining gaps
   🤖 ROUND 3: Generator addresses remaining gaps → Final QA
      - Last chance to fix before GTM phase
      - If still FAIL after 3 rounds → report remaining issues, continue to GTM

   Visual Quality below 7 = FAIL. Framework identifiable at a glance = FAIL.
   Generator may PIVOT to entirely different aesthetic between rounds.

6. GTM (if plan includes content/outreach/landing)
   🤖 Content creation (LinkedIn posts, carousels via Remotion or fallback)
   🤖 Lead generation (imperium-crawl or WebSearch fallback)
   🤖 Cold email sequences
   🤖 Landing page polish
   🤖 Logo generation (chatgpt-py)
   🤖 Visual audit on ALL GTM outputs (evaluator Phase C)

7. PRESENT (if plan includes presentation)
   🤖 HTML slides (zero-dep) or Remotion slides
   🤖 Demo script with timing
   🤖 Optional demo video

8. DONE
   🤖 Final commit with summary
   🤖 Writes docs/AUTO-SUMMARY.md with:
      - What was built
      - What tests pass
      - EVAL scores
      - GTM outputs (leads, posts, emails)
      - Any deferred items (BLOCKERS.md)

## Context Management (Auto Mode)

Long auto runs risk context exhaustion. Compact at these transitions:

```
After Phase 2 (PLAN) → compact, re-read: PLAN.md, SPRINT-CONTRACT.md, brand.md
After Phase 4 (EVAL) → compact, re-read: PLAN.md, EVAL-REPORT.md, brand.md
After Phase 6 (GTM)  → compact, re-read: PLAN.md, AUTO-SUMMARY draft
```

After each compaction: always re-read `docs/PLAN.md` and `.hyper/brand.md` as minimum context.
```

## Existing Project Support

When run on an existing project (not empty repo), the Codebase Scan step:

1. **Reads project structure** — package.json, tsconfig, Dockerfile, etc.
2. **Identifies stack** — React/Next/Vue, FastAPI/Express, PostgreSQL/SQLite, etc.
3. **Maps existing patterns:**
   - How are components organized?
   - What state management is used?
   - How are API endpoints structured?
   - What testing framework and patterns?
   - What styling approach (Tailwind, CSS modules, styled-components)?
4. **Finds reusable code:**
   - Existing utility functions
   - Shared components
   - API client setup
   - Auth middleware
   - Error handling patterns
5. **Generates `docs/CODEBASE-CONTEXT.md`:**
   ```markdown
   # Codebase Context

   ## Stack
   - Frontend: Next.js 15, TailwindCSS, shadcn/ui
   - Backend: Next.js API routes
   - Database: Supabase (PostgreSQL)
   - Testing: Vitest + Playwright

   ## Conventions
   - Components in src/components/[feature]/
   - API routes in src/app/api/[route]/
   - Shared types in src/types/
   - Tests co-located with source files

   ## Reusable
   - src/lib/api-client.ts — fetch wrapper with auth
   - src/components/ui/ — shadcn components
   - src/hooks/useAuth.ts — auth hook

   ## Patterns to Follow
   - Server Components by default
   - Zod validation on all inputs
   - Error boundaries on route segments
   ```

The Generator then builds NEW features using EXISTING patterns — not reinventing the wheel.

## Spec File Format

The input spec can be any format. Simple is fine:

```markdown
# What I Want

Add a dashboard page that shows:
- Total leads count
- Leads by status (pie chart)
- Recent activity feed
- AI-powered lead scoring summary

Requirements:
- Must use existing Supabase tables
- Match current design system
- Add E2E test for main flow
```

Or detailed PRD format — the Planner handles both.

## When to Use

- You have a clear spec and don't want to babysit
- Overnight builds — start it, come back to results
- Batch of tasks — run multiple /hp-auto in sequence
- When you trust the pipeline to make good decisions

## When NOT to Use

- Vague requirements ("make it better")
- Architecture-level decisions you want to make yourself
- When you need to see intermediate results before continuing
- → Use `/hp-go` instead for collaborative mode

## Output

When done, check:
- `docs/PLAN.md` — What it planned
- `docs/SPRINT-CONTRACT.md` — What it committed to
- `docs/EVAL-REPORT.md` — Quality scores
- `docs/AUTO-SUMMARY.md` — Full summary of what was done
- `docs/BLOCKERS.md` — Anything it couldn't solve
- `git log` — Feature-by-feature commit history
