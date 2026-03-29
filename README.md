<p align="center">
  <img src="hyper-pipeline-hero.png" alt="Hyper-Pipeline" width="100%">
</p>

<h1 align="center">Hyper-Pipeline</h1>

<p align="center">
  <strong>The ultimate AI execution engine for Claude Code.</strong><br>
  Give it a spec. Walk away. Come back to a working app, brand identity, leads, content, landing page, and pitch deck.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-2.0.0-blue?style=flat-square" alt="v2.0.0">
  <img src="https://img.shields.io/badge/commands-13-green?style=flat-square" alt="13 Commands">
  <img src="https://img.shields.io/badge/skills-11-purple?style=flat-square" alt="11 Skills">
  <img src="https://img.shields.io/badge/agents-4-orange?style=flat-square" alt="4 Agents">
  <img src="https://img.shields.io/badge/harness-Anthropic_Design-ff6b6b?style=flat-square" alt="Anthropic Harness">
  <img src="https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square" alt="MIT">
</p>

---

## The Problem

You have an idea. You want to go from zero to a shipped product — app, brand, leads, content, pitch deck — but the process is fragmented. You plan in one tool, design in another, code in a third, write emails in a fourth, make slides in a fifth.

**Hyper-Pipeline unifies everything into one command.**

## What It Does

```
You: /hp-auto docs/SPEC.md

Hyper-Pipeline:
  ✅ Researches the market (imperium-crawl)
  ✅ Creates brand identity (12 archetypes, colors, fonts, voice)
  ✅ Plans the product (spec + sprint contracts + acceptance criteria)
  ✅ Builds backend first, then design, then frontend + AI
  ✅ Tests everything (Playwright QA + visual validation)
  ✅ Finds and qualifies leads (BANT scoring)
  ✅ Creates LinkedIn posts with branded images (Remotion)
  ✅ Generates cold email outreach sequences
  ✅ Builds a landing page
  ✅ Creates a pitch deck (PPTX + demo video)
  ✅ Delivers AUTO-SUMMARY.md with everything done

You: *wakes up* "holy shit it actually worked"
```

---

## Three Modes

### `/hp-auto` — Full Autonomous

Give it a spec. Sleep. Wake up to everything built.

**Zero questions, zero interrupts.** Everything is auto-inferred from your spec. Brand auto-generated. Design auto-detected (Stitch MCP → Stitch Skills → build from spec). Context compaction at phase transitions for long runs.

```
/hp-auto docs/MY-IDEA.md
```

**8-phase flow:**
1. Codebase scan (existing project support)
2. Plan + brand + research (auto-inferred from spec)
3. Build backend
4. Design (auto-detects: Stitch MCP → Stitch Skills → build from spec)
5. Build frontend + AI
6. Eval (static + Playwright + visual audit) → fix loop (max 3x)
7. GTM (content, leads, outreach, landing page, logo)
8. Present (slides, demo script, demo video) → AUTO-SUMMARY.md

### `/hp-go` — Collaborative

You drive. Claude executes. **3 key decisions, everything else is auto.**

```
/hp-go "add real-time notifications to my app"
```

| Decision Point | When | What you decide |
|---------------|------|----------------|
| 1. Plan Review | After codebase scan | Approve scope, features, sprint contracts |
| 2. Design Review | After backend build | "Stitch MCP ili ručno?" → approve visual direction |
| 3. Eval Review | After frontend build | Accept quality or request fixes |

**Git safety for existing projects:** Creates feature branch before building. Runs existing tests before AND after. Merge on accept, branch preserved on reject.

**Smart design flow:** Asks "Stitch MCP ili ručno?" — if ručno, asks detailed UI questions (screens, flow, osećaj, layout) and generates comprehensive DESIGN-SPEC.md. Design review happens AFTER backend (real data shapes) and BEFORE frontend build.

**Best for existing projects.** Scans your codebase, respects your patterns, reuses your components.

### Hackathon — 24h Sprint

Structured 8-phase workflow that wins hackathons:

```
Phase 0: Setup              30 min    (pre-hackathon)
Phase 1: Brainstorm          2.5h     ✋ You lead
Phase 2: Build Backend       5h       🤖 Auto
Phase 3: Design              1.5h     ✋ You approve
Phase 4: Build UI + AI       5.5h     🤖 Auto
Phase 5: Test + Visual QA    3h       🤖 Auto
Phase 6: Polish + Deploy     2.5h     🤖 Auto
Phase 7: Presentation        2.5h     🤖 Auto
Phase 8: Rehearsal           1.5h     ✋ You practice
```

---

## Architecture

Built on [Anthropic's Harness Design research](https://www.anthropic.com/engineering/harness-design-long-running-apps) — the same Planner/Generator/Evaluator architecture that produced full-stack apps in multi-hour autonomous sessions.

```
┌─────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│    PLANNER      │───>│    GENERATOR     │───>│    EVALUATOR     │
│  opus/ultrathink│    │    opus/high     │    │  opus/ultrathink │
│                 │    │                  │    │                  │
│ ● Brand wizard  │    │ ● TDD inside    │    │ ● Static analysis│
│ ● Research      │    │ ● 45-min rule   │    │ ● Playwright QA  │
│ ● Capabilities  │    │ ● Commit each   │    │ ● VISUAL AUDIT   │
│ ● Sprint        │    │ ● Never break   │    │ ● 4 criteria     │
│   contracts     │    │   the build     │    │ ● Skeptical      │
└─────────────────┘    └────────┬─────────┘    └────────┬─────────┘
                                │                       │
                                │   FAIL → fix → retry  │
                                └───────────────────────┘
                                     PASS ✓
                                       │
                              ┌────────▼────────┐
                              │    PRESENTER    │
                              │     sonnet     │
                              │                │
                              │ ● Remotion     │
                              │ ● PPTX export  │
                              │ ● Demo video   │
                              │ ● LinkedIn imgs│
                              └─────────────────┘
```

### The GAN-Inspired Feedback Loop

From Anthropic's research:

> *"Separating the agent doing the work from the agent judging it proves to be a strong lever. Tuning a standalone evaluator to be skeptical turns out to be far more tractable than making a generator critical of its own work."*

The Evaluator is **skeptical by default**. It doesn't approve mediocre work. It navigates the live app with Playwright, screenshots every page, and grades on 4 criteria with hard fail conditions.

---

## 10 Skills

| Skill | What it does |
|-------|-------------|
| **plan** | Expands a 1-sentence prompt into a full product spec with brand identity, sprint contracts, and testable acceptance criteria |
| **build** | Builds features one at a time with TDD inside (RED→GREEN→REFACTOR). 45-minute rule: stuck? simplify and move on |
| **eval** | Four-phase QA: static analysis → Playwright runtime testing → **visual audit** (multimodal) → grading with hard fail conditions |
| **design** | Smart UI workflow — auto-detects Stitch MCP and [Stitch Skills](https://github.com/google-labs-code/stitch-skills). In collab: asks preference + detailed UI questions. In auto: detects best tool. Always: backend first, design after, frontend last |
| **present** | Remotion-first visual engine — LinkedIn images, carousels, demo videos, pitch decks. Exports to PNG, MP4, PPTX |
| **research** | 9-phase competitive intelligence framework using imperium-crawl (YouTube transcripts, Reddit mining, batch scraping) |
| **brand** | Multi-brand registry with 12 archetypes, 10-color palette, typography, tone-of-voice. Hybrid storage: project-level + central registry |
| **content** | LinkedIn viral posts (12 types, 50+ hooks), carousels (6 types), video content. All visuals generated via Remotion |
| **outreach** | Cold email sequences (137 sales triggers, 34 templates), lead scraping via imperium-crawl, BANT qualification |
| **validate** | Startup idea validation: problem-solution fit, TAM/SAM/SOM market sizing, Mom Test questions, MVP scoping |

---

## Visual Validation

What makes Hyper-Pipeline unique — the Evaluator uses Claude's **multimodal vision** to review EVERY visual output:

| What gets checked | What it looks for |
|-------------------|-------------------|
| App UI screenshots | Alignment, spacing, typography hierarchy, responsive layout |
| LinkedIn post images | Text readability at 1200x1200, brand color consistency |
| Carousel slides | Consistent styling across slides, progressive numbering |
| Presentation slides | Readability from back of room, visual hierarchy |
| Landing page | Professional polish, CTA visibility, mobile responsive |
| All visuals | **"AI slop" detection** — purple gradients, generic layouts, stock vibes |

Every visual that doesn't pass gets flagged with a specific fix suggestion.

---

## Brand System

Multi-brand registry — because you work on multiple projects:

```
Brand resolution:
1. .hyper/brand.md       ← project-level (auto-detected)
2. ~/.hyper/brands/*.md   ← central registry
3. Brand wizard           ← creates new on the fly
```

The brand wizard walks you through:
- **12 archetypes** (Innovator, Sage, Hero, Creator, Explorer, Ruler, Caregiver, Rebel, Magician, Lover, Jester, Everyman)
- **10-color palette** with WCAG contrast compliance
- **Typography** (heading, body, accent fonts from Google Fonts)
- **Voice character** on 4 spectrums (Formal↔Casual, Technical↔Simple, Serious↔Playful, Reserved↔Bold)
- **Platform-specific tone** (website, LinkedIn, email, product UI)
- **Logo generation** via [chatgpt-py](https://github.com/ceoimperiumprojects/chatgpt-py)

Every skill reads the brand — content, outreach, design, presenter all stay on-brand automatically.

---

## Commands

| Command | What happens |
|---------|-------------|
| `/hp-auto` | Full autonomous — give spec, get everything built |
| `/hp-go` | Collaborative — you decide at 3 key points, rest is auto |
| `/hp-hackathon` | 24h hackathon sprint — 8 timed phases |
| `/hp-plan` | Generate product spec + sprint contracts + brand |
| `/hp-build` | Build features one by one from sprint contract |
| `/hp-eval` | QA: static + Playwright + visual + backend quality audit |
| `/hp-design` | UI design via Stitch MCP or manual spec |
| `/hp-present` | Generate visuals: slides, demo video, LinkedIn images, PPTX |
| `/hp-deploy` | Deploy to Vercel/Railway/Docker — build, test, deploy, verify |
| `/hp-fix` | Debug + fix bugs with failing test → fix → verify flow |
| `/hp-refactor` | Safe refactoring with test safety net |
| `/hp-test` | Add test coverage to untested code |
| `/hp-ci` | Generate GitHub Actions CI/CD pipeline |

---

## Quick Start

### Option 1: Clone and install

```bash
git clone https://github.com/ceoimperiumprojects/hyper-pipeline.git

# Copy to Claude Code
cp -r hyper-pipeline/agents/*.md ~/.claude/agents/
cp -r hyper-pipeline/commands/*.md ~/.claude/commands/
cp -r hyper-pipeline/skills/* ~/.claude/skills/
cp hyper-pipeline/hooks/hooks.json ~/.claude/settings.local.json  # merge hooks
```

### Option 2: Drop into project

Copy the `hyper-pipeline/` folder into your project root. Claude Code will auto-detect the skill.

### Verify

```
You: /hp-plan "build a todo app with AI prioritization"
```

If it generates `docs/PLAN.md` with brand section and sprint contracts — you're good.

---

## Full Auto Example

```
You: /hp-auto "Build a SaaS platform for monitoring competitor prices.
      AI tracks prices, sends alerts, generates weekly reports.
      Target: e-commerce managers in the region.
      Need: landing page, 3 LinkedIn posts, lead list."

Phase 0 — Auto-Infer (zero questions):
  🤖 Brand: auto-generated "PriceHawk" — Innovator archetype, teal + orange
  🤖 Scope: inferred from spec — leads YES, content YES, landing YES
  🤖 Design: Stitch MCP detected → auto-use

Phase 1+ — Pure execution (zero interrupts):
  🤖 Research: 12 competitors found, gap identified
  🤖 PLAN.md: 6 features, 4 sprints, 14 API endpoints
  🤖 Sprint 1: Backend — 6 commits, API working
  🤖 Sprint 2: Frontend + AI — dashboard, alerts, streaming AI
  🤖 Eval: Functionality 9/10, Code 8/10, Visual 8/10, Innovation 9/10
  🤖 Sprint 3: GTM — 127 qualified leads, 3 email sequences
  🤖 Sprint 4: Content — 3 LinkedIn posts + Remotion images
  🤖 Landing page deployed
  🤖 12-slide pitch deck (PPTX + 90s demo video)

AUTO-SUMMARY.md:
  ✅ App: deployed at pricehawk.vercel.app
  ✅ Brand: PriceHawk identity complete
  ✅ Leads: 127 qualified (BANT scored)
  ✅ Emails: 3-sequence outreach ready
  ✅ Content: 3 LinkedIn posts + branded images
  ✅ Pitch: PPTX deck + MP4 demo
  ✅ Eval: 34/40
```

---

## Existing Project Support

Hyper-Pipeline isn't just for greenfield — it's designed for **existing codebases**:

```
/hp-go "add lead scoring to SimpleSurplus"

🤖 Codebase Scan:
   "SimpleSurplus: FastAPI + React + SQLite
    15 API endpoints, 8 components, JWT auth
    Reusable: Lead model, auth middleware, test fixtures"

🤖 Plan (respects existing patterns):
   POST /api/v1/leads/score  ← follows existing /api/v1/ convention
   ScoreDisplay component    ← follows existing component structure
   pytest test_scoring.py    ← follows existing test patterns

✋ You review: "Looks good, also add batch scoring"

🤖 Builds → Tests → Eval → Done ✓
```

---

## Tools Ecosystem

Hyper-Pipeline orchestrates these tools (all optional — install what you need):

| Tool | What it unlocks | Install |
|------|----------------|---------|
| [**imperium-crawl**](https://github.com/ceoimperiumprojects/imperium-crawl) | 33-tool web arsenal: scraping, search (Brave API), YouTube transcripts, Reddit mining, Instagram discovery, AI extraction, batch scraping, API discovery, media download | `npm i -g imperium-crawl` |
| [**chatgpt-py**](https://github.com/ceoimperiumprojects/chatgpt-py) | AI image generation via ChatGPT/DALL-E: logos, illustrations, mockups, hero images, social media visuals — with transparent background support | `git clone && pip install -e .` |
| [**Remotion**](https://github.com/remotion-dev/remotion) | Programmatic visual rendering: branded LinkedIn images, carousel slides, demo videos, animated presentations — all from code | `npx create-video@latest` |
| [**Playwright**](https://github.com/microsoft/playwright) | Browser automation for the Evaluator: navigates your app, clicks everything, screenshots every page, tests edge cases | `npx playwright install` |
| [**Stitch MCP**](https://github.com/davideast/stitch-mcp) | Google's AI UI design tool via MCP: generate screens from text, extract design systems, scaffold React components | `npx @_davideast/stitch-mcp init` |
| [**Stitch Skills**](https://github.com/google-labs-code/stitch-skills) | Design + React component generation skills for Stitch: `stitch-design` for UI generation, `react:components` for Tailwind component scaffolding | `npx skills add google-labs-code/stitch-skills --global` |
| **ffmpeg** | Audio/video processing: extract audio, convert formats, generate thumbnails, add captions | `apt install ffmpeg` |
| [**Vercel CLI**](https://vercel.com/docs/cli) | Deploy Next.js apps to production with one command. Build → test → deploy → verify live | `npm i -g vercel` |
| [**Supabase CLI**](https://supabase.com/docs/guides/cli) | Database, auth, storage, edge functions. Schema migrations, type generation, local dev | `npx supabase` |
| [**Claude Peers MCP**](https://github.com/louislva/claude-peers-mcp) | Physical generator↔evaluator separation. Two terminals, instant messaging, true Anthropic harness | `git clone + bun install` |
| [**OpenSpace**](https://github.com/HKUDS/OpenSpace) | Self-improving skills: autofix, autoimprove, autolearn. 46% fewer tokens over time | `pip install -e .` |
| **Obsidian** | Project management vault — notes, tasks, daily logs, weekly reviews. Pipeline reads/writes to vault | Obsidian app + vault at `~/Obsidian/Imperium/` |

### Visual Generation Decision Tree

```
Need a logo or custom illustration?
  → chatgpt-py (DALL-E, transparent PNG support)

Need branded templates (posts, slides, cards)?
  → Remotion (reads brand.md, batch renders)

Need stock photos or existing images?
  → imperium-crawl image-search + download

Need to process/convert media?
  → ffmpeg
```

---

## Based On

| Source | What we took |
|--------|-------------|
| [**Anthropic Harness Design**](https://www.anthropic.com/engineering/harness-design-long-running-apps) | Planner/Generator/Evaluator three-agent architecture, GAN-inspired feedback loop, sprint contracts, 4 grading criteria, skeptical evaluator, visual validation |
| [**Everything Claude Code**](https://github.com/affaan-m/everything-claude-code) | Agent YAML format, hook system, skill structure, TDD workflow, verification loop, code reviewer patterns (50K+ stars) |
| [**Google Stitch 2.0**](https://stitch.withgoogle.com/) | AI-native UI design with MCP integration, DESIGN.md format, React component scaffolding |
| [**Stitch Skills**](https://github.com/google-labs-code/stitch-skills) | `stitch-design` + `react:components` — design generation and React/Tailwind scaffolding from Stitch designs |

---

## Repo Structure

```
hyper-pipeline/
├── SKILL.md                    # Master routing — 3 modes, keyword triggers
├── CAPABILITIES.md             # All available tools (pipeline reads this)
├── README.md                   # You are here
│
├── agents/
│   ├── planner.md              # opus/ultrathink — spec + brand + research
│   ├── generator.md            # opus/high — feature-by-feature + TDD
│   ├── evaluator.md            # opus/ultrathink — QA + visual audit
│   └── presenter.md            # sonnet — Remotion + PPTX + demo
│
├── skills/                     # 10 modular sub-skills
│   ├── plan/    build/    eval/    design/    present/
│   ├── research/    brand/    content/    outreach/    validate/
│
├── commands/                   # 7 slash commands
│   ├── hp-auto.md    hp-go.md    hp-plan.md    hp-build.md
│   ├── hp-eval.md    hp-design.md    hp-present.md
│
├── templates/                  # 6 document templates
│   ├── PLAN.md    BRAND.md    SPRINT-CONTRACT.md
│   ├── EVAL-REPORT.md    DEMO-SCRIPT.md    HACKATHON-CLAUDE.md
│
├── rules/                      # Pipeline rules
│   ├── core.md                 # 22 universal rules
│   └── hackathon.md            # 23 hackathon-specific rules
│
├── examples/                   # 3 workflow examples
│   ├── daily-dev.md            # Existing project feature
│   ├── hackathon.md            # 24h sprint
│   └── full-auto-startup.md    # Idea → everything
│
├── hooks/hooks.json            # Quality gates
└── evals/                      # Test cases + trigger evals
```

---

## Benchmark

### Iteration 1: Planning Phase (Dry Run)

| Eval | Mode | Assertions | Result |
|------|------|------------|--------|
| Full Auto (SaaS platform) | `/hp-auto` | 6/6 | **PASS** |
| Collab (existing project) | `/hp-go` | 5/5 | **PASS** |
| Hackathon Prep | hackathon | 5/5 | **PASS** |
| **Total** | | **16/16** | **100%** |

### Iteration 2: E2E Artifact Generation + Flow Validation

| Test | What | Result |
|------|------|--------|
| Trigger Routing | 20 prompts (10 true pos, 10 true neg) | **20/20 PASS** |
| Brand Wizard | 10 colors, 7 sections, WCAG AA | **PASS** |
| Planning | 46 testable behaviors, 22 hard fails | **PASS** |
| Stitch 2.0 Fallback | 8 sections, ASCII wireframes | **PASS** |
| Eval Report | Skeptical evaluator, file:line refs | **PASS** |
| Content Creation | 3 posts, 3 types, algorithm-optimized | **PASS** |
| Outreach | 3-email sequence, BANT scoring | **PASS** |
| Validation | TAM/SAM/SOM, Mom Test, CONDITIONAL GO | **PASS** |
| Presentation | 14-slide HTML, keyboard nav, zero-dep | **PASS** |
| Error Handling | 3 HIGH gaps found and **FIXED** | **PASS** |
| /hp-auto Flow Trace | All phase transitions verified | **PASS** |
| /hp-go Flow Trace | 3 decision points, git safety | **PASS** |
| Hackathon Flow Trace | 8 phases, timing validated | **PASS** |
| **Overall** | **16 artifacts generated, 40+ checks** | **A+ (97%)** |

16 fixes applied across 11 skill files after flow testing.

---

## Contributing

PRs welcome. The skill follows standard Claude Code patterns:
- Agents: Markdown with YAML frontmatter (`name`, `description`, `tools`, `model`)
- Skills: `SKILL.md` with When to Activate, Process, Output sections
- Commands: Markdown with `description` frontmatter

---

## License

MIT — use it, fork it, ship with it.

---

<p align="center">
  <strong>Stop building in fragments. Start shipping in pipelines.</strong><br><br>
  <code>/hp-auto docs/YOUR-IDEA.md</code>
</p>
