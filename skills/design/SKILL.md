---
name: pipeline-design
description: Design phase skill with smart UI workflow. Detects Stitch MCP and Stitch Skills availability. In collab/hackathon asks user preference, collects detailed UI requirements, generates comprehensive design spec. In auto mode, auto-detects best available tool.
origin: hyper-pipeline
---

# Pipeline Design

Smart UI design phase — detects available tools and adapts workflow accordingly.

## When to Activate

- User invokes `/hp-design`
- After Sprint 1 backend is complete (you know the data shape)
- Before Sprint 2 frontend build begins

## CRITICAL: UI Timing

**Do NOT design UI before backend is built.** The design must match real data, real API responses, real error states.

```
WRONG:  Design → Build backend → Retrofit UI to match data
RIGHT:  Build backend → Design UI for real data → Build frontend
```

---

## Tool Detection (Run First)

Before asking the user anything, detect what's available:

```bash
# 1. Check Stitch MCP server
# Look in MCP config for "stitch" server
grep -l "stitch" ~/.claude/settings.json ~/.claude/settings.local.json 2>/dev/null

# 2. Check Stitch Skills (google-labs-code/stitch-skills)
npx skills list --global 2>/dev/null | grep -i "stitch\|react:components"

# 3. Check other UI skills
# Look for frontend-design or similar installed skills
ls ~/.claude/commands/*design* 2>/dev/null
```

**Tool availability matrix:**
| Available | Auto Mode Behavior | Collab/Hackathon Behavior |
|-----------|-------------------|--------------------------|
| Stitch MCP | Use it automatically | Ask user: "Stitch MCP ili ručno?" |
| Stitch Skills (no MCP) | Generate spec → use react:components | Ask user preference |
| Neither | Generate spec → build from spec directly | Ask detailed UI questions → generate spec |

---

## Collab & Hackathon Mode: Interactive Design

### Step 1: Ask User Preference

```
"Backend je gotov, imam data shape. Za UI dizajn imam dve opcije:

A) Stitch MCP (automatski) — generišem ekrane kroz Stitch, dobijaš screenshots + HTML/CSS + React komponente
B) Ručni dizajn — pitam te sve o UI-u, generišem detaljan DESIGN-SPEC.md, pa ti dizajniraš u Stitch-u ili ja buildujemo direktno

Šta preferiraš?"
```

If Stitch MCP is NOT available, skip to Option B automatically but still ask the UI questions.

### Step 2 (Option B): Detailed UI Questions

Ask these questions **one group at a time** to build a complete picture:

**Group 1: Ekrani i Flow**
- Koji su glavni ekrani? (dashboard, lista, detalj, settings...)
- Kakav je user flow? (login → dashboard → [action] → result)
- Koliko ekrana ukupno za MVP?
- Ima li onboarding/wizard flow?

**Group 2: Vizuelni Identitet**
- Light mode, dark mode, ili oba?
- Kakav osećaj želiš? (clean/minimal, bold/vibrant, corporate/serious, playful/fun)
- Imaš li referentne sajtove koji ti se sviđaju? (daj 2-3 primera)
- Density: airy (puno belog prostora) ili compact (data-heavy)?

**Group 3: Layout i Navigacija**
- Sidebar navigacija ili top nav?
- Tabele, kartice, ili mix?
- Dashboard: čartovi/grafovi, metrike, lista, feed?
- Mobile-first ili desktop-first?

**Group 4: Specijalni Elementi**
- Ima li real-time elemenata? (live data, notifications)
- Ima li AI interfejs? (chat, suggestions, analysis panel)
- Trebaju li modali, draweri, toast notifikacije?
- File upload, drag & drop, rich text editor?

### Step 3: Generate Comprehensive DESIGN-SPEC.md

Based on user answers + `.hyper/brand.md`, generate `docs/DESIGN-SPEC.md` with:

1. **Color Palette** — All tokens with hex values from brand.md, plus semantic colors (error, warning, success, info)
2. **Typography Scale** — Complete hierarchy (H1-H6, body, small, caption, code) with sizes in px AND rem
3. **Spacing System** — 4px base grid, all tokens (xs: 4px, sm: 8px, md: 16px, lg: 24px, xl: 32px, 2xl: 48px)
4. **Screen Layouts** — For EACH screen:
   - Purpose and key user action
   - ASCII wireframe layout
   - Components used
   - Data displayed (from real API)
   - Loading/empty/error states
5. **User Flow Diagram** — Screen-to-screen navigation (text-based)
6. **Component Inventory** — Every component type with variants:
   - Buttons (primary, secondary, ghost, destructive, icon, loading)
   - Cards (default, hover, selected, with image, stats card)
   - Forms (input, select, checkbox, radio, toggle, date picker)
   - Tables (sortable, filterable, pagination, row actions)
   - Navigation (sidebar, top nav, breadcrumbs, tabs)
   - Feedback (toast, modal, drawer, alert, skeleton loader)
   - Charts (if dashboard: line, bar, pie, area — specify library)
7. **Interaction Patterns** — Hover, focus, active, disabled states with timing (150ms transitions)
8. **Mobile Adaptation** — Breakpoints, touch targets (44x44px min), responsive behavior per screen
9. **Design Principles** — 3-5 principles specific to this project (e.g., "data density over whitespace", "progressive disclosure")

### Step 4: Present for Approval (Decision Point 2)

Present DESIGN-SPEC.md to user:
- "Evo dizajn spec sa [N] ekrana. Pogledaj i daj feedback."
- User can: **Approve** → proceed to frontend build
- User can: **Modify** → update specific sections
- User can: **Open Stitch** → use stitch.withgoogle.com to design manually, bring back HTML/CSS

---

## Auto Mode: Smart Detection

In `/hp-auto`, NO questions — auto-detect and proceed:

```
1. Check: Stitch MCP available?
   YES → Use Stitch MCP (Option A) automatically
   NO  → Continue to step 2

2. Check: Stitch Skills installed? (react:components)
   YES → Generate DESIGN-SPEC.md → use react:components for component shells
   NO  → Continue to step 3

3. Fallback: Generate from spec
   → Generate DESIGN-SPEC.md from PLAN.md + brand.md
   → Generator builds components directly using Tailwind + design tokens
   → Evaluator visual audit (Phase C) is the quality gate
```

Auto mode infers UI answers from PLAN.md:
- Screens = features from sprint contract that have UI
- Flow = user stories from sprint contract
- Style = brand archetype (Sage → clean/corporate, Rebel → bold/dark, etc.)
- Layout = industry convention (SaaS dashboard → sidebar + top nav, data tables)

---

## Option A: Stitch MCP Workflow

If Stitch MCP is configured (`@_davideast/stitch-mcp proxy`):

1. Read PLAN.md features → generate prompts for each screen
2. Use Stitch MCP tools to generate screens
3. Use `get_screen_code` to extract HTML/CSS for each screen
4. Use `get_screen_image` for screenshot references
5. Extract design system into `.stitch/DESIGN.md`
6. Use `react:components` Stitch skill to generate React component shells

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

**Stitch Skills Reference:**
- `stitch-design` — Generate complete UI designs from text prompts
- `react:components` — Convert Stitch designs to React + Tailwind components
- Source: [github.com/google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills)

---

## DESIGN.md Format (Design Tokens)

Always generate `.stitch/DESIGN.md` regardless of workflow:

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
- Warning: #[hex]
- Info: #[hex]

## Typography
- Heading 1: [font], [size], [weight]
- Heading 2: [font], [size], [weight]
- Heading 3: [font], [size], [weight]
- Body: [font], [size], [weight]
- Small: [font], [size], [weight]
- Caption: [font], [size], [weight]
- Code: [font], [size], [weight]

## Spacing
- Base unit: 4px
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px
- 3xl: 64px

## Border Radius
- sm: 4px
- md: 8px
- lg: 12px
- xl: 16px
- full: 9999px

## Shadows
- sm: 0 1px 2px rgba(0,0,0,0.05)
- md: 0 4px 6px rgba(0,0,0,0.1)
- lg: 0 10px 15px rgba(0,0,0,0.15)

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

| Artifact | When Created |
|----------|-------------|
| `.stitch/DESIGN.md` | Always (design tokens) |
| `docs/DESIGN-SPEC.md` | Option B / auto fallback (full design spec with screen layouts) |
| Component shells in `apps/web/components/` | Option A with react:components |
| Screenshots in `docs/design/` | Option A with Stitch MCP |
