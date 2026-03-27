---
name: hp-validate
description: Startup idea validation framework — problem-solution fit, market sizing (TAM/SAM/SOM), competitive landscape, Mom Test interview questions, MVP scoping.
---

# Validate Skill

Comprehensive idea validation before building anything.

## When to Activate

- User mentions: validate, idea, MVP, problem-solution fit, is this worth building
- `/hp-auto` with new idea → validate first
- User unsure if idea has merit

## Validation Framework (6 Steps)

### Step 1: Problem Definition
- What SPECIFIC problem does this solve?
- Who has this problem? (be precise — not "everyone")
- How do they currently solve it? (workarounds = validation)
- How painful is it? (1-10, must be ≥ 7 for a startup)
- How often does it occur? (daily/weekly/monthly/yearly)

### Step 2: Market Sizing

| Metric | Definition | How to estimate |
|--------|-----------|----------------|
| **TAM** | Total Addressable Market | Everyone who COULD use this |
| **SAM** | Serviceable Available Market | Everyone you CAN reach |
| **SOM** | Serviceable Obtainable Market | Realistic first-year capture |

**Bottom-up method (preferred):**
```
# of potential customers × average revenue per customer = SAM
SAM × realistic capture rate (1-5%) = SOM
```

### Step 3: Competitive Landscape
- Who else exists? (use research skill)
- Why haven't they solved this?
- What's your unfair advantage?
- Can you be 10x better on ONE dimension?

### Step 4: Mom Test Questions
Questions that even your mom can't lie about:

**Good questions (facts, not opinions):**
- "Walk me through the last time you had this problem"
- "What did you try to solve it?"
- "How much time/money did that cost?"
- "What would happen if you never solved this?"
- "Are you currently paying for anything to help with this?"

**Bad questions (opinions, not facts):**
- ❌ "Would you use an app that does X?"
- ❌ "How much would you pay for this?"
- ❌ "Do you think this is a good idea?"

### Step 5: MVP Scoping
Define the absolute minimum:
- Core feature (ONE thing that solves the problem)
- Minimum UI (functional > beautiful)
- Timeline: what can ship in 2 weeks?
- What to EXCLUDE from MVP (list is more important than include list)

### Step 6: Go/No-Go Decision

| Signal | Go | Caution | No-Go |
|--------|-----|---------|-------|
| Problem severity | ≥ 8/10 | 6-7/10 | ≤ 5/10 |
| Current solutions | Bad workarounds | OK solutions exist | Good solution exists |
| Willingness to pay | "I'd pay today" | "Maybe" | "It's free elsewhere" |
| Market size (SOM) | > $1M/yr | $100K-$1M | < $100K |
| Competition | Weak/none | Moderate | Strong + funded |
| Your advantage | Clear + sustainable | Possible | None |

## Output

`docs/validation/`:
1. `problem-definition.md` — Problem statement and severity
2. `market-sizing.md` — TAM/SAM/SOM with methodology
3. `competitive-landscape.md` — Who else, gaps, advantages
4. `interview-guide.md` — Mom Test questions + templates
5. `mvp-scope.md` — What to build first
6. `go-no-go.md` — Decision matrix with recommendation
