# Hyper-Pipeline — E2E Test Plan

## Overview

Dosadašnji testovi (iteration-1) su bili **planning-phase dry runs** — nikad se nije testirao stvarni build, eval, Stitch dizajn, content generacija, ni visual validation. Ovaj test plan pokriva SVE end-to-end.

**Scope:** 10 sub-skillova, 7 komandi, 4 agenta, Stitch 2.0, Remotion, brand wizard, visual validation

---

## Pre-Test Setup Checklist

Proveriti pre pokretanja testova:

```bash
# 1. Stitch MCP
npx @_davideast/stitch-mcp --version          # Expect: 0.5.1+

# 2. Stitch Skills
npx skills list --global 2>/dev/null           # Check stitch-design, react:components

# 3. Remotion
npx remotion --version 2>/dev/null             # Any version

# 4. Playwright
npx playwright --version 2>/dev/null           # For eval/QA

# 5. chatgpt-py
chatgpt --version 2>/dev/null                  # For image gen

# 6. imperium-crawl
imperium-crawl --version 2>/dev/null           # For research/leads

# 7. python-pptx
python3 -c "import pptx; print(pptx.__version__)" 2>/dev/null  # For PPTX fallback

# 8. ffmpeg
ffmpeg -version 2>/dev/null | head -1          # For media processing
```

---

## Test Structure

Svaki test ima:
- **ID:** Jedinstveni identifikator
- **Category:** Koji deo pipeline-a se testira
- **Command:** Komanda koja se poziva
- **Input:** Šta se daje kao ulaz
- **Expected Output:** Šta treba da se dobije
- **Validation:** Kako se proverava da je prošlo
- **Pass Criteria:** Minimalni kriterijumi za PASS

---

## TEST GROUP 1: Trigger Routing (Existing — Verify)

Ovi testovi već postoje u `trigger-eval.json` — samo verifikujemo da routing radi.

### T1.1: Auto Mode Detection
- **Input:** "imam ideju za SaaS platformu, hocu sve full auto brate"
- **Expected:** Routes to `/hp-auto`
- **Validation:** Pojavljuje se routing trace, detektuje auto mode

### T1.2: Collab Mode Detection
- **Input:** "treba mi nova feature, hajde da to zajedno odradimo"
- **Expected:** Routes to `/hp-go`
- **Validation:** Pojavljuje se routing trace, detektuje collab mode

### T1.3: Hackathon Mode Detection
- **Input:** "hakaton je za 3 dana, 24 sata imam, solo"
- **Expected:** Routes to hackathon mode
- **Validation:** 8-phase timeline, HACKATHON-CLAUDE.md

### T1.4: False Positives (should NOT trigger)
- **Input:** "popravi mi bug u login komponenti"
- **Expected:** Does NOT activate hyper-pipeline
- **Validation:** No routing trace, no pipeline artifacts

---

## TEST GROUP 2: Brand Wizard (Sub-skill: brand)

### T2.1: Brand Creation from Scratch
- **Command:** Trigger brand wizard through `/hp-plan` (no existing brand)
- **Input:** "Napravi brand za PriceWatch — SaaS za monitoring cena. Target: e-commerce menadžeri, Srbija"
- **Expected Output:**
  - `.hyper/brand.md` created with all 7 sections
  - `~/.hyper/brands/pricewatch.md` saved to central registry
  - 12 archetype options presented
  - 10-color palette with hex values
  - 3 font selections
  - Voice character scores (1-10 on 4 spectra)
  - Platform tone table
- **Validation:**
  ```bash
  cat .hyper/brand.md | grep -c "^|"        # Tables present
  cat .hyper/brand.md | grep -cE "#[0-9A-Fa-f]{6}"  # Hex colors (expect 10+)
  cat ~/.hyper/brands/pricewatch.md          # Registry copy exists
  ```
- **Pass Criteria:** Brand file has ALL 7 sections populated, colors are valid hex, WCAG AA contrast verified

### T2.2: Brand Resolution Priority
- **Setup:** Create `.hyper/brand.md` in project AND `~/.hyper/brands/other.md`
- **Input:** Run `/hp-plan` for a new feature
- **Expected:** Uses project-level `.hyper/brand.md` (priority 1)
- **Validation:** Plan references project brand colors, not central registry

### T2.3: Brand Registry Listing
- **Setup:** Multiple brands in `~/.hyper/brands/`
- **Input:** "Treba mi brand za novi projekat" (no project brand)
- **Expected:** Lists available brands from registry, asks which to use
- **Validation:** User gets choice of existing brands + option for new wizard

---

## TEST GROUP 3: Planning (Sub-skill: plan, Agent: planner)

### T3.1: Plan Generation — New Project
- **Command:** `/hp-plan`
- **Input:** "SaaS za monitoring cena konkurencije. AI treba da prati cene, šalje alerte, generiše izveštaje."
- **Expected Output:**
  - `docs/PLAN.md` with all template sections filled
  - `docs/SPRINT-CONTRACT.md` with testable behaviors ("User can...")
  - Brand section in plan
  - Architecture diagram
  - Sprint breakdown with time estimates
  - Innovation argument
  - Risk list
- **Validation:**
  ```bash
  # PLAN.md sections
  grep "Core Features" docs/PLAN.md
  grep "Architecture" docs/PLAN.md
  grep "Sprint Plan" docs/PLAN.md
  grep "P0\|P1\|P2" docs/PLAN.md           # Priority tiers

  # SPRINT-CONTRACT.md
  grep "User can" docs/SPRINT-CONTRACT.md   # Testable behaviors
  grep "Hard Fail" docs/SPRINT-CONTRACT.md  # Hard fail conditions
  ```
- **Pass Criteria:**
  - PLAN.md has at least 8/10 template sections
  - SPRINT-CONTRACT.md has 10+ testable behaviors
  - Each sprint has clear deliverables
  - Hard fail conditions are specific and measurable

### T3.2: Plan Generation — Existing Project
- **Setup:** Create a minimal project with `package.json`, `src/index.ts`, `prisma/schema.prisma`
- **Command:** `/hp-plan "add notification system"`
- **Expected:**
  - Codebase scan (Glob/Grep commands to understand existing patterns)
  - `CODEBASE-CONTEXT.md` generated
  - Plan respects existing tech stack (detected from project)
  - Sprint contract references existing files/patterns
- **Validation:** Plan mentions specific existing files, no conflicting tech choices

### T3.3: Capabilities Awareness
- **Input:** Plan that requires visual generation, lead scraping, research
- **Expected:** Plan references specific tools:
  - imperium-crawl for research/leads
  - Remotion for visuals
  - chatgpt-py for image generation
  - Playwright for testing
  - Stitch for UI design
- **Validation:** `grep -cE "imperium-crawl|Remotion|chatgpt-py|Playwright|Stitch" docs/PLAN.md` > 3

### T3.4: Front-Loaded Questions (Auto Mode)
- **Input:** Full auto mode spec
- **Expected:** ALL questions asked BEFORE planning starts, ZERO interrupts after Phase 0
- **Validation:** Count question marks in Phase 0 vs Phase 1+. Phase 1+ should have 0 questions.

---

## TEST GROUP 4: Build (Sub-skill: build, Agent: generator)

### T4.1: Feature-by-Feature Build
- **Setup:** PLAN.md + SPRINT-CONTRACT.md from T3.1
- **Command:** `/hp-build`
- **Expected:**
  - Features built one at a time from sprint contract
  - TDD cycle visible: RED → GREEN → REFACTOR
  - Git commits after each feature
  - Self-evaluation checklist completed
  - No console.log left in code
  - Real data, not Lorem Ipsum
  - Error handling present
  - Loading states present
- **Validation:**
  ```bash
  git log --oneline | head -20              # Multiple focused commits
  grep -r "console.log" src/ | wc -l       # Should be 0
  grep -r "Lorem" src/ | wc -l             # Should be 0
  grep -r "TODO" src/ | wc -l              # Minimal TODOs
  ```
- **Pass Criteria:**
  - At least 3 commits (one per feature minimum)
  - Zero console.log in production code
  - Zero Lorem Ipsum
  - Tests exist and pass
  - App builds without errors

### T4.2: 45-Minute Rule
- **Input:** Large sprint contract
- **Expected:** If a single feature takes >45 minutes, generator breaks it down or moves on
- **Validation:** No single feature takes more than 45 minutes of wall clock time

### T4.3: Build Error Recovery
- **Setup:** Introduce a deliberate dependency conflict
- **Expected:** Generator detects build error, attempts fix, documents in BUILD-LOG.md
- **Validation:** `docs/BUILD-LOG.md` exists with error description and resolution

---

## TEST GROUP 5: Design — Stitch 2.0 Integration (Sub-skill: design)

### T5.1: Stitch MCP Automatic Workflow
- **Prerequisites:** Stitch MCP running (`npx @_davideast/stitch-mcp proxy`)
- **Command:** `/hp-design`
- **Setup:** Backend built (Sprint 1 complete), brand.md exists
- **Input:** "Dizajniraj UI za price monitoring dashboard"
- **Expected:**
  - Stitch MCP tools invoked (create_screen, get_screen_code, get_screen_image)
  - Design system extracted into `.stitch/DESIGN.md`
  - React component shells generated
  - Screenshots saved in `docs/design/`
  - Design matches brand colors from `.hyper/brand.md`
- **Validation:**
  ```bash
  ls .stitch/DESIGN.md                      # Design system exists
  grep -cE "#[0-9A-Fa-f]{6}" .stitch/DESIGN.md  # Color tokens
  ls docs/design/*.png 2>/dev/null          # Screenshots exist
  ls apps/web/components/ 2>/dev/null       # Component shells
  ```
- **Pass Criteria:**
  - DESIGN.md has Colors, Typography, Spacing, Components sections
  - Colors match brand.md palette
  - At least 3 screens designed
  - React components generated for each screen

### T5.2: Stitch Manual Fallback
- **Prerequisites:** Stitch MCP NOT running
- **Command:** `/hp-design`
- **Expected:**
  - `docs/DESIGN-SPEC.md` generated with full design spec
  - Color palette, typography, spacing system
  - Layout descriptions for each screen
  - Component inventory
  - Instructions to use stitch.withgoogle.com manually
- **Validation:**
  ```bash
  ls docs/DESIGN-SPEC.md
  grep "Color" docs/DESIGN-SPEC.md
  grep "Typography" docs/DESIGN-SPEC.md
  grep "Spacing" docs/DESIGN-SPEC.md
  grep "stitch.withgoogle.com" docs/DESIGN-SPEC.md
  ```
- **Pass Criteria:** DESIGN-SPEC.md has all 7 sections, actionable for manual Stitch use

### T5.3: UI Timing Enforcement
- **Setup:** No backend built yet (Sprint 1 not started)
- **Command:** `/hp-design`
- **Expected:** Refuses to design UI, explains "build backend first"
- **Validation:** Output contains timing warning, no design artifacts created

### T5.4: Stitch-to-React Component Pipeline
- **Setup:** Stitch MCP available, screen already designed
- **Input:** "Generiši React komponente iz Stitch dizajna"
- **Expected:**
  - `react:components` Stitch skill invoked
  - Components in `apps/web/components/` with proper TypeScript types
  - Components use design tokens from DESIGN.md
  - Components are responsive (mobile-first)
- **Validation:** Components compile, use brand colors, have TypeScript types

---

## TEST GROUP 6: Evaluation (Sub-skill: eval, Agent: evaluator)

### T6.1: Full Evaluation Cycle
- **Prerequisites:** App built and running, SPRINT-CONTRACT.md exists
- **Command:** `/hp-eval`
- **Expected:**
  - Phase A: Static analysis (linting, type checking)
  - Phase B: Playwright runtime QA
  - Phase C: Visual audit (multimodal) with scores
  - Phase D: Overall grade
  - `docs/EVAL-REPORT.md` generated
- **Validation:**
  ```bash
  grep "Functionality" docs/EVAL-REPORT.md
  grep "Code Quality" docs/EVAL-REPORT.md
  grep "Visual Quality" docs/EVAL-REPORT.md
  grep "Innovation" docs/EVAL-REPORT.md
  grep "/10" docs/EVAL-REPORT.md            # Scores present
  ```
- **Pass Criteria:** All 4 criteria scored, hard fail check documented, bugs listed with severity

### T6.2: Visual Validation (Multimodal)
- **Setup:** App running with UI
- **Expected:**
  - Screenshots taken via Playwright
  - Claude multimodal analyzes screenshots for:
    - Alignment/grid issues
    - Typography consistency
    - Color harmony with brand
    - Spacing regularity
    - "AI slop" detection (generic patterns)
    - Professional polish
  - Results in EVAL-REPORT Phase C
- **Validation:** EVAL-REPORT.md Phase C has specific visual observations (not generic)

### T6.3: Hard Fail Detection
- **Setup:** Introduce a hard fail (e.g., app crashes on load)
- **Expected:**
  - Evaluator returns FAIL
  - Hard fail condition identified
  - Feedback sent back to generator
  - Fix → re-eval loop (max 3 iterations)
- **Validation:** EVAL-REPORT shows FAIL, fix attempt documented, re-eval score improves

### T6.4: Sprint Contract Verification
- **Setup:** Sprint contract with 10 testable behaviors
- **Expected:** Each "User can..." behavior verified individually
- **Validation:** EVAL-REPORT lists each behavior with PASS/FAIL status

### T6.5: Feedback Loop (Max 3 Iterations)
- **Setup:** Failing eval
- **Expected:**
  - Eval 1: FAIL → feedback to generator
  - Generator fixes → Eval 2: may FAIL or PASS
  - If FAIL → Eval 3 (max)
  - After 3 FAILs → stops, reports remaining issues
- **Validation:** Max 3 EVAL-REPORT.md versions, loop terminates

---

## TEST GROUP 7: Content Creation (Sub-skill: content)

### T7.1: LinkedIn Post Generation
- **Setup:** `.hyper/brand.md` exists
- **Input:** "Napravi 3 LinkedIn posta za launch PriceWatch platforme"
- **Expected:**
  - 3 posts with different types (e.g., Announcement, Tutorial, Hot Take)
  - Each post: hook + body + CTA
  - 1200-1500 characters each
  - No external links in post body
  - Brand voice applied
- **Validation:**
  ```bash
  ls content/posts/post-*-copy.md | wc -l   # 3 posts
  wc -c content/posts/post-1-copy.md        # 1200-1500 chars
  ```
- **Pass Criteria:** 3 distinct post types, all follow LinkedIn algorithm rules

### T7.2: LinkedIn Post Image via Remotion
- **Setup:** Remotion project initialized, brand.md exists
- **Input:** "Napravi slike za LinkedIn postove"
- **Expected:**
  - Remotion composition created for each post
  - Preview launched first (ALWAYS preview before render)
  - PNG rendered at 1080x1080 with 2x scale
  - Brand colors applied
- **Validation:**
  ```bash
  ls content/posts/post-*-image.png | wc -l  # Images exist
  identify content/posts/post-1-image.png     # Check dimensions (2160x2160 at 2x)
  ```
- **Pass Criteria:** Images exist, dimensions correct, brand colors visible

### T7.3: LinkedIn Post Image via chatgpt-py (Fallback)
- **Setup:** No Remotion, chatgpt-py available
- **Expected:** `chatgpt image "..."` command used to generate image
- **Validation:** Image file exists, reasonable quality

### T7.4: Carousel Generation
- **Input:** "Napravi educational carousel o price monitoring za LinkedIn"
- **Expected:**
  - 7-10 slides
  - Cover slide + content slides + summary + CTA
  - Each slide as PNG 1080x1350
  - Progressive numbering
  - PDF generated for LinkedIn upload
- **Validation:**
  ```bash
  ls content/carousels/carousel-1/slide-*.png | wc -l  # 7-10 slides
  ls content/carousels/carousel-1/carousel.pdf          # PDF exists
  ```

### T7.5: Content Plan
- **Expected:** `content/content-plan.md` with publishing schedule
- **Validation:** File exists with dates and post types

---

## TEST GROUP 8: Research (Sub-skill: research)

### T8.1: Competitive Intelligence (9-Phase)
- **Input:** "Istraži tržište za price monitoring SaaS u regionu"
- **Expected:**
  - 9-phase research framework executed
  - WebSearch for quick lookups
  - imperium-crawl for deep research (if available)
  - 10 deliverable documents generated
- **Validation:**
  ```bash
  ls research/ | wc -l                       # Multiple research documents
  ```
- **Pass Criteria:** At least 5/10 deliverables produced, competitor list with features

### T8.2: Tool Selection (2-Tier)
- **With imperium-crawl:** Deep scraping, bulk data
- **Without imperium-crawl:** Falls back to WebSearch gracefully
- **Validation:** Research still works without imperium-crawl, just less depth

---

## TEST GROUP 9: Outreach (Sub-skill: outreach)

### T9.1: Lead Generation
- **Input:** "Nađi 50 e-commerce menadžera u Srbiji za outreach"
- **Expected:**
  - imperium-crawl used for lead scraping
  - BANT qualification applied
  - Leads saved to structured format
- **Validation:** Lead list with name, company, email, BANT score

### T9.2: Cold Email Sequence
- **Input:** "Napravi 3-email sekvencu za PriceWatch outreach"
- **Expected:**
  - 3 emails: intro, value, close
  - Personalization variables
  - Subject lines (A/B variants)
  - Brand voice applied
- **Validation:** 3 emails, each with subject + body + personalization slots

---

## TEST GROUP 10: Validate (Sub-skill: validate)

### T10.1: Idea Validation Framework
- **Input:** "Validiraj ideju za PriceWatch — SaaS za monitoring cena konkurencije"
- **Expected:**
  - Problem definition
  - Market sizing (TAM/SAM/SOM)
  - Competitive landscape
  - Mom Test interview questions (10+)
  - MVP scope
  - Go/No-Go decision matrix
- **Validation:** All 6 sections present, numbers are realistic, Mom Test questions are open-ended

---

## TEST GROUP 11: Present (Sub-skill: present, Agent: presenter)

### T11.1: HTML Slide Generation
- **Command:** `/hp-present`
- **Input:** "Napravi prezentaciju za PriceWatch pitch"
- **Expected:**
  - 12-15 slides
  - Speaker notes per slide
  - HTML single file (zero dependencies)
  - Brand colors applied
  - Keyboard navigation works
- **Validation:**
  ```bash
  ls docs/presentation.html
  open docs/presentation.html              # Works in browser
  ```

### T11.2: Remotion Demo Video
- **Setup:** Remotion available, app screenshots taken
- **Expected:**
  - Demo video script (60-90s)
  - Remotion composition created
  - Preview before render
  - MP4 output
- **Validation:** `ls content/videos/demo.mp4`

### T11.3: PPTX Export
- **Expected:** Slides exported to PPTX via python-pptx
- **Validation:** `ls *.pptx` opens in PowerPoint/LibreOffice

---

## TEST GROUP 12: Full Pipeline E2E (/hp-auto)

### T12.1: Full Auto — Greenfield Project
**THE BIG TEST.** This tests the entire pipeline end-to-end.

- **Command:** `/hp-auto`
- **Input Spec:**
  ```
  Napravi PriceWatch — SaaS za monitoring cena konkurencije.

  Funkcionalnosti:
  - Dashboard sa listom praćenih proizvoda
  - AI prati cene na sajtovima konkurenata (web scraping)
  - Alerting kad se cena promeni za >5%
  - Nedeljni izveštaj sa trendovima

  Tech stack: Next.js + Prisma + PostgreSQL

  Treba mi i:
  - Landing page
  - 3 LinkedIn posta za launch
  - Brand identity
  - Pitch deck prezentacija
  ```

- **Expected Flow:**
  ```
  Phase 0: GATHERING
    ✅ Brand wizard runs (or brand selected from registry)
    ✅ Scope questions asked (leads? content? outreach?)
    ✅ Research auto-triggered
    ✅ PLAN.md generated with ALL answers baked in
    ✅ SPRINT-CONTRACT.md with testable behaviors
    ✅ ZERO questions after Phase 0

  Phase 1: BUILD BACKEND
    ✅ Prisma schema created
    ✅ API routes implemented
    ✅ Database seeded with real data
    ✅ Tests written and passing
    ✅ Git commits after each feature

  Phase 2: DESIGN
    ✅ Stitch MCP invoked (or manual spec)
    ✅ DESIGN.md created
    ✅ React component shells generated
    ✅ Brand colors applied

  Phase 3: BUILD FRONTEND + AI
    ✅ Dashboard UI built
    ✅ Price scraping AI implemented
    ✅ Alerting system working
    ✅ Report generation functional

  Phase 4: EVALUATE
    ✅ Static analysis
    ✅ Playwright tests
    ✅ Visual validation (multimodal)
    ✅ EVAL-REPORT.md generated
    ✅ If FAIL → fix → re-eval (max 3x)

  Phase 5: GTM (if scoped)
    ✅ Lead generation
    ✅ LinkedIn posts with images
    ✅ Landing page
    ✅ Cold email sequences

  Phase 6: PRESENT
    ✅ Pitch deck (HTML slides)
    ✅ Demo script
    ✅ Optional demo video

  Phase 7: DONE
    ✅ AUTO-SUMMARY.md generated
    ✅ All artifacts listed
    ✅ Next steps documented
  ```

- **Artifacts Checklist:**
  ```
  docs/PLAN.md                    □
  docs/SPRINT-CONTRACT.md         □
  docs/EVAL-REPORT.md             □
  docs/BUILD-LOG.md               □
  docs/AUTO-SUMMARY.md            □
  .hyper/brand.md                 □
  .stitch/DESIGN.md               □
  content/posts/post-*-copy.md    □ (3+)
  content/posts/post-*-image.png  □ (3+)
  docs/presentation.html          □
  Working app (npm run dev)       □
  Tests passing                   □
  Git history (10+ commits)       □
  ```

- **Pass Criteria:**
  - ALL Phase 0 questions front-loaded
  - Zero interrupts after Phase 0
  - App builds and runs
  - Tests exist and pass
  - Brand consistently applied across all outputs
  - Visual validation completed
  - At least 10/14 artifacts produced

---

## TEST GROUP 13: Collaborative Mode E2E (/hp-go)

### T13.1: Collab — Existing Project Feature
- **Setup:** Existing Next.js project with some features
- **Command:** `/hp-go "add user notification system"`
- **Expected:**
  - Codebase scan (detects existing patterns)
  - CODEBASE-CONTEXT.md generated
  - Plan presented for user review (Decision Point 1)
  - After approval: feature built with TDD
  - Design review (Decision Point 2)
  - Eval results presented (Decision Point 3)
- **Validation:**
  - Exactly 3 decision points where user is asked
  - Existing code not broken
  - New feature integrates with existing patterns
  - All tests pass (old + new)

---

## TEST GROUP 14: Hackathon Mode E2E

### T14.1: Hackathon Prep + Phase 0-1
- **Input:** "Hakaton za 2 dana, tema AI x Sustainability, 24h, solo"
- **Expected:**
  - 8-phase timeline generated
  - HACKATHON-CLAUDE.md template populated
  - Phase 0 checklist (tools verified)
  - Phase 1 brainstorm framework
  - MCP/tool verification commands listed
- **Validation:** HACKATHON-CLAUDE.md has all 8 phases, tool check passes

---

## TEST GROUP 15: Hooks

### T15.1: Quality Gate Hook (PreToolUse)
- **Setup:** File with >800 lines, code with console.log
- **Expected:** Warning triggered before tool executes
- **Validation:** Warning message appears

### T15.2: Post-Commit Hook
- **Setup:** Commit during build phase
- **Expected:** Reminder to check sprint contract
- **Validation:** Sprint contract reference in hook output

### T15.3: Session Log on Stop
- **Expected:** `docs/SESSION-LOG.md` saved with session marker
- **Validation:** File exists after session ends

---

## TEST GROUP 16: Error Handling & Edge Cases

### T16.1: Missing Prerequisites
- **Input:** `/hp-build` without PLAN.md
- **Expected:** Clear error: "Run /hp-plan first"
- **Validation:** No crash, helpful error message

### T16.2: Missing Brand
- **Input:** `/hp-auto` without brand and no internet
- **Expected:** Brand wizard runs, falls back to default palette
- **Validation:** Pipeline doesn't stall

### T16.3: Stitch MCP Down
- **Input:** `/hp-design` with Stitch MCP not running
- **Expected:** Falls back to manual design spec (Option B)
- **Validation:** DESIGN-SPEC.md generated instead of Stitch artifacts

### T16.4: Remotion Not Installed
- **Input:** Content generation requiring images
- **Expected:** Falls back to chatgpt-py or python-pptx
- **Validation:** Images/slides still generated via fallback

### T16.5: imperium-crawl Not Installed
- **Input:** Research requiring deep scraping
- **Expected:** Falls back to WebSearch
- **Validation:** Research still produces results, just less depth

---

## Execution Order

Recommended execution order (dependencies considered):

```
1. T1.1-T1.4  — Trigger routing (sanity check)
2. T2.1-T2.3  — Brand wizard (needed for everything else)
3. T3.1-T3.4  — Planning (needed for build/eval)
4. T5.1-T5.4  — Stitch 2.0 design (key deliverable)
5. T4.1-T4.3  — Build (needs plan)
6. T6.1-T6.5  — Evaluation (needs built app)
7. T7.1-T7.5  — Content creation
8. T8.1-T8.2  — Research
9. T9.1-T9.2  — Outreach
10. T10.1     — Validation
11. T11.1-T11.3 — Presentation
12. T12.1     — FULL AUTO E2E (the big test)
13. T13.1     — Collab E2E
14. T14.1     — Hackathon E2E
15. T15.1-T15.3 — Hooks
16. T16.1-T16.5 — Error handling
```

## Scoring

| Grade | Pass Rate | Meaning |
|-------|-----------|---------|
| A+ | 95-100% | Production ready |
| A  | 85-94%  | Minor polish needed |
| B  | 70-84%  | Significant issues |
| C  | 50-69%  | Major rework needed |
| F  | <50%    | Not functional |

**Target: A (85%+) for hackathon submission.**

---

## Test Workspace

All test execution outputs go to:
```
hyper-pipeline-workspace/
├── iteration-2/           # This E2E test round
│   ├── setup-check/       # Pre-test tool verification
│   ├── test-project/      # The actual test project (PriceWatch)
│   ├── results/           # Per-test results
│   │   ├── T1.1-routing.md
│   │   ├── T2.1-brand.md
│   │   ├── ...
│   │   └── T12.1-full-auto.md
│   └── benchmark-e2e.md   # Final benchmark summary
```
