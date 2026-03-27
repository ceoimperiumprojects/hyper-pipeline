---
description: 'Hackathon sprint mode — structured 24h pipeline with 8 phases. From brainstorm to winning presentation. Loads hackathon rules (time management, demo-first, innovation focus). Use when preparing for or executing a hackathon.'
---

# /hp-hackathon — 24h Sprint Mode

Win hackathons with a structured 8-phase pipeline.

## Usage

```
/hp-hackathon "AI x Climate Tech, Podgorica, 24h, solo"
/hp-hackathon docs/HACKATHON-BRIEF.md
/hp-hackathon                                          # Asks for details
```

## What This Command Does

Runs the full pipeline in **hackathon mode** — optimized for speed, demo impact, and innovation scoring.

**Key differences from /hp-auto:**
- 8 timed phases (not sprints)
- Hackathon rules loaded (demo-first, time caps, innovation focus)
- Brand wizard is quick (archetype + primary color only, rest auto)
- Research abbreviated (5 competitors max, 10 min)
- Innovation criterion scored (AI must be CORE)
- Presentation phase is mandatory (33% of hackathon score)
- HACKATHON-CLAUDE.md generated (context reload document)

## 8 Phases

```
Phase 0: SETUP                    30 min    🤖 Auto
  → Verify tools (MCP, Stitch, Playwright, chatgpt-py)
  → Generate HACKATHON-CLAUDE.md template
  → Create repo structure
  → Quick brand (archetype + primary color)

Phase 1: BRAINSTORM               2.5h      ✋ You lead
  → Research theme + competitors (abbreviated)
  → Generate 3-5 idea candidates with AI angle
  → Score ideas: feasibility × impact × demo-ability
  → Hard cap: if no decision by T+2:15, auto-pick simplest viable
  → Output: PLAN.md + SPRINT-CONTRACT.md

Phase 2: BUILD BACKEND            5h        🤖 Auto
  → Data model + API endpoints
  → AI integration (core feature)
  → Seed demo data (realistic, tells a story)
  → Mid-sprint QA at T+2:30
  → Test deploy after backend done (catch issues early!)

Phase 3: DESIGN                   1.5h      ✋ You approve
  → "Stitch MCP ili ručno?"
  → If ručno: quick UI questions → DESIGN-SPEC.md
  → If no Stitch: build from spec + brand.md
  → Mobile-responsive, dark mode if brand says so

Phase 4: BUILD FRONTEND + AI      5.5h      🤖 Auto
  → UI components from design spec
  → AI features visible to user (show reasoning!)
  → Feedback loops: User → AI → Action → User
  → Golden path first, extras second
  → Mid-sprint QA at T+2:45
  → 45-min rule strictly enforced

Phase 5: TEST + VISUAL VALIDATION 3h        🤖 Auto
  → Playwright E2E on golden path
  → Visual audit (multimodal)
  → Fix critical bugs only (no polish)
  → EVAL-REPORT.md with 4 criteria including Innovation

Phase 6: POLISH + DEPLOY          2.5h      🤖 Auto
  → Deploy to Vercel/Netlify/Railway
  → Fix top 3 visual issues from eval
  → Seed final demo data
  → Generate OG image + favicon

Phase 7: PRESENTATION             2.5h      🤖 Auto
  → 12-slide HTML presentation (zero-dep)
  → Demo script with timing (5 min)
  → Fallback plan (screenshots, pre-recorded video)
  → LinkedIn post image via chatgpt-py
  → Logo via chatgpt-py (if not done)

Phase 8: REHEARSAL                 1.5h      ✋ You practice
  → Practice demo 2-3 times with timer
  → Refine talking points
  → Test fallback scenarios
  → Final deploy check
```

## What Gets Generated

```
docs/
├── PLAN.md                    # Product spec + architecture
├── SPRINT-CONTRACT.md         # Testable behaviors
├── EVAL-REPORT.md             # QA scores (incl. Innovation)
├── BUILD-LOG.md               # What was built + blockers
├── DEMO-SCRIPT.md             # Timed demo with fallbacks
├── presentation.html          # 12-slide zero-dep HTML
├── HACKATHON-CLAUDE.md        # Context reload document
.hyper/
├── brand.md                   # Quick brand identity
content/
├── post-launch-image.png      # LinkedIn image (chatgpt-py)
```

## HACKATHON-CLAUDE.md

This is your **context reload document**. When Claude Code compacts context mid-hackathon, it re-reads this file to restore full awareness:

- Project name, theme, current phase
- Architecture decisions made
- Key files and their purpose
- What's done vs what remains
- Pipeline commands for each phase

## Hackathon Rules (Auto-Loaded)

From `rules/hackathon.md`:
- Phase timing is sacred — hard stops
- Brainstorm cap: 2.5h max
- AI is core, not decorative
- Build for the demo — golden path first
- 3 polished features > 10 half-broken
- Demo data must tell a story (no Lorem Ipsum)
- Fallback plan required
- Rehearse 2-3 times

## When to Use

- You have a hackathon coming up (prep mode)
- You're AT a hackathon (execution mode)
- Solo or team (pipeline handles both)
- Any theme — AI x [anything]

## When NOT to Use

- Building a production app → `/hp-auto` or `/hp-go`
- Just need a plan → `/hp-plan`
- No time pressure → `/hp-go`
