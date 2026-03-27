---
description: Generate hackathon presentation materials — HTML slides, demo script with fallbacks, optional Remotion video. Invokes the hp-presenter agent. Hackathon mode.
---

# /hp-present

This command invokes the **hp-presenter** agent to create presentation materials.

## What This Command Does

1. Reads `docs/PLAN.md` for product context and innovation argument
2. Reads `docs/EVAL-REPORT.md` to know what works (don't demo broken features)
3. Reads `.stitch/DESIGN.md` for visual style consistency
4. Generates `presentation.html` — self-contained slide deck (12-15 slides)
5. Writes `docs/DEMO-SCRIPT.md` — precise demo script with timing and fallbacks
6. (Optional) Creates Remotion video walkthrough as backup

## When to Use

- Hackathon mode, Phase 7 (after polish and deploy)
- When you need presentation materials for any demo
- Presentation = 33% of hackathon score — this is NOT optional

## Example

```
/hp-present                       # Generate all presentation materials
/hp-present --slides-only         # Just the slide deck
/hp-present --demo-script-only    # Just the demo script
```
