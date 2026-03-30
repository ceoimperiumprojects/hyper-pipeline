# Program: Improve Hyper-Pipeline Skill (REAL metric)

## Target
commands/hp-go.md
commands/hp-auto.md
commands/hp-build.md
commands/hp-eval.md
commands/hp-plan.md
agents/generator.md
agents/evaluator.md
agents/planner.md
rules/core.md

## Metric
```bash
cd /home/pavle/Desktop/Imperium-Hakaton-pipeline/hyper-pipeline && bash programs/metric-real-pipeline.sh
```
direction: higher
baseline: 79
target: 95

NOTE: This metric ACTUALLY RUNS the pipeline on a test project.
Phase 1 (30pts): Static quality — file existence, consistency, error docs, harness compliance, calibration
Phase 2 (70pts): Real execution — planner creates PLAN.md (20pts), generator builds code (25pts), evaluator writes EVAL-REPORT (25pts)

## Goal
Make the skill instructions SO CLEAR that when Claude reads them, it:
1. ALWAYS creates docs/PLAN.md with real content (not empty/trivial)
2. ALWAYS creates docs/SPRINT-CONTRACT.md with testable behaviors
3. Generator ACTUALLY builds code and commits
4. Evaluator ACTUALLY writes EVAL-REPORT.md with scores and findings

## Strategies
- Make instructions more EXPLICIT — tell Claude exactly what files to create, what format
- Add concrete examples of PLAN.md content in the planner agent
- Add concrete examples of SPRINT-CONTRACT.md behaviors in the planner
- Make generator instructions clearer about commit workflow
- Make evaluator instructions clearer about output format
- Remove ambiguity — if something can be interpreted two ways, fix it
- Ensure file paths are explicit (docs/PLAN.md not just "PLAN.md")
- Add "FIRST THING YOU DO" instructions at the top of each agent

## Constraints
- Keep each file under 400 lines
- Don't change the 4 grading criteria
- Don't change the core architecture (orchestrator → generator → evaluator)
- Don't remove features
- Changes must improve REAL execution, not just keyword matching
