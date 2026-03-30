#!/bin/bash
# REAL Pipeline Metric — runs skill on a test project and scores results
# Returns 0-100. Higher = better. Each step that ACTUALLY works = points.
#
# This takes ~2-5 minutes per run (spawns a Claude agent to plan+build)

TEST_DIR="/tmp/hp-test-project"
SKILL_DIR="/home/pavle/Desktop/Imperium-Hakaton-pipeline/hyper-pipeline"
SCORE=0

# Reset test project to clean state
cd "$TEST_DIR" || exit 1
git checkout master 2>/dev/null
git clean -fd 2>/dev/null
rm -rf docs/ .planning/ .hyper/ 2>/dev/null

# ═══════════════════════════════════════════════════
# PHASE 1: SKILL STATIC QUALITY (30 points)
# Can be checked without running anything
# ═══════════════════════════════════════════════════

# 1a. All critical files exist (5 pts)
for f in commands/hp-go.md commands/hp-auto.md commands/hp-build.md commands/hp-eval.md commands/hp-plan.md agents/generator.md agents/evaluator.md agents/planner.md rules/core.md; do
  [ -f "$SKILL_DIR/$f" ] && SCORE=$((SCORE + 1))
done
# 9 files = 5 points (rounding)
SCORE=$((SCORE * 5 / 9))

# 1a-extra. HARNESS-DESIGN.md must be MANDATORY in evaluator (penalty if skipped/removed)
if grep -qi "Do NOT read HARNESS\|skip.*HARNESS\|optional.*HARNESS" "$SKILL_DIR/agents/evaluator.md" 2>/dev/null; then
  SCORE=$((SCORE - 15))  # Heavy penalty for removing HARNESS requirement
fi
grep -qi "MANDATORY.*HARNESS\|MUST.*read.*HARNESS\|Read.*HARNESS.*BEFORE" "$SKILL_DIR/agents/evaluator.md" && SCORE=$((SCORE + 5))

# 1b. No internal contradictions (5 pts)
CONTRADICTIONS=0
# Max iterations should be consistent
GO_3=$(grep -c "max 3" "$SKILL_DIR/commands/hp-go.md" 2>/dev/null)
AUTO_3=$(grep -c "max 3\|3 rounds" "$SKILL_DIR/commands/hp-auto.md" 2>/dev/null)
EVAL_3=$(grep -c "max 3\|3 rounds" "$SKILL_DIR/agents/evaluator.md" 2>/dev/null)
[ "$GO_3" -gt 0 ] && [ "$AUTO_3" -gt 0 ] && [ "$EVAL_3" -gt 0 ] && SCORE=$((SCORE + 2))
# Plan enforcement consistent across files
PLAN_GO=$(grep -c "PLAN.md.*MUST\|PLAN.md.*exist\|HARD RULE.*PLAN" "$SKILL_DIR/commands/hp-go.md" 2>/dev/null)
PLAN_BUILD=$(grep -c "PLAN.md.*must\|PLAN.md.*exist\|HARD\|NEVER.*without.*plan" "$SKILL_DIR/commands/hp-build.md" 2>/dev/null)
[ "$PLAN_GO" -gt 0 ] && [ "$PLAN_BUILD" -gt 0 ] && SCORE=$((SCORE + 3))

# 1c. Error paths documented (5 pts)
ERR_SCORE=0
grep -q "app.*won't start\|won't start\|startup.*fail" "$SKILL_DIR/agents/evaluator.md" && ERR_SCORE=$((ERR_SCORE + 1))
grep -q "Playwright.*unavailable\|MCP.*unavailable\|fallback" "$SKILL_DIR/agents/evaluator.md" && ERR_SCORE=$((ERR_SCORE + 1))
grep -q "git init" "$SKILL_DIR/commands/hp-go.md" && ERR_SCORE=$((ERR_SCORE + 1))
grep -q "DISCARD\|checkout.*target\|revert" "$SKILL_DIR/rules/core.md" && ERR_SCORE=$((ERR_SCORE + 1))
grep -q "brand.*MUST\|brand.*required\|No brand" "$SKILL_DIR/rules/core.md" && ERR_SCORE=$((ERR_SCORE + 1))
SCORE=$((SCORE + ERR_SCORE))

# 1d. Harness Design compliance (5 pts)
HD_SCORE=0
grep -q "separate.*process\|SEPARATE.*agent\|fresh.*context" "$SKILL_DIR/commands/hp-go.md" && HD_SCORE=$((HD_SCORE + 2))
grep -q "SKEPTICAL\|skeptic" "$SKILL_DIR/agents/evaluator.md" && HD_SCORE=$((HD_SCORE + 1))
grep -q "ONE.*change\|ONE.*feature\|feature.*by.*feature" "$SKILL_DIR/agents/generator.md" && HD_SCORE=$((HD_SCORE + 1))
grep -q "PLAN.md.*SPRINT-CONTRACT" "$SKILL_DIR/commands/hp-go.md" && HD_SCORE=$((HD_SCORE + 1))
SCORE=$((SCORE + HD_SCORE))

# 1e. Calibration quality (5 pts)
CAL_SCORE=0
# Evaluator has score calibration examples with specific numbers
grep -q "Score 3\|3/10\|score.*3" "$SKILL_DIR/agents/evaluator.md" && CAL_SCORE=$((CAL_SCORE + 1))
grep -q "Score 5\|5/10\|score.*5" "$SKILL_DIR/agents/evaluator.md" && CAL_SCORE=$((CAL_SCORE + 1))
grep -q "Score 8\|8/10\|score.*8" "$SKILL_DIR/agents/evaluator.md" && CAL_SCORE=$((CAL_SCORE + 1))
grep -q "Score 10\|10/10\|score.*10" "$SKILL_DIR/agents/evaluator.md" && CAL_SCORE=$((CAL_SCORE + 1))
grep -q "Dribbble\|dribbble" "$SKILL_DIR/agents/evaluator.md" && CAL_SCORE=$((CAL_SCORE + 1))
SCORE=$((SCORE + CAL_SCORE))

# ═══════════════════════════════════════════════════
# PHASE 2: REAL PIPELINE EXECUTION (70 points)
# Actually run the skill on a test project
# ═══════════════════════════════════════════════════

# 2a. Run planner on test project — does it produce PLAN.md? (20 pts)
cd "$TEST_DIR"

# Spawn claude in non-interactive mode to test planning
timeout 180 claude --print --output-format text --dangerously-skip-permissions \
  --add-dir "$SKILL_DIR" \
  -p "You are in a Node.js project. Read the hyper-pipeline skill commands/hp-plan.md and agents/planner.md. Then create docs/PLAN.md and docs/SPRINT-CONTRACT.md for this feature: 'Add a /api/todos CRUD endpoint with in-memory storage'. Write the files and exit. Do NOT ask questions. Do NOT start building. ONLY create the plan files." \
  > /tmp/hp-research-plan-output.txt 2>&1

PLAN_EXISTS=0
CONTRACT_EXISTS=0
[ -f "$TEST_DIR/docs/PLAN.md" ] && PLAN_EXISTS=1
[ -f "$TEST_DIR/docs/SPRINT-CONTRACT.md" ] && CONTRACT_EXISTS=1

# Plan quality checks
PLAN_PTS=0
if [ $PLAN_EXISTS -eq 1 ]; then
  PLAN_PTS=$((PLAN_PTS + 5))  # File exists
  PLAN_LINES=$(wc -l < "$TEST_DIR/docs/PLAN.md")
  [ "$PLAN_LINES" -gt 10 ] && PLAN_PTS=$((PLAN_PTS + 3))  # Not trivially short
  [ "$PLAN_LINES" -gt 30 ] && PLAN_PTS=$((PLAN_PTS + 2))  # Substantial
  grep -qi "feature\|sprint\|architecture\|endpoint" "$TEST_DIR/docs/PLAN.md" && PLAN_PTS=$((PLAN_PTS + 2))
fi
if [ $CONTRACT_EXISTS -eq 1 ]; then
  PLAN_PTS=$((PLAN_PTS + 5))  # File exists
  grep -qi "BEHAVIOR\|behavior\|\- \[ \]" "$TEST_DIR/docs/SPRINT-CONTRACT.md" && PLAN_PTS=$((PLAN_PTS + 3))
fi
[ $PLAN_PTS -gt 20 ] && PLAN_PTS=20
SCORE=$((SCORE + PLAN_PTS))

# 2b. Run generator — does it actually build code? (25 pts)
if [ $PLAN_EXISTS -eq 1 ] && [ $CONTRACT_EXISTS -eq 1 ]; then
  timeout 180 claude --print --output-format text --dangerously-skip-permissions \
    --add-dir "$SKILL_DIR" \
    -p "You are in a Node.js project. Read docs/PLAN.md and docs/SPRINT-CONTRACT.md. Read the hyper-pipeline skill agents/generator.md. Build the features described in the plan. Create the code files, write tests, and commit each feature. Do NOT ask questions. Just build." \
    > /tmp/hp-research-build-output.txt 2>&1

  BUILD_PTS=0
  # Did it create any new files?
  NEW_FILES=$(git diff --name-only HEAD 2>/dev/null | wc -l)
  UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
  TOTAL_NEW=$((NEW_FILES + UNTRACKED))
  [ "$TOTAL_NEW" -gt 0 ] && BUILD_PTS=$((BUILD_PTS + 5))
  [ "$TOTAL_NEW" -gt 2 ] && BUILD_PTS=$((BUILD_PTS + 5))

  # Did it make commits?
  COMMITS=$(git log --oneline HEAD...master 2>/dev/null | wc -l)
  [ "$COMMITS" -gt 0 ] && BUILD_PTS=$((BUILD_PTS + 5))
  [ "$COMMITS" -gt 2 ] && BUILD_PTS=$((BUILD_PTS + 5))

  # Does the app still start?
  node server.js &
  SERVER_PID=$!
  sleep 2
  HEALTH=$(curl -sf http://localhost:3456/api/health 2>/dev/null | grep -c "ok")
  kill $SERVER_PID 2>/dev/null
  wait $SERVER_PID 2>/dev/null
  [ "$HEALTH" -gt 0 ] && BUILD_PTS=$((BUILD_PTS + 5))

  [ $BUILD_PTS -gt 25 ] && BUILD_PTS=25
  SCORE=$((SCORE + BUILD_PTS))
fi

# 2c. Run evaluator — does it produce EVAL-REPORT? (25 pts)
if [ $PLAN_EXISTS -eq 1 ]; then
  # Start server for eval
  cd "$TEST_DIR"
  node server.js &
  SERVER_PID=$!
  sleep 2

  timeout 180 claude --print --output-format text --dangerously-skip-permissions \
    --add-dir "$SKILL_DIR" \
    -p "You are evaluating a Node.js app running on http://localhost:3456. Read docs/SPRINT-CONTRACT.md and the hyper-pipeline skill agents/evaluator.md. Run static analysis (check files, grep for issues) and test the API endpoints with curl. Write docs/EVAL-REPORT.md with scores. Do NOT use Playwright — use curl and file reading only. Be SKEPTICAL." \
    > /tmp/hp-research-eval-output.txt 2>&1

  kill $SERVER_PID 2>/dev/null
  wait $SERVER_PID 2>/dev/null

  EVAL_PTS=0
  if [ -f "$TEST_DIR/docs/EVAL-REPORT.md" ]; then
    EVAL_PTS=$((EVAL_PTS + 10))  # Report exists
    EVAL_LINES=$(wc -l < "$TEST_DIR/docs/EVAL-REPORT.md")
    [ "$EVAL_LINES" -gt 10 ] && EVAL_PTS=$((EVAL_PTS + 5))
    grep -qi "PASS\|FAIL\|score\|Score" "$TEST_DIR/docs/EVAL-REPORT.md" && EVAL_PTS=$((EVAL_PTS + 5))
    grep -qi "bug\|issue\|finding\|recommendation" "$TEST_DIR/docs/EVAL-REPORT.md" && EVAL_PTS=$((EVAL_PTS + 5))
  fi
  [ $EVAL_PTS -gt 25 ] && EVAL_PTS=25
  SCORE=$((SCORE + EVAL_PTS))
fi

# Kill any leftover server
pkill -f "node server.js" 2>/dev/null

# ═══════════════════════════════════════════════════
# FINAL SCORE
# ═══════════════════════════════════════════════════
[ $SCORE -gt 100 ] && SCORE=100
[ $SCORE -lt 0 ] && SCORE=0
echo $SCORE
