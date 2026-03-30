# Sprint Contract — AutoResearch Engine

## Hard Fail Conditions
- [ ] Komanda `/hp-research` ne postoji ili ne radi
- [ ] Agent ne čita program.md
- [ ] Metrika se ne izvršava (bash command fails)
- [ ] Journal se ne piše
- [ ] DISCARD ne revertuje promene (git checkout fails)

## Sprint 1: Core Engine

- [ ] BEHAVIOR: User radi `/hp-research program.md` → engine čita program, meri baseline, loguje
  - TEST: Napravi program.md sa target=test-file.md, metric=`wc -l test-file.md | awk '{print $1}'`
  - EXPECTED: Engine ispisuje "Baseline score: [N]" i počinje loop

- [ ] BEHAVIOR: Svaki round spawnuje Agent tool sa fresh context-om
  - TEST: Proveri da agent prompt uključuje program.md + journal ali NE prethodne runde
  - EXPECTED: Agent tool pozvan sa promptom koji sadrži journal sadržaj

- [ ] BEHAVIOR: Agent pravi JEDNU promenu i documentiše hypothesis
  - TEST: Posle jednog rounda, diff pokazuje jednu fokusiranu promenu
  - EXPECTED: Git diff je mali i fokusiran, ne masivan rewrite

- [ ] BEHAVIOR: Metric se pokreće posle promene i poređuje sa baseline
  - TEST: Metrika vraća broj, engine poredi sa prethodnim
  - EXPECTED: Output: "Round 1: score [X] vs baseline [Y] → KEEP/DISCARD"

- [ ] BEHAVIOR: KEEP = git commit, DISCARD = git checkout
  - TEST: Napravi promenu koja pogorša score → fajl se vrati na prethodno
  - EXPECTED: `git log` pokazuje samo KEEP commitove, fajl sadržaj = baseline posle DISCARD

- [ ] BEHAVIOR: Journal.md se piše posle svakog rounda
  - TEST: Posle 3 runde, journal ima 3 entry-ja
  - EXPECTED: Format: `## Round N\n**Hypothesis:** ...\n**Score:** X → KEEP/DISCARD`

- [ ] BEHAVIOR: Loop staje na --rounds, --target-score, ili --budget
  - TEST: `--rounds 3` → tačno 3 runde; `--target-score 10` → staje kad ≥10
  - EXPECTED: Poruka: "Stopped: [reason]. Best score: [X]. Improvement: +[Y]"

## Sprint 2: Intelligence

- [ ] BEHAVIOR: Agent čita journal i izbegava ponovljene neuspehe
  - TEST: Round 1 proba A i DISCARD. Round 2 NE proba A ponovo.
  - EXPECTED: Agent output referira "Round 1 tried A, failed"

- [ ] BEHAVIOR: Agent gradi na KEEP promenama (compound improvement)
  - TEST: Round 1 KEEP A. Round 2 pravi malu dopunu na A.
  - EXPECTED: Fajl sadrži i A i dopunu

- [ ] BEHAVIOR: 3 DISCARD-a u nizu → PIVOT
  - TEST: Forsiraj 3 loša scora
  - EXPECTED: Journal: "PIVOT: 3 consecutive failures. Changing strategy."

## Sprint 3: Multi-Metric + Presets

- [ ] BEHAVIOR: Weighted multi-metric (speed * 0.6 + quality * 0.4)
  - TEST: Program sa dve metrike i težinama
  - EXPECTED: Combined score = weighted average

- [ ] BEHAVIOR: `--preset skill-improvement` generiše program automatski
  - TEST: `/hp-research --preset skill-improvement --target agents/evaluator.md`
  - EXPECTED: Program.md kreiran sa odgovarajućom metrikom za skill

- [ ] BEHAVIOR: Quality floor — ne žrtvuj jednu metriku ispod minimuma
  - TEST: Speed raste ali quality < 5
  - EXPECTED: DISCARD, log: "Quality floor violated (4 < 5)"
