---
name: hp-brand
description: Brand identity creation and multi-brand registry. Wizard with 12 archetypes, 10-color palette, typography, tone-of-voice. Hybrid storage — project-level + central registry.
---

# Brand Skill

Complete brand identity system with multi-brand management.

## When to Activate

- User mentions: brand, colors, fonts, identity, visual style, tone of voice
- `/hp-plan` needs brand context (auto-triggered)
- No `.hyper/brand.md` exists in project
- User wants to create/switch brand

## Brand Resolution

```
Priority:
1. .hyper/brand.md (in project root) → use it
2. ~/.hyper/brands/[name].md (central registry) → ask which one
3. Nothing exists → run Brand Wizard
```

## Brand Wizard (7 Steps)

Ask ONE section at a time. Don't dump all questions.

### Step 1: Company Basics
1. Company name
2. One-line description
3. Industry/vertical
4. Target audience (specific: role, size, demographics)
5. Core values (3-5)
6. Competitive positioning (how different)
7. Stage (idea/pre-seed/seed/Series A/growth)

### Step 2: Archetype Selection

Pick 1 primary + 1 secondary:

| Archetype | Core Drive | Voice | Examples |
|-----------|-----------|-------|----------|
| **Innovator** | Progress | Forward-thinking, confident | Tesla, Apple |
| **Sage** | Knowledge | Authoritative, educational | Google, Harvard |
| **Hero** | Mastery | Bold, empowering | Nike, FedEx |
| **Creator** | Originality | Imaginative, detail-obsessed | Adobe, Lego |
| **Explorer** | Freedom | Adventurous, daring | Patagonia, Jeep |
| **Ruler** | Control | Commanding, premium | Mercedes, Rolex |
| **Caregiver** | Service | Warm, trustworthy | TOMS, J&J |
| **Rebel** | Revolution | Provocative, fearless | Harley, Virgin |
| **Magician** | Transformation | Visionary, charismatic | Disney, Dyson |
| **Lover** | Connection | Elegant, passionate | Chanel, Godiva |
| **Jester** | Joy | Witty, playful | Old Spice, DSC |
| **Everyman** | Belonging | Genuine, honest | IKEA, Target |

### Step 3: Color Palette (10 colors)

| Slot | Role | Usage |
|------|------|-------|
| Primary | Main brand color | Logo, CTAs, key UI |
| Primary Dark | Darker shade | Hover, active, headers |
| Secondary | Complementary | Secondary buttons, highlights |
| Secondary Dark | Darker secondary | Secondary hover |
| Accent | Pop color | Notifications, alerts |
| Accent Alt | Alternative accent | Tags, labels, progress |
| Neutral 900 | Darkest | Body text, headings |
| Neutral 500 | Mid | Secondary text, borders |
| Neutral 200 | Light | Backgrounds, dividers |
| Neutral 50 | Lightest | Page bg, cards |

**Color psychology:**
- Blue = trust, stability (fintech, enterprise)
- Green = growth, health (healthtech, eco)
- Purple = premium, creative (AI, luxury)
- Red/Orange = energy, urgency (consumer, fitness)
- Black = luxury, power (premium)
- Teal = modern, fresh (SaaS, dev tools)

WCAG AA: text on bg must have 4.5:1 contrast.

### Step 4: Typography (3 fonts)

| Slot | Usage | Guidance |
|------|-------|---------|
| Heading | H1-H6, heroes | Personality carrier |
| Body | Paragraphs, UI | Readability first |
| Accent | Code, data | Monospace/distinctive |

**Sans-serif:** Inter, Plus Jakarta Sans, DM Sans, Outfit, Space Grotesk, Geist
**Serif:** Fraunces, Playfair Display, Lora, Newsreader
**Mono:** JetBrains Mono, Fira Code, Geist Mono

### Step 5: Mode
Light mode, dark mode, or both (with toggle)?

### Step 6: Voice Character (rate 1-10)

```
Formal    ←——————→ Casual     [1-10]
Technical ←——————→ Simple     [1-10]
Serious   ←——————→ Playful    [1-10]
Reserved  ←——————→ Bold       [1-10]
```

Generate Voice Summary: "Our voice is [adj], [adj], [adj]. We sound like [metaphor]."

### Step 7: Platform-Specific Tone

| Platform | Tone | Examples |
|----------|------|---------|
| Website | [from voice character] | |
| LinkedIn | [adapt for professional] | |
| Email | [adapt for direct comms] | |
| Product UI | [adapt for in-app] | |

## Output

Save to BOTH locations:
1. `.hyper/brand.md` — in project root
2. `~/.hyper/brands/[company-name].md` — central registry

All other skills (content, outreach, design, present) READ this file automatically.

## Logo Generation (Optional)

After brand identity is defined, generate a logo using chatgpt-py:

```bash
cd /home/pavle/Desktop/Projekti/chatgpt-py
chatgpt image "Minimalist, professional logo for [company name]. Industry: [industry]. Brand archetype: [primary archetype]. Style: clean, modern, scalable. Primary color: [hex]. Must work on white and dark backgrounds." --transparent --output logo.png
```

Generate variants:
- `logo.png` — full color on transparent
- `logo-dark.png` — version for dark backgrounds
- `logo-icon.png` — icon-only version (for favicon, app icon)

Resize for favicon: `ffmpeg -i logo-icon.png -vf scale=32:32 favicon.ico`

## Brand File Format

```markdown
# [Company Name] — Brand Identity

## Basics
- Name: [name]
- Tagline: [tagline]
- Industry: [industry]
- Target: [audience]
- Values: [values]
- Stage: [stage]

## Archetype
- Primary: [archetype]
- Secondary: [archetype]
- Mood: [description]

## Colors
| Slot | Hex | Usage |
|------|-----|-------|
| Primary | #XXXXXX | [usage] |
| ... | | |

## Typography
- Heading: [font]
- Body: [font]
- Accent: [font]

## Voice
- Formal/Casual: [X/10]
- Technical/Simple: [X/10]
- Serious/Playful: [X/10]
- Reserved/Bold: [X/10]
- Summary: "[voice summary]"

## Platform Tone
| Platform | Tone |
|----------|------|
| Website | [tone] |
| LinkedIn | [tone] |
| Email | [tone] |
```
