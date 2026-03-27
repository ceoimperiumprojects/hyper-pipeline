---
name: pipeline-design
description: Design phase skill integrating Google Stitch 2.0. Offers MCP automatic or manual design spec workflow. Produces DESIGN.md and React component shells.
origin: hyper-pipeline
---

# Pipeline Design

Handles the UI/UX design phase using Google Stitch 2.0. Offers two workflows: automatic via MCP or manual via design spec.

## When to Activate

- User invokes `/hp-design`
- After Sprint 1 backend is complete (you know the data shape)
- Before Sprint 2 frontend build begins

## CRITICAL: UI Timing

**Do NOT design UI before backend is built.** The design must match real data, real API responses, real error states. Designing first leads to UI that doesn't match reality.

```
WRONG:  Design → Build backend → Retrofit UI to match data
RIGHT:  Build backend → Design UI for real data → Build frontend
```

## Two Workflows (Ask User)

### Option A: Stitch MCP (Automatic)

If Stitch MCP is configured (`@_davideast/stitch-mcp proxy`):

1. Use Stitch MCP tools to generate screens from prompts based on PLAN.md
2. Use `get_screen_code` to extract HTML/CSS for each screen
3. Use `get_screen_image` for screenshot references
4. Extract design system into `.stitch/DESIGN.md`
5. Use `react-components` Stitch skill to generate React component shells

**Stitch MCP Config:**
```json
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": ["@_davideast/stitch-mcp", "proxy"]
    }
  }
}
```

**Stitch Skills (install globally):**
```bash
npx skills add google-labs-code/stitch-skills --skill stitch-design --global
npx skills add google-labs-code/stitch-skills --skill react:components --global
```

### Option B: Design Spec (Manual)

If user prefers manual control or Stitch MCP isn't available:

1. Generate `docs/DESIGN-SPEC.md` with:
   - Color palette (with hex values, themed to project)
   - Typography hierarchy (headings, body, labels, captions)
   - Spacing system (4px base grid)
   - Layout descriptions for each screen (wireframe in words)
   - Component inventory (buttons, cards, forms, nav)
   - Interaction patterns (hover, click, loading, error)
   - Mobile adaptation notes
2. User opens Stitch (stitch.withgoogle.com) and designs screens using the spec
3. User exports HTML/CSS and brings it back to the project
4. Extract design tokens into `.stitch/DESIGN.md`

**Advantage of manual:** User sees and approves every design decision before code.

## DESIGN.md Format

```markdown
# Design System

## Colors
- Primary: #[hex] — [usage]
- Secondary: #[hex] — [usage]
- Background: #[hex]
- Surface: #[hex]
- Text: #[hex]
- Text Secondary: #[hex]
- Error: #[hex]
- Success: #[hex]

## Typography
- Heading 1: [font], [size], [weight]
- Heading 2: [font], [size], [weight]
- Body: [font], [size], [weight]
- Caption: [font], [size], [weight]

## Spacing
- Base unit: 4px
- Compact: 8px
- Default: 16px
- Relaxed: 24px
- Section: 48px

## Components
- Buttons: [style description]
- Cards: [style description]
- Forms: [style description]
- Navigation: [style description]

## Design Principles
- [Principle 1]
- [Principle 2]
```

## Output

- `.stitch/DESIGN.md` — Design system tokens and principles
- `docs/DESIGN-SPEC.md` — (Option B only) Detailed design spec for manual work
- Component shells in `apps/web/components/` (if Option A with react-components)
- Screenshots in `docs/design/` for reference
