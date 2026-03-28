# Harness Design — Implementation Reference

Based on [Anthropic's Harness Design for Long-Running Application Development](https://www.anthropic.com/engineering/harness-design-long-running-apps) by Prithvi Rajasekaran (Anthropic Labs).

This document encodes the complete methodology. ALL agents in this pipeline MUST read and follow it.

---

## Core Principle: The GAN-Inspired Architecture

> "Separating the agent doing the work from the agent judging it proves to be a strong lever. Tuning a standalone evaluator to be skeptical turns out to be far more tractable than making a generator critical of its own work."

The pipeline uses three agents inspired by Generative Adversarial Networks:

```
PLANNER  →  GENERATOR  ⇄  EVALUATOR
(expand)    (build)        (judge)
              ↑               |
              |   feedback    |
              └───────────────┘
```

The generator creates. The evaluator judges. The feedback loop drives quality up with each round. This separation is the single most important architectural decision.

---

## The Three Agents

### Planner (opus/ultrathink)

> "I created a planner agent that took a simple 1-4 sentence prompt and expanded it into a full product spec."

**Key behaviors from the paper:**
- **Ambitious scope** — The planner should expand beyond what the user asked for. A 1-sentence prompt becomes a 16-feature spec across multiple sprints.
- **High-level, not granular** — "Focus on product context and high-level technical design rather than detailed technical implementation. If the planner tried to specify granular technical details upfront and got something wrong, the errors in the spec would cascade into the downstream implementation."
- **Weave AI features in** — "I also asked the planner to find opportunities to weave AI features into the product specs." AI should be CORE to the product, not decorative.
- **Visual design language** — The planner reads the frontend-design skill and creates a visual design direction as part of the spec. This is not just "colors and fonts" — it's an aesthetic philosophy that guides the generator.

### Generator (opus/high)

> "The one-feature-at-a-time approach worked well for scope management."

**Key behaviors:**
- Build one feature at a time from the spec
- Self-evaluate before handing off to QA
- Git commit after each feature
- After receiving evaluator feedback: make a STRATEGIC DECISION — refine current direction or pivot to entirely different approach
- Never stub features — if a button exists, it must work

### Evaluator (opus/ultrathink)

> "Out of the box, Claude is a poor QA agent. I watched it identify legitimate issues, then talk itself into deciding they weren't a big deal and approve the work anyway."

**Key behaviors:**
- **SKEPTICAL by default** — Do not rationalize. Do not say "minor" when it affects UX.
- **Navigate the live app with Playwright** — Screenshot every page, click through every interaction
- **Grade against the sprint contract** — Each testable behavior: PASS or FAIL with specific details
- **Grade against the 4 criteria** — With hard thresholds
- **Be SPECIFIC** — Reference code files, line numbers, exact behavior observed vs expected

---

## The Build→QA Loop (V2 Architecture)

From the paper's DAW example with Opus 4.6:

```
┌─────────────────────────────────────────────────────┐
│                  BUILD + QA LOOP                     │
│                                                      │
│  Round 1:                                            │
│    Generator: Build all features (~2h)               │
│    Evaluator: Navigate live app, grade, find gaps    │
│    → Feedback: "Feature X is display-only,           │
│       Y doesn't work, Z is stubbed"                  │
│                                                      │
│  Round 2:                                            │
│    Generator: Fix all FAIL items (~1h)               │
│    Evaluator: Re-QA, find remaining gaps             │
│    → Feedback: "X now works, but Y still             │
│       missing, new issue W found"                    │
│                                                      │
│  Round 3:                                            │
│    Generator: Address remaining gaps (~15m)           │
│    Evaluator: Final QA → PASS or FAIL                │
│                                                      │
│  Max 3 rounds. If still failing → report to user.    │
└─────────────────────────────────────────────────────┘
```

**Each round, the evaluator:**
1. Starts the app (or verifies it's running)
2. Navigates EVERY page via Playwright MCP
3. Screenshots EVERY page
4. Tests EVERY sprint contract behavior (PASS/FAIL)
5. Probes edge cases (empty states, errors, mobile, rapid clicks)
6. Grades the 4 criteria with detailed reasoning
7. Writes feedback with specific file references

**After each round, the generator:**
1. Reads EVAL-REPORT.md
2. Makes strategic decision: REFINE or PIVOT
3. Fixes all FAIL items
4. Addresses evaluator recommendations
5. Documents decisions in BUILD-LOG.md

---

## The 4 Grading Criteria

From the paper, given to BOTH generator and evaluator:

### Design Quality (HIGH weight)
> "Does the design feel like a coherent whole rather than a collection of parts? Strong work here means the colors, typography, layout, imagery, and other details combine to create a distinct mood and identity."

### Originality (HIGH weight)
> "Is there evidence of custom decisions, or is this template layouts, library defaults, and AI-generated patterns? A human designer should recognize deliberate creative choices. Unmodified stock components—or telltale signs of AI generation like purple gradients over white cards—fail here."

### Craft (MEDIUM weight)
> "Technical execution: typography hierarchy, spacing consistency, color harmony, contrast ratios. This is a competence check rather than a creativity check. Most reasonable implementations do fine here by default; failing means broken fundamentals."

### Functionality (MEDIUM weight)
> "Usability independent of aesthetics. Can users understand what the interface does, find primary actions, and complete tasks without guessing?"

**Why Design Quality and Originality are weighted higher:**
> "Claude already scored well on craft and functionality by default, as the required technical competence tended to come naturally to the model. But on design and originality, Claude often produced outputs that were bland at best."

---

## Frontend Design Iteration Loop

For pages/screens that need visual quality, the paper runs 5-15 iterations:

```
┌──────────────────────────────────────────────────┐
│           FRONTEND DESIGN ITERATION LOOP          │
│                                                    │
│  Iteration 1: Generator creates initial design     │
│       ↓                                            │
│  Evaluator: Navigate live page with Playwright     │
│  Evaluator: Screenshot + study implementation      │
│  Evaluator: Score all 4 criteria                   │
│  Evaluator: Write detailed critique                │
│       ↓                                            │
│  Generator reads critique                          │
│  STRATEGIC DECISION:                               │
│    - Scores trending well? → REFINE                │
│    - Scores flat/declining? → PIVOT to new aesthetic│
│       ↓                                            │
│  Iteration 2: Generator refines or pivots          │
│       ↓                                            │
│  [Repeat until scores plateau or max iterations]    │
│                                                    │
│  Target: Design Quality ≥ 7, Originality ≥ 7       │
│  Max iterations: 5 for app pages, 10 for landing    │
└──────────────────────────────────────────────────┘
```

**Key insight from paper:**
> "I also instructed the generator to make a strategic decision after each evaluation: refine the current direction if scores were trending well, or pivot to an entirely different aesthetic if the approach wasn't working."

> "In one notable example... on the tenth cycle, it scrapped the approach entirely and reimagined the site as a spatial experience: a 3D room with a checkered floor rendered in CSS perspective."

Creative breakthroughs happen at LATER iterations, not the first pass.

---

## Evaluator Calibration (Few-Shot Examples)

From the paper: "I calibrated the evaluator using few-shot examples with detailed score breakdowns."

### Functionality Findings — Calibration

**GOOD finding (specific, actionable, with code reference):**
> FAIL — Rectangle fill tool only places tiles at drag start/end points instead of filling the region. `fillRectangle` function exists at `LevelEditor.tsx:234` but isn't triggered properly on mouseUp.

> FAIL — Delete key handler at `LevelEditor.tsx:892` requires both `selection` and `selectedEntityId` to be set, but clicking an entity only sets `selectedEntityId`. Condition should be `selection || (selectedEntityId && activeLayer === 'entity')`.

> FAIL — `PUT /frames/reorder` route defined after `/{frame_id}` routes. FastAPI matches 'reorder' as a frame_id integer and returns 422.

**BAD finding (vague, rationalized):**
> The fill tool has some minor issues but overall works okay.

> The delete function mostly works, though there might be some edge cases.

> API seems to have a small routing issue but it's not critical.

### Design Quality — Calibration

**Score 3/10 (FAIL — generic AI output):**
> The dashboard uses default shadcn/ui Card components with zero visual customization. Sidebar is standard 240px with bg-zinc-900. Typography is Inter at default sizes with no hierarchy beyond size changes. The color palette is the default Tailwind slate + blue that every AI-generated dashboard uses. There is no distinct mood or identity — this could be literally any SaaS dashboard template. A human designer would see zero evidence of deliberate creative choices. This is the textbook definition of AI slop.

**Score 5/10 (FAIL — some effort but still generic):**
> The dashboard shows some color customization beyond defaults — the teal accent is distinctive. But the layout is still the standard "stats cards → table → sidebar" pattern that every AI produces. Typography uses Inter which, while readable, carries no personality. The cards have the telltale oversized rounded corners (16px) and soft shadows that scream "AI-generated." Spacing is consistent but mechanical. A designer would recognize about 20% custom decisions and 80% library defaults.

**Score 8/10 (PASS — distinctive and crafted):**
> The dashboard has a distinctive editorial feel inspired by Bloomberg Terminal. Data density is high but readable through careful use of whitespace within rows. The custom monospace font (JetBrains Mono) for numerical data creates a financial terminal aesthetic, while the condensed sans-serif headings (Space Grotesk at 600 weight) establish clear hierarchy without shouting. The color system uses muted teals (#0D9488) against charcoal (#1C1C1E) with sharp orange (#F97316) reserved exclusively for price alerts — a deliberate restraint that makes alerts visually urgent. Border radius is consistently 6px — enough to soften without the "AI bubble" effect. The sidebar uses a custom type scale that's denser than the main content, creating a tool-palette feeling. This feels designed by a human with opinions, not generated by an AI following defaults.

**Score 10/10 (exceptional — museum quality):**
> The interface transcends typical web application aesthetics. It uses a bespoke spatial layout where data panels overlap in a deliberate z-index hierarchy, creating depth without 3D. Typography combines Untitled Sans for interface chrome with Newsreader for data annotations — an unexpected pairing that creates editorial tension. The color system is essentially monochrome (warm grays with a single coral accent at #FF6B6B) but achieves remarkable visual interest through transparency layers and subtle noise textures on surfaces. Micro-interactions use spring physics with carefully tuned damping — buttons don't just change color, they breathe. The overall impression is closer to a design studio's portfolio than a SaaS dashboard. This would stop someone mid-scroll on Dribbble.

---

## Sprint Contract Negotiation

Before building, generator and evaluator agree on what "done" looks like:

```
1. Generator writes: docs/SPRINT-CONTRACT-PROPOSAL.md
   - What I'll build
   - How each feature will be tested
   - Success criteria for each behavior

2. Evaluator reviews:
   - Are the criteria testable and specific?
   - Does the proposal match the PLAN.md spec?
   - Are there missing behaviors that should be tested?
   - Writes feedback to docs/SPRINT-CONTRACT-REVIEW.md

3. Generator updates proposal based on feedback

4. When both agree → CONTRACT.md becomes the source of truth
```

> "This existed because the product spec was intentionally high-level, and I wanted a step to bridge the gap between user stories and testable implementation."

---

## State Management: Files, Not Context

> "Communication was handled via files: one agent would write a file, another agent would read it and respond either within that file or with a new file."

All inter-agent communication goes through docs/:
- `docs/PLAN.md` — Planner → Generator, Evaluator
- `docs/SPRINT-CONTRACT.md` — Generator ↔ Evaluator (negotiated)
- `docs/BUILD-LOG.md` — Generator → Evaluator
- `docs/EVAL-REPORT.md` — Evaluator → Generator
- `.hyper/brand.md` — Planner → Generator, Evaluator, Presenter

Context is ephemeral. Files are permanent. Always write important state to disk.

---

## Harness Evolution Principles

> "Every component in a harness encodes an assumption about what the model can't do on its own, and those assumptions are worth stress testing, both because they may be incorrect, and because they can quickly go stale as models improve."

> "Find the simplest solution possible, and only increase complexity when needed."

> "The evaluator is not a fixed yes-or-no decision. It is worth the cost when the task sits beyond what the current model does reliably solo."

With Opus 4.6:
- Sprint decomposition removed (model handles coherence natively)
- Evaluator moved to end-of-build pass (still catches real gaps)
- Context resets replaced by compaction (no context anxiety with 4.6)
- Planner and evaluator remain essential — planner for scope, evaluator for quality

---

## Aspirational Language

The paper notes: "Including phrases like 'the best designs are museum quality' pushed designs toward a particular visual convergence, suggesting that the prompting associated with the criteria directly shaped the character of the output."

Use aspirational language in ALL agent prompts:
- "The best designs feel intentionally crafted — as if a senior designer spent days on every detail"
- "A human designer should immediately recognize that deliberate creative choices were made"
- "Generic AI output is the comfortable default. Your job is to push PAST that default aggressively"
- "Would this make someone stop mid-scroll on Dribbble? If not, it's not done yet"
- "The difference between good and great is the last 20% of effort — the details that most people skip"
