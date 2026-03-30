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
THIS PROCESS (Orchestrator — zero user input)
│
├─ 1. CODEBASE SCAN (inline)
│     Read structure, patterns, stack, conventions
│
├─ 2. PLAN (inline)
│     Generate docs/PLAN.md + docs/SPRINT-CONTRACT.md
│     Auto-approve. NEVER skip.
│
├─ 3. GIT BRANCH
│     git checkout -b hp/[feature-name]
│     Run existing tests (baseline)
│
├─ 4. BUILD → EVAL LOOP (max 3 rounds)
│     │
│     ├─ Spawn Generator Agent (separate process)
│     │   Builds features, TDD, commits each
│     │   Writes docs/BUILD-LOG.md
│     │
│     ├─ Spawn Evaluator Agent (SEPARATE process, FRESH context)
│     │   Tests EVERYTHING with Playwright
│     │   Grades 4×10, writes docs/EVAL-REPORT.md
│     │   SKEPTICAL — never seen generator's work
│     │
│     └─ Decision (this process):
│         Scores improving → REFINE → back to Generator
│         Scores flat/dropping → PIVOT → Generator tries new approach
│         PASS or 3 rounds exhausted → continue
│
├─ 5. MERGE
│     git checkout main && git merge hp/[feature-name]
│
└─ 6. DONE
      Write docs/AUTO-SUMMARY.md
```

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
PHASE C — Visual (if frontend): Screenshots, AI slop detection, Dribbble test
PHASE D — Grade 4×10: Functionality, Backend Quality, Visual Quality, Innovation

Visual Quality ≤6 = AUTO FAIL.
Framework identifiable at glance = AUTO FAIL.

Write docs/EVAL-REPORT.md. BE SKEPTICAL. Issues ARE issues.
```

## Build→QA Loop

Based on Anthropic's DAW example: Build 2h → QA 9m → Build 1h → QA 7m → Build 11m → QA 10m

- **Round 1:** Generator builds ALL features → Evaluator QAs
- **Round 2:** Generator fixes FAIL items (REFINE or PIVOT) → Evaluator re-QAs
- **Round 3:** Generator addresses remaining gaps → Final QA
- After 3 rounds: report remaining issues, merge anyway

## Context Management

Long auto runs risk context exhaustion. The orchestrator compacts between rounds:

```
After PLAN → compact, keep: PLAN.md, SPRINT-CONTRACT.md
After each EVAL round → compact, keep: PLAN.md, EVAL-REPORT.md, BUILD-LOG.md
```

Agents don't need compaction — each spawn gets fresh 200K context.
