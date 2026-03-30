---
description: Full autonomous pipeline. Give it a spec file or detailed description → it plans, builds, evaluates, fixes, and iterates until done. Zero user intervention needed. Works for new projects AND existing codebases.
---

# /hp-auto — Full Autonomous Mode (True Harness Design)

Give it a spec and walk away. Generator and Evaluator are PHYSICALLY SEPARATED agents.

## Usage

```
/hp-auto docs/SPEC.md              # From a spec file
/hp-auto "Build a REST API for..."  # From a description
/hp-auto                            # Reads docs/SPEC.md if exists
```

## Pipeline

```
THIS PROCESS (Orchestrator)
│
├─ 0. CONTEXT WIZARD (mandatory)
│     Existing project → "Šta radimo? Scope? Spec?"
│     New project → "Idea? Users? Stack? GTM? Brand?"
│
├─ 1. CODEBASE SCAN (if existing project)
│     Read structure, patterns, stack, conventions
│
├─ 2. BRAND (if new project + no .hyper/brand.md)
│     Auto-generate brand from spec — archetype, colors, fonts, voice
│     Save to .hyper/brand.md
│
├─ 3. PLAN (inline — NEVER skip)
│     Generate docs/PLAN.md + docs/SPRINT-CONTRACT.md
│     Include GTM phases if scope includes them
│
├─ 4. GIT BRANCH
│     New project: git init → git add . → git commit -m "init"
│     git checkout -b hp/[feature-name]
│     Existing project: run existing tests (baseline)
│
├─ 5. BUILD → EVAL LOOP (max 3 rounds)
│     ├─ Spawn Generator Agent (separate process, fresh context)
│     ├─ Spawn Evaluator Agent (SEPARATE, SKEPTICAL, fresh context)
│     │   Evaluates APP + ALL visual outputs
│     └─ REFINE/PIVOT decision based on score trends
│
├─ 6. MERGE
│     git checkout main && git merge hp/[feature-name]
│
├─ 7. RESEARCH (if scope includes GTM)
│     imperium-crawl: search, scrape, batch-scrape
│
├─ 8. LEAD GEN + OUTREACH (if scope includes GTM)
│     imperium-crawl + outreach skill → leads + email sequences
│
├─ 9. CONTENT (if scope includes GTM)
│     Remotion (ORIGINAL compositions) + chatgpt-py + content skill
│
├─ 10. PRESENTATION (if scope includes it)
│      Remotion video/slides + chatgpt-py hero images
│
├─ 11. FINAL VISUAL EVAL
│      Evaluator checks ALL visual outputs (not just app)
│
└─ 12. DONE
       Write docs/AUTO-SUMMARY.md
```

## STEP 0: CONTEXT WIZARD (mandatory)

**EXISTING PROJECT** (has package.json, src/, etc.):
```
Pitaj:
1. "Šta radimo?" → novi feature / bug fix / redesign / full build
2. "Imaš spec?" → fajl path ili opis
3. "Scope?" → samo dev / dev + GTM / full pipeline
```
Infer answers from spec if spec is detailed enough. Skip questions if answers are obvious.

**NEW PROJECT** (empty or minimal dir):
```
Pitaj:
1. "Šta praviš?" → idea description
2. "Ko su korisnici?" → target audience
3. "Tech stack?" → ili "da sam izaberem"
4. "Treba GTM?" → leads, content, outreach, presentation
5. Brand wizard → if no .hyper/brand.md exists
```

In auto mode, front-load ALL questions, then pure execution. No interruptions after wizard.

## Agent Spawning

### Generator Agent

Spawn with the Agent tool:

```
You are the Hyper-Pipeline Generator. Build features from the plan.

READ: docs/PLAN.md, docs/SPRINT-CONTRACT.md, .hyper/brand.md (if exists)

RULES:
1. ONE feature at a time, commit each: "feat: [description]"
2. TDD: test → implement → refactor
3. 45-minute rule: stuck → simplify or cut → docs/BLOCKERS.md
4. NEVER break the build
5. Write docs/BUILD-LOG.md when done

If docs/EVAL-REPORT.md exists from a previous round, read it.
- Scores improving → REFINE (incremental fixes)
- Scores flat/dropping → PIVOT (completely different approach)
Document decision in BUILD-LOG.md: "Round N: REFINE/PIVOT — [reasoning]"
```

### Evaluator Agent

Spawn with the Agent tool — **MUST be separate from generator:**

```
You are the Hyper-Pipeline Evaluator. SKEPTICAL by default.
You have NEVER seen the generator's code or process.

READ: docs/SPRINT-CONTRACT.md, docs/BUILD-LOG.md

PHASE A — Static: tsc, tests, grep console.log/TODO/secrets, file sizes
PHASE B — Runtime: Start app, Playwright, test ALL behaviors, edge cases, mobile
PHASE C — Visual audit on APP + ALL visual outputs:
  - App pages (Playwright screenshots)
  - LinkedIn post images (Read tool to view)
  - Carousel slides
  - Pitch deck slides
  - Landing page
  - Hero images
  - For EACH: alignment, typography, color, spacing, brand match, AI slop detection
  - Dribbble test + Framework test on everything
  - Score ≤6 on ANY visual = FAIL → regenerate
PHASE D — Grade 4×10: Functionality, Backend Quality, Visual Quality, Innovation

Write docs/EVAL-REPORT.md. BE SKEPTICAL. Issues ARE issues.
```

## Build→QA Loop

- **Round 1:** Generator builds ALL features → Evaluator QAs
- **Round 2:** Generator fixes FAIL items (REFINE or PIVOT) → Evaluator re-QAs
- **Round 3:** Generator addresses remaining gaps → Final QA
- After 3 rounds: report remaining issues, merge anyway

## GTM PHASES (run if scope includes GTM)

### Phase 7: RESEARCH

```
TOOLS: imperium-crawl (PRIMARY), WebSearch (fallback)
READ: skills/research/SKILL.md for 9-phase methodology

Actions:
- imperium-crawl search --query "[industry keywords]" --count 20
- imperium-crawl scrape [competitor URLs] → feature analysis
- imperium-crawl batch-scrape → bulk competitor data
- YouTube/Reddit/Instagram scraping → user sentiment
- WebSearch → latest news, funding, trends

Output: docs/RESEARCH.md
```

### Phase 8: LEAD GEN + OUTREACH

```
TOOLS: imperium-crawl + outreach skill
READ: skills/outreach/SKILL.md for BANT + email templates

Actions:
- imperium-crawl search → find companies in target market
- imperium-crawl batch-scrape with extraction schema:
  { "company": string, "contact": string, "email": string, "role": string }
- BANT qualification from outreach skill
- Generate 3-email sequences per qualified lead

Output: leads/qualified-leads.csv + leads/outreach-templates/
```

### Phase 9: CONTENT

```
TOOLS: Remotion (PRIMARY), chatgpt-py (hero images), content skill
READ: skills/content/SKILL.md for post types + hooks

IMPORTANT — Remotion usage:
- Remotion project at ~/Desktop/content/video/
- Use existing components as STRUCTURAL REFERENCE only
- Create NEW compositions with PROJECT-SPECIFIC brand from .hyper/brand.md
- NEVER copy colors/fonts/style from existing compositions
- Each project gets ORIGINAL visual identity

Actions:
- Write LinkedIn posts using content skill (12 types, 50+ hooks)
- Create post images:
  ├─ Remotion: new TSX composition → npx remotion still → PNG
  ├─ chatgpt-py: unique hero images → chatgpt image "..." --output file.png
  └─ EVERY image → visual eval (Read tool, check quality)
- Create carousels: Remotion frame-by-frame → PNG series
- Landing page: build as code feature

Output: content/ directory with posts + images
```

### Phase 10: PRESENTATION

```
TOOLS: Remotion (slides/video), chatgpt-py (unique visuals)

Actions:
- Create slide compositions in Remotion → render PNG per slide
- Wrap PNGs into PPTX via python-pptx
- chatgpt-py for unique slide illustrations
- Demo video: Remotion 1920x1080 MP4 (if applicable)

Output: docs/PRESENTATION/
```

### Phase 11: FINAL VISUAL EVAL

Spawn Evaluator Agent one more time to check ALL visual outputs:

```
Evaluate ALL visual outputs from this pipeline:
- App screenshots (if app was built)
- LinkedIn post images in content/
- Carousel slides in content/
- Presentation slides in docs/PRESENTATION/
- Landing page screenshots
- Any chatgpt-py generated images

For EACH image: alignment, typography, color, spacing, brand consistency, AI slop detection.
Score each 1-10. Any score ≤6 = FAIL → list what to regenerate.
```

## Context Management

```
After PLAN → compact, keep: PLAN.md, SPRINT-CONTRACT.md
After each EVAL round → compact, keep: PLAN.md, EVAL-REPORT.md, BUILD-LOG.md
After GTM phases → compact, keep: PLAN.md, AUTO-SUMMARY draft
```

Agents don't need compaction — each spawn gets fresh 200K context.
