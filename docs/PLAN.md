# AutoResearch — Universal Autonomous Improvement Framework

## Overview

Generalizovan framework inspirisan Karpathy-jevim autoresearch-om. Umesto da poboljšava samo ML modele, poboljšava **BILO ŠTA** što ima merljiv broj.

**Core loop:**
```
target (šta menjaš) + metric (kako meriš) + program (šta probaš) = autonomous improvement
```

## Zašto

Karpathy je pokazao: agent + metrika + loop = autonomno poboljšanje. Ali isti pattern radi za sve — ne samo ML:

| Target | Metric | Primer |
|--------|--------|--------|
| ML model | val_bpb | Karpathy autoresearch |
| Skill prompt | eval score (X/40) | HP evaluator/generator |
| Code | test pass rate, lighthouse, bundle size | Performance |
| Pipeline | success rate, time, cost | CI/CD |
| Config | build time, error count | webpack, tsconfig |

**NE radi za:** Content (postovi, emailovi), kreativni rad, dizajn. To su subjektivne stvari — ljudski engagement se ne meri brojem koji agent može da optimizuje. AutoResearch je za OBJEKTIVNO MERLJIVE stvari.

## Arhitektura

```
┌─────────────────────────────────────────────────────────┐
│                    AUTORESEARCH ENGINE                    │
│                                                          │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐            │
│  │ TARGET   │   │ METRIC   │   │ PROGRAM  │            │
│  │ Šta      │   │ Kako     │   │ Šta da   │            │
│  │ menjaš   │   │ meriš    │   │ probaš   │            │
│  └────┬─────┘   └────┬─────┘   └────┬─────┘            │
│       ▼              ▼              ▼                    │
│  ┌──────────────────────────────────────────┐           │
│  │              LOOP ENGINE                  │           │
│  │                                           │           │
│  │  1. Read target + program                 │           │
│  │  2. Agent makes ONE change (hypothesis)   │           │
│  │  3. Run metric → get score                │           │
│  │  4. Score > baseline? KEEP : DISCARD      │           │
│  │  5. Log in journal                        │           │
│  │  6. Repeat until done                     │           │
│  └──────────────────────────────────────────┘           │
│                       │                                  │
│  ┌────────────────────▼─────────────────────┐           │
│  │              JOURNAL                      │           │
│  │  Round 1: Changed X → 24 → KEEP ✅       │           │
│  │  Round 2: Changed Y → 22 → DISCARD ❌    │           │
│  │  Round 3: Changed Z → 27 → KEEP ✅       │           │
│  └──────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────┘
```

## Tri Fajla — Karpathy Pattern

### 1. `target` — šta se menja
Fajl(ovi) koje agent sme da edituje. Sve ostalo read-only.

### 2. `metric` — kako se meri
Bash komanda koja vraća JEDAN BROJ.

```bash
# Skill quality
grep "Score:" docs/EVAL-REPORT.md | awk -F'/' '{print $1}' | awk '{print $NF}'

# Lighthouse
npx lighthouse http://localhost:3000 --output=json | jq '.categories.performance.score * 100'

# Test coverage
npx vitest run --coverage 2>&1 | grep "All files" | awk '{print $4}'

# Bundle size (lower = better)
npm run build 2>&1 | grep "size" | awk '{print $NF}'

# API latency (lower = better)
curl -w "%{time_total}" -s http://localhost:3000/api/health -o /dev/null
```

### 3. `program.md` — šta agent proba
Instrukcije: cilj, šta sme, šta ne sme, koje strategije.

## Komanda: `/hp-research`

```
/hp-research program.md              # Run from program
/hp-research --rounds 15             # Max 15 eksperimenata
/hp-research --target-score 35       # Stop kad score ≥ 35
/hp-research --budget 2h             # Stop posle 2 sata
```

### Loop

```
1. Read program.md → target, metric, constraints
2. Run metric → BASELINE_SCORE
3. Save target as BASELINE (git commit "baseline")

FOR round = 1 to MAX_ROUNDS:
    4. Spawn RESEARCHER Agent (separate, fresh 200K context):
       - Reads: program.md + target + journal (past experiments)
       - Makes ONE focused change with hypothesis
       - Documents what and why

    5. Run metric → NEW_SCORE

    6. IF NEW_SCORE > BASELINE_SCORE:
         KEEP (commit: "research: round N — [hypothesis] → score [X]")
         BASELINE_SCORE = NEW_SCORE
       ELSE:
         DISCARD (git checkout -- target)

    7. Log in journal: round, hypothesis, score, KEEP/DISCARD

    8. STOP if: target reached | budget exhausted | max rounds

9. Final summary: best score, total improvement, top changes
```

### Key Design

- **Jedan change per round** — znaš koja promena je pomogla
- **Git za rollback** — DISCARD = `git checkout`, KEEP = commit
- **Journal = agent memory** — agent čita šta je probano, ne ponavlja greške
- **Fresh context** — svaki round spawnuje novog agenta (nema context rot)
- **Score trend** — 3 DISCARDs u nizu → agent PIVOTira strategiju

## Sprint Contract

### Sprint 1: Core Engine

- [ ] BEHAVIOR: `/hp-research program.md` čita program, meri baseline, pokreće loop
  - TEST: Napravi test program za trivialnu optimizaciju, pokreni
  - EXPECTED: Agent čita program, meri baseline, pravi promenu, meri ponovo

- [ ] BEHAVIOR: Svaki round spawnuje ODVOJEN agent sa fresh context-om
  - TEST: Proveri da agent ne referencira prethodne runde (samo journal)
  - EXPECTED: Fresh 200K context, čita journal za istoriju

- [ ] BEHAVIOR: KEEP/DISCARD na osnovu metrike
  - TEST: Promena poboljša score → kept. Pogorša → discarded.
  - EXPECTED: Git ima samo KEEP commitove

- [ ] BEHAVIOR: Journal loguje sve eksperimente
  - TEST: Posle 5 rundi, journal ima 5 entry-ja
  - EXPECTED: Markdown sa: round, hypothesis, score, decision

- [ ] BEHAVIOR: Stop kad target score dostignut ILI budget istekao ILI max rounds
  - TEST: --target-score 30, trenutno 25, staje kad ≥30
  - EXPECTED: Loop izlazi sa final summary

### Sprint 2: Intelligence

- [ ] BEHAVIOR: Agent čita journal i NE PONAVLJA failed eksperimente
  - TEST: Posle DISCARD, sledeći round proba nešto drugo
  - EXPECTED: Agent u outputu kaže "Round 3 tried X, failed. Trying Y."

- [ ] BEHAVIOR: Compound changes — gradi na prethodnim KEEP promenama
  - TEST: Round 1 KEEP-uje A, Round 2 gradi na A sa B
  - EXPECTED: Inkrementalno poboljšanje

- [ ] BEHAVIOR: 3 DISCARD-a u nizu → PIVOT strategiju
  - TEST: Forsiraj 3 failures
  - EXPECTED: Journal: "PIVOT: previous approach exhausted"

### Sprint 3: Multi-Metric + Presets

- [ ] BEHAVIOR: Program može definisati VIŠE metrika sa težinama
  - TEST: speed (0.6) + quality (0.4) → combined score
  - EXPECTED: Weighted average

- [ ] BEHAVIOR: Preset programi za česte use case-ove
  - TEST: `/hp-research --preset skill-improvement` koristi ugrađeni program
  - EXPECTED: Program.md za skill improvement auto-generisan

- [ ] BEHAVIOR: Pareto tracking — ne žrtvuj jednu metriku za drugu
  - TEST: Speed raste ali quality pada ispod floor-a
  - EXPECTED: DISCARD — quality floor nije zadovoljen
