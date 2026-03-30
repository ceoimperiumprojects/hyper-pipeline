# Program: Improve Hyper-Pipeline Skill

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
cd /home/pavle/Desktop/Imperium-Hakaton-pipeline/hyper-pipeline && bash programs/metric-skill-quality.sh
```
direction: higher

## Goal
Maximize skill quality score. Target: 90+

## Strategies
- Clearer instructions that leave no ambiguity for the agent
- Better calibration examples (specific scores with concrete descriptions)
- Stronger enforcement language (HARD RULE, MUST, NEVER)
- Remove contradictions between files
- Add missing error handling paths
- Better cross-references between commands and agents
- Reduce redundancy (same info in multiple places = drift risk)
- Tighter prompt engineering (less words, more precision)

## Constraints
- Keep each file under 400 lines (context budget)
- Don't change the 4 grading criteria (Functionality, Backend, Visual, Innovation)
- Don't change the core architecture (orchestrator → generator → evaluator)
- Don't remove features, only improve how they're described
- Maintain Serbian communication style references
- Keep Harness Design principles intact
