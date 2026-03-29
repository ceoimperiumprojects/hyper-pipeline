# PLAN: Hyper-Pipeline v2.0 — Final Polish

## Context

Pipeline je funkcionalan (13 komandi, 4 agenta, 11 skillova, harness design) ali ima 10 nedostataka koji sprečavaju "vrh nivou" status. Ovaj plan pokriva SVE — od backend few-shot kalibracije do finalnog README-a.

## Overview

**Product:** hyper-pipeline — AI execution engine za Claude Code
**Version:** 1.0.0 → 2.0.0
**Repo:** ceoimperiumprojects/hyper-pipeline
**Local:** /home/pavle/Desktop/Imperium-Hakaton-pipeline/hyper-pipeline/
**Global install:** ~/.claude/skills/hyper-pipeline/ + ~/.claude/commands/hp-*.md

---

## Core Features (šta treba da se uradi)

### P0 — MUST HAVE (blokiraju v2.0)

1. **Backend evaluator few-shot kalibracija**
   - Fajl: `agents/evaluator.md`
   - Lokacija u fajlu: posle frontend kalibracije (oko linije 250)
   - Dodati 4 backend score primera (3/5/8/10) po istom formatu kao frontend
   - Score 3: no tests, no validation, hardcoded secrets, N+1 queries
   - Score 5: some tests but gaps, basic validation, no pagination
   - Score 8: proper tests, Zod validation, pagination, error middleware, indexed queries
   - Score 10: production-grade, 90%+ coverage, security headers, rate limiting, monitoring hooks
   - Referenca: Anthropic paper evaluator calibration section

2. **Plugin.json ažuriranje**
   - Fajl: `.claude-plugin/plugin.json`
   - Dodati svih 13 komandi u commands array
   - Dodati skills/peers/ u skills array
   - Bump version 1.0.0 → 2.0.0
   - Ažurirati description sa novim featurima

3. **Novi templates**
   - `templates/API.md` — API dokumentacija template (metoda, URL, request body, response, auth, primeri)
   - `templates/DEPLOY-LOG.md` — Deploy log template (URL, platforma, timestamp, git hash, status)
   - Lokacija: /home/pavle/Desktop/Imperium-Hakaton-pipeline/hyper-pipeline/templates/
   - Referenca: generator.md sekcija "API Documentation"

4. **Trigger eval update za nove komande**
   - Fajl: `evals/trigger-eval.json`
   - Dodati trigger test promptove za: /hp-deploy, /hp-fix, /hp-refactor, /hp-test, /hp-ci, /hp-hackathon
   - Dodati negative cases: "deploy this" bez konteksta, "run my tests" (previše generičan)
   - Minimum 10 novih trigger promptova (6 true + 4 false)

### P1 — SHOULD HAVE (poboljšavaju kvalitet)

5. **Primeri ažuriranje**
   - `examples/daily-dev.md` — dodati /hp-fix, /hp-test, /hp-refactor flow
   - `examples/full-auto-startup.md` — dodati /hp-deploy, landing page, Claude Peers evaluator
   - `examples/hackathon.md` — ažurirati sa /hp-hackathon komandom
   - Novi: `examples/automation.md` — n8n workflow primer (za CoGrader use case)
   - Novi: `examples/existing-project.md` — /hp-go sa feature branch, regression tests

6. **README final polish**
   - Fajl: `README.md`
   - Koherentne sekcije (nema duplikata)
   - Badge update: 13 commands, 11 skills, v2.0
   - Dodati "Harness Design" sekciju sa dijagramom
   - Dodati "Obsidian Integration" sekciju
   - Dodati "Claude Peers" sekciju
   - Ažurirati benchmark sa iteration 2 + backend quality + UI quality enforcement
   - Dodati "Daily Dev Workflow" sekciju (ne samo greenfield/hackathon)

7. **Evaluator EVAL-REPORT template update**
   - Fajl: `templates/EVAL-REPORT.md`
   - Dodati Backend Quality sekciju (5 kriterijuma sa scoring)
   - Dodati Visual Quality Gate (Dribbble test, Framework test)
   - Dodati Harness Round tracking (Round 1/2/3 scores)

### P2 — NICE TO HAVE (bonus)

8. **Obsidian MCP install**
   - Repo: github.com/iansinnott/obsidian-claude-code-mcp
   - Install: git clone + npm install + claude mcp add
   - Vault path: ~/Obsidian/Imperium/
   - Dodati u CAPABILITIES.md

9. **mcp2cli install**
   - Repo: github.com/knowsuchagency/mcp2cli
   - Install: pip install mcp2cli
   - Konvertuje MCP servere u CLI za 96-99% manje tokena
   - Dodati u CAPABILITIES.md

10. **Version bump + git tag**
    - Bump version u plugin.json: 2.0.0
    - Git tag: v2.0.0
    - GitHub release sa changelog

---

## Architecture

```
hyper-pipeline/
├── .claude-plugin/plugin.json    ← UPDATE (v2.0, all commands)
├── SKILL.md                      ← OK
├── CAPABILITIES.md               ← OK (ali dodati Obsidian MCP ako se instalira)
├── HARNESS-DESIGN.md             ← OK
├── README.md                     ← UPDATE (final polish)
├── agents/
│   ├── planner.md                ← OK
│   ├── generator.md              ← OK
│   ├── evaluator.md              ← UPDATE (backend few-shot)
│   └── presenter.md              ← OK
├── skills/ (11)
│   ├── plan/       build/       eval/       design/     present/
│   ├── research/   brand/       content/    outreach/   validate/
│   └── peers/                    ← OK
├── commands/ (13)
│   ├── hp-auto     hp-go        hp-hackathon
│   ├── hp-plan     hp-build     hp-eval      hp-design   hp-present
│   └── hp-deploy   hp-fix       hp-refactor  hp-test     hp-ci
├── templates/ (8 → dodati 2)
│   ├── PLAN.md     BRAND.md     SPRINT-CONTRACT.md
│   ├── EVAL-REPORT.md           ← UPDATE (backend + visual gate)
│   ├── DEMO-SCRIPT.md           HACKATHON-CLAUDE.md
│   ├── API.md                   ← NEW
│   └── DEPLOY-LOG.md            ← NEW
├── rules/
│   ├── core.md                  ← OK
│   └── hackathon.md             ← OK
├── examples/ (3 → update + 2 nova)
│   ├── daily-dev.md             ← UPDATE
│   ├── full-auto-startup.md     ← UPDATE
│   ├── hackathon.md             ← UPDATE
│   ├── automation.md            ← NEW
│   └── existing-project.md      ← NEW
├── evals/
│   ├── trigger-eval.json        ← UPDATE (+10 promptova)
│   ├── evals.json               ← OK
│   └── E2E-TEST-PLAN.md         ← OK
└── hooks/hooks.json              ← OK
```

---

## Data Model

N/A — ovo je skill (markdown fajlovi), nema bazu.

## API Surface

N/A — ovo su Claude Code slash komande, ne API endpoints.

---

## Sprint Plan

### Sprint 1: Backend Kalibracija + Templates (30 min)

| Task | Fajl | Opis |
|------|------|------|
| 1.1 | `agents/evaluator.md` | Dodati 4 backend few-shot primera (score 3/5/8/10) |
| 1.2 | `templates/API.md` | Kreirati API docs template |
| 1.3 | `templates/DEPLOY-LOG.md` | Kreirati deploy log template |
| 1.4 | `templates/EVAL-REPORT.md` | Dodati Backend Quality + Visual Quality Gate sekcije |

### Sprint 2: Plugin + Evals + Examples (30 min)

| Task | Fajl | Opis |
|------|------|------|
| 2.1 | `.claude-plugin/plugin.json` | v2.0.0, svi commands/skills |
| 2.2 | `evals/trigger-eval.json` | +10 trigger promptova za nove komande |
| 2.3 | `examples/daily-dev.md` | Update sa fix/test/refactor flow |
| 2.4 | `examples/full-auto-startup.md` | Update sa deploy + peers |
| 2.5 | `examples/hackathon.md` | Update sa /hp-hackathon |
| 2.6 | `examples/automation.md` | NEW — n8n workflow primer |
| 2.7 | `examples/existing-project.md` | NEW — /hp-go feature branch flow |

### Sprint 3: README + Version Bump + Deploy (20 min)

| Task | Fajl | Opis |
|------|------|------|
| 3.1 | `README.md` | Final polish — sve sekcije koherentne |
| 3.2 | `.claude-plugin/plugin.json` | Version 2.0.0 confirm |
| 3.3 | Git tag v2.0.0 | `git tag v2.0.0 && git push --tags` |
| 3.4 | Sync sve na globalnu instalaciju | cp sve u ~/.claude/ |
| 3.5 | Obsidian daily note update | Zapisati šta je urađeno |

---

## Innovation Argument

Hyper-Pipeline je JEDINI Claude Code skill koji implementira komplet Anthropic Harness Design metodologiju:
- GAN-inspired generator↔evaluator separation (sa Claude Peers za fizičku separaciju)
- Few-shot kalibriran evaluator za frontend I backend
- 4 grading criteria iz Anthropic papera
- Strategic REFINE/PIVOT decision posle svake eval runde
- Self-improving skills kroz OpenSpace
- 13 komandi za celokupan dev lifecycle (plan→build→eval→deploy→fix→refactor→test→ci)

Nijedan drugi skill/plugin na tržištu ovo nema.

---

## Demo Script Outline

```
00:00 — "Imam spec za SaaS app. Jednom komandom:"
00:30 — /hp-auto docs/SPEC.md → planner generiše PLAN.md + brand
01:00 — Generator gradi backend (Supabase + tRPC)
01:30 — Generator gradi frontend (Uncodixfy + frontend-design enforced)
02:00 — Evaluator QAs sa Playwright (live screenshots)
02:30 — Fix loop: evaluator → generator → evaluator (REFINE/PIVOT)
03:00 — GTM: leads (imperium-crawl), content (LinkedIn), landing page
03:30 — /hp-deploy → Vercel → LIVE
04:00 — Pokazati Obsidian vault sa daily note + project status
04:30 — "13 komandi, full lifecycle, Anthropic Harness Design"
```

---

## Risks

| Risk | Mitigation |
|------|-----------|
| README predugačak | Koristiti collapse sekcije (<details>) |
| Previše primera | Svaki primer max 50 linija |
| Plugin.json breaking change | Testirati sa `claude plugins list` |
| Git tag conflict | Proveriti `git tag -l` pre tagovanja |

---

## Success Criteria

- [ ] `evaluator.md` ima 4 backend few-shot primera
- [ ] `templates/` ima 8 fajlova (dodati API.md + DEPLOY-LOG.md)
- [ ] `plugin.json` v2.0.0 sa svim commands i skills
- [ ] `trigger-eval.json` ima 30+ promptova (20 starih + 10 novih)
- [ ] `examples/` ima 5 primera (3 updatovanih + 2 nova)
- [ ] `README.md` koherentan sa svim sekcijama
- [ ] Git tag v2.0.0 postoji
- [ ] Svi fajlovi synkovani na globalnu instalaciju
- [ ] Obsidian daily note ažuriran
