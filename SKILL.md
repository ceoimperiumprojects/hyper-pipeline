---
name: hyper-pipeline
description: 'AI execution engine — activated ONLY via /hp-* commands. Do NOT auto-trigger on keywords. Commands: /hp-auto (full autonomous), /hp-go (collaborative), /hp-hackathon (24h sprint), /hp-plan, /hp-build, /hp-eval, /hp-design, /hp-present.'
user-invocable: false
---

# Hyper-Pipeline

The ultimate AI execution engine. Plan → Build → Evaluate → Ship.

## Quick Start

```
/hp-auto docs/SPEC.md     → Full auto: spec in, everything out
/hp-go "add lead scoring"  → Collaborative: you decide, Claude executes
/hp-plan "new feature"     → Just planning
/hp-build                  → Just building
/hp-eval                   → Just QA + visual validation
```

---

## ROUTING TABLE

Match user intent to the right mode and sub-skills:

### Mode Selection

| User says | Mode | Command |
|-----------|------|---------|
| "odradi sve", "full auto", "evo spec", "napravi ovo" | Auto | `/hp-auto` |
| "hajde zajedno", "pomozi mi", "treba mi feature" | Collab | `/hp-go` |
| "hakaton", "24h sprint", "hackathon" | Hackathon | `/hp-hackathon` |
| "napravi plan", "spec this out" | Plan only | `/hp-plan` |
| "build this", "kodiraj", "implementiraj" | Build only | `/hp-build` |
| "testiraj", "QA", "proveri" | Eval only | `/hp-eval` |
| "dizajn", "UI", "Stitch" | Design only | `/hp-design` |
| "prezentacija", "slides", "demo" | Present only | `/hp-present` |

### Sub-Skill Routing

| Keywords | Sub-Skill | Path |
|----------|-----------|------|
| plan, spec, features, architecture | `skills/plan/` | Planning + brand brainstorm |
| build, code, implement, feature | `skills/build/` | Feature-by-feature building |
| test, QA, eval, bugs, quality | `skills/eval/` | QA + visual validation |
| design, UI, Stitch, colors, layout | `skills/design/` | Stitch + DESIGN.md |
| present, slides, demo, video, LinkedIn image | `skills/present/` | Remotion visual engine |
| research, competitors, market, ecosystem | `skills/research/` | Market research (9 phases) |
| brand, colors, fonts, identity, archetype | `skills/brand/` | Brand wizard + multi-brand registry |
| content, LinkedIn post, carousel, video | `skills/content/` | Content creation |
| outreach, cold email, leads, sales, pipeline | `skills/outreach/` | Sales + lead gen |
| validate, idea, MVP, problem-solution fit | `skills/validate/` | Idea validation |

---

## THREE MODES

### 1. /hp-auto — Full Autonomous

Give it a spec. Walk away. Come back to everything done.

```
PHASE 0: GATHERING (only interactive part)
  ✋ Brand selection/creation
  ✋ Scope questions (leads? content? landing page?)
  🤖 Research (auto)
  🤖 PLAN.md with ALL answers baked in

PHASE 1+: PURE EXECUTION (zero interrupts)
  🤖 Build → Eval → Fix loop (max 3x)
  🤖 Visual validation on all outputs
  🤖 Lead gen → Content → Landing → Outreach
  🤖 Presentation → Demo video
  🤖 AUTO-SUMMARY.md when done
```

### 2. /hp-go — Collaborative

You drive key decisions. Claude handles heavy lifting.

```
Decision points (✋):
  1. Plan review — approve/modify/reject
  2. Design review — approve visual direction
  3. Eval review — fix bugs or accept

Auto parts (🤖):
  - Codebase scan
  - Feature building
  - Testing
  - Bug fixing
```

### 3. Hackathon — 24h Sprint

```
Phase 0: Setup              30 min
Phase 1: Brainstorm ✋       2.5h
Phase 2: Build Backend      5h
Phase 3: Design ✋           1.5h
Phase 4: Build UI+AI        5.5h
Phase 5: Test + Visual Val   3h
Phase 6: Polish + Deploy    2.5h
Phase 7: Presentation       2.5h
Phase 8: Rehearsal ✋        1.5h
```

---

## CORE ARCHITECTURE

```
┌────────────┐   ┌─────────────┐   ┌─────────────┐
│  PLANNER   │──>│  GENERATOR  │──>│  EVALUATOR  │
│ opus/ultra │   │  opus/high  │   │ opus/ultra  │
│            │   │             │   │             │
│ + Brand    │   │ + TDD       │   │ + Visual    │
│ + Research │   │ + Verify    │   │   Audit     │
│ + Capabil. │   │ + 45-min    │   │ + Playwright│
└────────────┘   └──────┬──────┘   └──────┬──────┘
                        │                  │
                        │    FAIL: fix     │
                        └──────────────────┘
                             PASS: Done ✓
```

## BRAND SYSTEM

Multi-brand hybrid registry:
```
Priority:
1. .hyper/brand.md (in project root)
2. ~/.hyper/brands/[name].md (central registry)
3. Brand wizard → creates new + saves to registry
```

All sub-skills (content, outreach, design, present) read the active brand.

## KEY FILES (state on disk, survives compaction)

| File | Created by | Used by |
|------|-----------|---------|
| docs/PLAN.md | Planner | Generator, Evaluator, Presenter |
| docs/SPRINT-CONTRACT.md | Planner | Generator, Evaluator |
| docs/EVAL-REPORT.md | Evaluator | Generator (fixes) |
| docs/BUILD-LOG.md | Generator | Evaluator |
| .hyper/brand.md | Brand wizard | All content/design skills |

## VISUAL VALIDATION

Evaluator Phase C — Claude multimodal reviews ALL visual outputs:
- App UI screenshots
- Remotion-generated images (LinkedIn, carousel, OG)
- Presentation slides
- Landing page

Checks: alignment, typography, color harmony, spacing, brand consistency, "AI slop" detection, professional polish.

## CAPABILITIES AWARENESS

Planner reads available tools and integrates them into sprint plans:
- imperium-crawl → research, lead scraping
- Remotion → all visual outputs
- Playwright → QA testing
- Stitch MCP → UI design
- Whisper → transcription
- ffmpeg → media processing
- chatgpt-py → image/logo generation

## TOOL REFERENCES

| Tool | GitHub | Install |
|------|--------|---------|
| **imperium-crawl** | [github.com/ceoimperiumprojects/imperium-crawl](https://github.com/ceoimperiumprojects/imperium-crawl) | `npm install -g imperium-crawl` |
| **chatgpt-py** | [github.com/ceoimperiumprojects/chatgpt-py](https://github.com/ceoimperiumprojects/chatgpt-py) | `cd chatgpt-py && pip install -e .` |
| **Remotion** | [github.com/remotion-dev/remotion](https://github.com/remotion-dev/remotion) | `npx create-video@latest` |
| **Playwright** | [github.com/microsoft/playwright](https://github.com/microsoft/playwright) | `npx playwright install` |
| **Stitch MCP** | [github.com/davideast/stitch-mcp](https://github.com/davideast/stitch-mcp) | `npx @_davideast/stitch-mcp init` |
| **Stitch Skills** | [github.com/google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) | `npx skills add google-labs-code/stitch-skills` |
