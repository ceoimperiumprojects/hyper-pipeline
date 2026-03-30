#!/bin/bash
# Skill Quality Metric — scores HP skill files on objective criteria
# Returns a single number (0-100). Higher = better.

DIR="/home/pavle/Desktop/Imperium-Hakaton-pipeline/hyper-pipeline"
SCORE=0

# 1. All critical files exist (10 points)
for f in commands/hp-go.md commands/hp-auto.md commands/hp-build.md commands/hp-eval.md commands/hp-plan.md commands/hp-research.md agents/generator.md agents/evaluator.md agents/planner.md rules/core.md HARNESS-DESIGN.md; do
  [ -f "$DIR/$f" ] && SCORE=$((SCORE + 1))
done

# 2. Enforcement language (15 points)
ENFORCE=$(grep -rci "HARD RULE\|MUST\|NEVER\|MANDATORY\|STOP.*if\|auto.*FAIL" "$DIR"/commands/hp-*.md 2>/dev/null | awk -F: '{s+=$2}END{print s+0}')
[ "$ENFORCE" -gt 30 ] && ENFORCE=30
SCORE=$((SCORE + ENFORCE / 2))

# 3. Error handling documented (15 points)
ERR_FILES=$(grep -rli "won't start\|unavailable\|fallback\|HARD FAIL\|error.*handl" "$DIR"/commands/ "$DIR"/agents/ "$DIR"/rules/ 2>/dev/null | wc -l)
SCORE=$((SCORE + ERR_FILES * 2))

# 4. Agent separation documented (10 points)
SEP=$(grep -rci "separate.*agent\|separate.*process\|fresh.*context\|SEPARATE\|spawn.*Agent\|physical.*separat" "$DIR"/commands/hp-go.md "$DIR"/commands/hp-auto.md 2>/dev/null | awk -F: '{s+=$2}END{print s+0}')
[ "$SEP" -gt 10 ] && SEP=10
SCORE=$((SCORE + SEP))

# 5. Wizard/questioning documented (10 points)
WIZ=$(grep -rci "wizard\|pitaj\|AskUser\|existing.*project\|new.*project\|CONTEXT WIZARD" "$DIR"/commands/hp-go.md "$DIR"/commands/hp-auto.md 2>/dev/null | awk -F: '{s+=$2}END{print s+0}')
[ "$WIZ" -gt 10 ] && WIZ=10
SCORE=$((SCORE + WIZ))

# 6. Visual eval covers all outputs (10 points)
VIS=$(grep -ci "LinkedIn\|carousel\|slides\|pitch\|hero.*image\|chatgpt.*image\|Remotion\|ALL.*visual" "$DIR"/agents/evaluator.md 2>/dev/null)
[ "$VIS" -gt 10 ] && VIS=10
SCORE=$((SCORE + VIS))

# 7. Brand documented (5 points)
BRAND=$(grep -rl ".hyper/brand.md" "$DIR"/commands/ "$DIR"/agents/ 2>/dev/null | wc -l)
[ "$BRAND" -gt 5 ] && BRAND=5
SCORE=$((SCORE + BRAND))

# 8. Calibration examples in evaluator (10 points)
CAL=$(grep -c "Score.*10\|Score.*3\|Score.*5\|Score.*8\|calibration\|CALIBRATION\|few-shot" "$DIR"/agents/evaluator.md 2>/dev/null)
[ "$CAL" -gt 10 ] && CAL=10
SCORE=$((SCORE + CAL))

# 9. GTM tools documented (5 points)
GTM=$(grep -ci "imperium-crawl\|chatgpt-py\|Remotion\|outreach\|BANT" "$DIR"/commands/hp-auto.md 2>/dev/null)
[ "$GTM" -gt 5 ] && GTM=5
SCORE=$((SCORE + GTM))

# Cap at 100
[ $SCORE -gt 100 ] && SCORE=100
echo $SCORE
