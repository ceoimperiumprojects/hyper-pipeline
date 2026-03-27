# Full Auto Startup — Example

## Scenario: Ad Sniper Platform

**Input:** User gives spec file and runs `/hp-auto docs/AD-SNIPER.md`

---

## Phase 0: Gathering (front-loaded questions)

```
HP: "Za koji brend radiš?"
→ No brand exists → Brand Wizard runs:
  - Name: AdSniper
  - Archetype: Hero (bold, empowering) + Innovator (forward-thinking)
  - Colors: Deep navy #1A1F36, Electric blue #3B82F6, White #FFFFFF
  - Font: Space Grotesk (heading), Inter (body)
  - Voice: Casual 7/10, Technical 5/10, Serious 4/10, Bold 9/10
→ Saved to ~/.hyper/brands/adsniper.md + .hyper/brand.md

HP: "Treba li lead gen?"
→ "Da — marketing agencije, 50-200 zaposlenih, US + EU"

HP: "Treba li content?"
→ "Da — 3 LinkedIn posta + 1 carousel"

HP: "Treba li landing page?"
→ "Da"

HP: "Treba li outreach?"
→ "Da — 3-email sekvenca"

HP: "Design: Stitch MCP ili ručno?"
→ "MCP automatski"

🤖 Research runs (imperium-crawl):
  - Ad monitoring competitors found: 12
  - Gap identified: no real-time AI alerting
  - Market size: $2.3B

🤖 PLAN.md generated with ALL answers baked in
```

**After Phase 0: ZERO more questions. Pure execution.**

---

## Phase 1: Build Backend (Sprint 1) — 4h auto

```
🤖 feat: add ad monitoring data model → commit
🤖 feat: add /api/ads/monitor endpoint → commit
🤖 feat: add /api/alerts/configure endpoint → commit
🤖 feat: add competitor ad scraping service → commit
🤖 feat: add AI ad analysis with Claude API → commit
🤖 feat: seed demo data → commit
```

## Phase 2: Design — auto via Stitch MCP

```
🤖 Stitch generates 4 screens (brand colors applied)
🤖 DESIGN.md extracted
🤖 React component shells generated
```

## Phase 3: Build Frontend + AI (Sprint 2) — 5h auto

```
🤖 feat: add dashboard with real-time ad feed → commit
🤖 feat: add AI alert configuration UI → commit
🤖 feat: add competitor comparison view → commit
🤖 feat: add Claude AI ad analysis agent → commit
🤖 feat: add streaming AI responses → commit
```

## Phase 4: Test — auto

```
🤖 Phase A: Static — tsc OK, 0 console.log, tests pass
🤖 Phase B: Runtime — Playwright navigates all pages, tests features
🤖 Phase C: Visual Audit — screenshots reviewed:
    Dashboard: 8/10 (spacing good, header needs alignment fix)
    Alert config: 9/10
    LinkedIn image: 7/10 (text too small → fixed)
🤖 EVAL-REPORT: FAIL (dashboard alignment + LinkedIn image)
🤖 Generator fixes → re-eval → PASS (34/40)
```

## Phase 5: GTM (Sprint 4) — 3h auto

```
🤖 imperium-crawl: scrapes 500 marketing agencies
🤖 BANT qualification: 127 qualified leads
🤖 3-email outreach sequence generated
🤖 3 LinkedIn posts + images (Remotion) generated
🤖 1 carousel (8 slides, Remotion) generated
🤖 Landing page built + deployed to Vercel
🤖 Visual audit on all content → PASS
```

## Phase 6: Presentation — auto

```
🤖 12-slide presentation (Remotion → PNG + PPTX)
🤖 Demo script with timing
🤖 90s demo video (Remotion → MP4)
```

## Done — AUTO-SUMMARY.md

```markdown
# AdSniper — Auto Build Summary

## Delivered
✅ App: deployed at adsniper.vercel.app
✅ Brand: AdSniper identity (navy + electric blue, Space Grotesk)
✅ Leads: 127 qualified marketing agencies
✅ Emails: 3-sequence outreach ready
✅ Content: 3 LinkedIn posts + images + 1 carousel
✅ Landing: live, branded, responsive
✅ Pitch: 12-slide PPTX + demo video
✅ Eval: 34/40 (Functionality 9, Code 8, Visual 8, Innovation 9)

## Deferred
- Mobile app version
- Slack integration for alerts

## Stats
- Total commits: 14
- Build time: ~12 hours
- Test coverage: 78%
```
