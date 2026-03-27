---
name: pipeline-present
description: Presentation generation skill for hackathon demos. Creates HTML slide decks, demo scripts with fallbacks, and optional Remotion video walkthroughs.
origin: hyper-pipeline
---

# Pipeline Present

Creates presentation materials that maximize the Presentation judging criterion (33% of hackathon score).

## When to Activate

- User invokes `/hp-present`
- Hackathon mode, Phase 7
- When demo/presentation materials are needed

## What It Produces

### 1. HTML Slide Deck (`presentation.html`)
- Single self-contained HTML file, zero dependencies
- 12-15 slides for a 5-minute presentation
- Arrow key navigation, progress indicator
- Visual style matches `.stitch/DESIGN.md` for cohesion with app
- Responsive (any projector resolution)

### 2. Demo Script (`docs/DEMO-SCRIPT.md`)
- Precise timing for each demo step
- Exact actions: what to click, what to type
- Expected results: what should appear
- Talking points for each step
- Fallback plan: what to do if something breaks

### 3. Remotion Video (optional, `presentation/demo.mp4`)
- App walkthrough with smooth transitions
- Text overlays explaining features
- 60-90 second backup video
- Uses Remotion Stitch skill if available

## Slide Structure

| # | Slide | Time | Purpose |
|---|-------|------|---------|
| 1 | Title | 10s | App name, tagline, team |
| 2 | Problem | 30s | What sustainability challenge |
| 3 | Why Now | 20s | Why AI is the unlock |
| 4 | Solution | 30s | One sentence + hero screenshot |
| 5 | How It Works | 30s | Architecture or user flow |
| 6 | LIVE DEMO | 120s | Switch to running app |
| 7 | AI Deep Dive | 30s | Show AI reasoning |
| 8 | Innovation | 20s | What's genuinely new |
| 9 | Impact | 20s | Numbers and projections |
| 10 | Tech Stack | 10s | What we built with |
| 11 | Future | 20s | Where this goes next |
| 12 | Thank You | 10s | Contact, Q&A |

## Key Principles

- **Story > Features** — Tell problem→solution→impact narrative
- **Show > Tell** — Live demo beats bullet points
- **Visual cohesion** — Same design language as app
- **Time precision** — Practice with exact timing
- **Have fallbacks** — Murphy's law applies to demos
- **One idea per slide** — Large text, readable from back of room

## Process

1. Read `docs/PLAN.md` for product context, innovation argument
2. Read `docs/EVAL-REPORT.md` for known issues (don't demo broken features)
3. Read `.stitch/DESIGN.md` for visual style
4. Generate slide deck HTML
5. Write demo script with exact timing
6. (Optional) Generate Remotion composition

## Context Sources

- Innovation argument → from PLAN.md
- Working features → from BUILD-LOG.md and EVAL-REPORT.md
- Visual style → from DESIGN.md
- App URL → from deploy or local dev server
