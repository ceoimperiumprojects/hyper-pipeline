# Hackathon Workflow — Example

## Scenario: Adria Future Hackathon 2026

**Context:** 24-hour hackathon in Tivat, Montenegro. Theme: AI x Sustainability. Solo.
**Task given:** "Build an AI platform for monitoring Adriatic Sea pollution"

---

## Phase 0: Setup (30 min, pre-hackathon)

```bash
# Create repo
mkdir adriatic-monitor && cd adriatic-monitor && git init

# Copy Everything Imperium CLAUDE.md
cp everything-imperium/templates/HACKATHON-CLAUDE.md .claude/CLAUDE.md

# Verify MCP servers
# stitch, playwright, context7 — all green

# Install Stitch skills
npx skills add google-labs-code/stitch-skills --skill stitch-design --global
npx skills add google-labs-code/stitch-skills --skill react:components --global

# Initialize Remotion
cd presentation/ && npx create-video@latest --template=blank

# Install Playwright
npx playwright install chromium
```

## Phase 1: Brainstorm & Plan [T+0 → T+2:30]

### T+0:00 — Problem Analysis (45 min)
User analyzes the task. Claude researches with imperium-crawl:
- Existing Adriatic pollution monitoring solutions → gaps found
- Available datasets: EU Copernicus satellite data, UNEP Mediterranean data
- Montenegro-specific: Boka Bay water quality reports, Port of Bar shipping data
- Tech gaps: No real-time citizen reporting + AI prediction combo

### T+0:45 — Innovation Scoring (30 min)
User scores three approaches:

| Approach | Innovation | Demo | Feasibility | Total |
|----------|-----------|------|-------------|-------|
| Real-time map + citizen reports + AI prediction | 9 | 9 | 7 | 25 |
| Satellite image analysis dashboard | 7 | 8 | 5 | 20 |
| Supply chain emission tracker | 6 | 6 | 8 | 20 |

**Winner:** Real-time map + citizen reports + AI pollution prediction

### T+1:15 — /hp-plan (45 min)
Planner generates PLAN.md with 8 features across 2 sprints:
- Sprint 1: Backend — API, data model, satellite data ingestion, citizen report endpoint
- Sprint 2: Frontend + AI — Interactive map, AI prediction engine, report form, dashboard

Innovation argument: "Combines citizen science with satellite data through an AI prediction model — no existing solution does this for the Adriatic."

### T+2:00 — Sprint Contract (30 min)
Defines testable behaviors for Sprint 1.

## Phase 2: Build Sprint 1 — Backend [T+2:30 → T+7:30]

```
/hp-build sprint 1
```

Generator builds:
1. `feat: add water quality data model` → 15 min
2. `feat: add citizen report API endpoint` → 20 min
3. `feat: add satellite data ingestion service` → 30 min
4. `feat: add pollution level calculation` → 25 min
5. `feat: add historical data API` → 20 min
6. `feat: seed demo data for Boka Bay` → 15 min

Mid-sprint QA at T+5:00: API working, data flowing.

**Result:** Working backend with 6 API endpoints, seeded with real Adriatic locations.

## Phase 3: Design [T+7:30 → T+9:00]

```
/hp-design
```

User chooses: **Option B (manual)** — wants to see designs first.

Claude generates `docs/DESIGN-SPEC.md`:
- Colors: Ocean blues (#0A4D8C, #1A8FDB), sandy beige (#F5E6CC), coral alert (#FF6B6B)
- Typography: Inter for UI, serif for headings
- Layout: Full-width map as hero, side panel for data

User opens Stitch, designs 4 screens:
1. Interactive map with pollution markers
2. Citizen report form (photo + location + description)
3. AI prediction dashboard
4. About page

Exports HTML/CSS, brings back to project. Claude extracts `.stitch/DESIGN.md`.

## Phase 4: Build Sprint 2 — Frontend + AI [T+9:00 → T+14:30]

```
/hp-build sprint 2
```

Generator builds (ultrathink for AI features):
1. `feat: add interactive map with Leaflet` → 30 min
2. `feat: add pollution markers from API data` → 25 min
3. `feat: add citizen report form with photo upload` → 30 min
4. `feat: add Claude AI prediction engine with tools` → 45 min (ultrathink)
5. `feat: add AI dashboard with streaming predictions` → 35 min
6. `feat: add real-time data refresh` → 20 min

AI agent has tools: `analyze_water_sample`, `predict_pollution_spread`, `correlate_shipping_data`, `generate_alert`

## Phase 5: Test & Refine [T+14:30 → T+17:30]

```
/hp-eval
```

Evaluator navigates with Playwright:
- Opens map → markers appear ✓
- Submits citizen report → appears on map ✓
- Asks AI: "What's the pollution prediction for Boka Bay?" → streaming response ✓
- Tests mobile → map works but sidebar overlaps → FAIL
- Tests invalid photo upload → 500 error → FAIL

**EVAL-REPORT: FAIL — 32/40**
- Functionality: 8/10
- Code Quality: 9/10
- UX/Design: 7/10 (mobile sidebar issue)
- Innovation: 8/10

Generator fixes:
1. Mobile sidebar → responsive drawer
2. Photo upload validation → proper error message

Second /hp-eval → **PASS — 36/40** ✓

## Phase 6: Polish & Deploy [T+17:30 → T+20:00]

- Framer Motion animations on map markers
- Loading skeleton for AI predictions
- Demo data: 50 pollution points across Adriatic Montenegro coast
- Deploy to Vercel
- Test on phone → works ✓

## Phase 7: Presentation [T+20:00 → T+22:30]

```
/hp-present
```

Presenter generates:
- `presentation.html` — 13 slides with ocean theme matching app
- `docs/DEMO-SCRIPT.md` — 2-minute script showing:
  1. Map overview → "This is AdriaWatch"
  2. Zoom to Boka Bay → see citizen reports
  3. AI prediction → streaming analysis of pollution spread
  4. "For Montenegro, this means early warning for 300km of coastline"
- Remotion backup video

## Phase 8: Buffer & Rehearsal [T+22:30 → T+24:00]

- Rehearse 3 times with timer
- Fix: AI was slow on one prompt → pre-cache that specific response
- Print demo script
- `git tag v1.0-hackathon`
- Rest 30 min before presenting

---

## Result

**App:** AdriaWatch — Real-time Adriatic pollution monitoring with AI prediction
**Innovation:** Citizen science + satellite data + AI prediction = novel combination
**Demo:** Smooth 2-minute walkthrough, live AI interaction, compelling data viz
**Backup:** Pre-recorded Remotion video ready

## Cost Estimate
- Claude API (planning, building, evaluating): ~$50-80
- Stitch: Free (350 gen/month)
- Vercel deploy: Free tier
- Total: ~$50-80 in API costs
