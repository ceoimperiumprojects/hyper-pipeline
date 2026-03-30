---
description: "AutoResearch — autonomous improvement loop. Give it a target + metric + program → it iterates until the score improves. Inspired by Karpathy's autoresearch."
argument-hint: "<program.md> [--rounds N] [--target-score N] [--budget Nh]"
---

# /hp-research — AutoResearch Engine

Autonomous improvement loop. Agent makes ONE change per round, measures, keeps or discards.

## Usage

```
/hp-research programs/improve-evaluator.md
/hp-research programs/optimize-api.md --rounds 15
/hp-research programs/improve-skill.md --target-score 90 --budget 3h
```

## How It Works

1. Read `program.md` → extract target file(s), metric command, constraints
2. Run metric → save as BASELINE_SCORE
3. Git commit baseline: `git add [target] && git commit -m "research: baseline score [X]"`

**LOOP (each round):**

4. Spawn a RESEARCHER Agent (separate process, fresh 200K context) with this prompt:

```
You are an AutoResearch agent. Your job: make ONE focused improvement to the target.

TARGET FILE(S): [from program.md]
CURRENT SCORE: [baseline or last KEEP score]
GOAL: [from program.md]

JOURNAL OF PAST EXPERIMENTS:
[contents of journal.md — what was tried, what worked, what failed]

CONSTRAINTS:
[from program.md]

RULES:
1. Make ONE focused change. Not a rewrite. One hypothesis, one edit.
2. Document your HYPOTHESIS: "I believe [change] will improve [metric] because [reason]"
3. Read the journal — do NOT repeat failed experiments
4. If 3+ consecutive failures in journal → PIVOT to completely different strategy
5. Build on previous KEEP changes, don't undo them

Make your change now. Edit the target file(s).
```

5. After agent completes, run metric command → NEW_SCORE

6. Compare:
   ```
   IF NEW_SCORE > BASELINE_SCORE (for "higher is better" metrics)
   OR NEW_SCORE < BASELINE_SCORE (for "lower is better" metrics):
     KEEP → git commit -m "research: round [N] — [hypothesis] → score [NEW] ✅"
     Update BASELINE_SCORE = NEW_SCORE
   ELSE:
     DISCARD → git checkout -- [target files]
     Log in journal only
   ```

7. Append to journal.md:
   ```markdown
   ## Round [N]
   **Hypothesis:** [what agent tried]
   **Change:** [brief diff summary]
   **Score:** [OLD] → [NEW]
   **Decision:** KEEP ✅ / DISCARD ❌
   **Reasoning:** [why it worked or didn't]
   ```

8. Check stop conditions:
   - `--rounds N` → stop after N rounds
   - `--target-score X` → stop when score ≥ X (or ≤ X for lower-is-better)
   - `--budget Nh` → stop after N hours
   - Default: 10 rounds

9. Final summary:
   ```
   ══════════════════════════════════════
   AUTORESEARCH COMPLETE

   Rounds: [N]
   Baseline: [X] → Final: [Y]
   Improvement: +[Z] ([P]%)
   KEEPs: [N] / DISCARDs: [N]
   PIVOTs: [N]

   Best change: Round [N] — [hypothesis]
   Journal: [path to journal.md]
   ══════════════════════════════════════
   ```

## Program.md Format

```markdown
# Program: [name]

## Target
[file path(s) to modify]

## Metric
[bash command that outputs ONE number]
direction: higher  # or "lower"

## Goal
[what we're trying to achieve]

## Strategies
[what to try — agent picks from these]

## Constraints
[what NOT to change]
```

## CRITICAL RULES

- ONE change per round — never batch multiple hypotheses
- Git for rollback — every KEEP is a commit, every DISCARD is a checkout
- Journal is context — agent reads it to avoid repeating failures
- Fresh context per round — no context rot over long runs
- PIVOT after 3 consecutive failures — change strategy entirely
