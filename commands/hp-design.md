---
description: Design phase — generate UI designs via Stitch MCP or create a design spec for manual Stitch work. Asks user preference. Produces DESIGN.md and component shells.
---

# /hp-design

This command handles the design phase of the pipeline. It asks you how you want to work with Stitch.

## What This Command Does

1. Asks your preference:
   - **Option A: Stitch MCP** — Claude generates designs via Stitch MCP, extracts code and DESIGN.md automatically
   - **Option B: Design Spec** — Claude generates a detailed `docs/DESIGN-SPEC.md` that you use to manually create designs in Stitch, then bring the code back
2. Extracts or generates `.stitch/DESIGN.md` (design system: colors, typography, spacing)
3. Creates React component shells from the designs (if applicable)

## When to Use

- After Sprint 1 backend is built (you know the data shape)
- Before Sprint 2 frontend work begins
- **NOT before backend** — UI should match real data, not imaginary data

## Why This Timing Matters

- Too early: UI won't match the actual API responses and data model
- Too late: No time to iterate on design
- Sweet spot: After backend works, before frontend build

## Example

```
/hp-design                # Asks preference and runs design flow
```
