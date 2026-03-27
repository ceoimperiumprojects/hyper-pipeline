---
name: hp-content
description: Content creation engine — LinkedIn viral posts (12 types, 50+ hooks), carousels (6 types), video content. All visuals via Remotion. Brand-aware — reads .hyper/brand.md.
---

# Content Skill

Create branded content for LinkedIn, carousels, and video. All visuals generated via Remotion.

## When to Activate

- User mentions: content, LinkedIn post, carousel, video, social media
- `/hp-auto` Sprint 4 (GTM) includes content
- User wants to create content for any platform

## Brand Loading

ALWAYS try to load brand identity. Resolution order:

```
1. .hyper/brand.md (project root) → use it
2. ~/.hyper/brands/*.md (central registry) → ask user which brand
3. Nothing found → use sensible defaults below, warn user
```

**Fallback defaults (when no brand exists):**
- Colors: Primary #2563EB, Secondary #10B981, BG #0F172A, Text #F8FAFC
- Fonts: Inter (body), Space Grotesk (heading), JetBrains Mono (accent)
- Voice: Professional, direct, moderately casual (6/10)
- Note in output: "⚠ No brand.md found — using defaults. Run brand wizard for custom identity."

Apply brand colors, fonts, tone to ALL outputs.

## LinkedIn Post Framework

### 12 Post Types

| Type | When to use | Structure |
|------|------------|-----------|
| **Story** | Personal experience | Hook → Context → Turning point → Lesson → CTA |
| **Listicle** | Tips, tools, resources | Hook → Numbered items → Wrap-up → CTA |
| **Hot Take** | Controversial opinion | Bold statement → Evidence → Nuance → CTA |
| **Tutorial** | How-to | Hook → Step-by-step → Result → CTA |
| **Case Study** | Client/project results | Problem → Solution → Results (numbers) → CTA |
| **Behind Scenes** | Process, journey | Hook → What happened → What I learned → CTA |
| **Data/Research** | Statistics, insights | Surprising stat → Context → Implications → CTA |
| **Question** | Engagement farming | Provocative question → Your take → Invite responses |
| **Announcement** | Launch, milestone | Big news → Why it matters → What's next → CTA |
| **Comparison** | X vs Y | Setup → Comparison → Winner → Why → CTA |
| **Prediction** | Future trends | Bold prediction → Evidence → Implications → CTA |
| **Failure** | What went wrong | Hook → What happened → What I'd do differently → CTA |

### 50+ Hook Templates

**Pattern-interrupt hooks:**
- "I [did unlikely thing]. Here's what happened:"
- "Stop [common practice]. Do this instead:"
- "Everyone says [belief]. They're wrong."
- "[Number] things I wish I knew about [topic]"

**Curiosity hooks:**
- "The #1 [thing] nobody talks about:"
- "I analyzed [X things]. Here's what I found:"
- "This [thing] changed everything for me:"

**Authority hooks:**
- "After [X years/projects], here's what I know:"
- "I've helped [X companies/people] [achieve Y]. Here's the pattern:"

### Algorithm Optimization
- First line = hook (most important)
- Line breaks every 1-2 sentences
- No external links in post (kills reach)
- 1200-1500 characters optimal
- Post image increases engagement 2x
- Carousel posts get 3x reach

### Visual Generation (3 options)

**Option 1: Remotion (default for branded templates)**
- Read post content → extract key stat/headline
- Apply brand colors and fonts from .hyper/brand.md
- Render via Remotion → PNG 1200x1200
- Best for: consistent branded visuals, batch generation

**Option 2: chatgpt-py (for unique illustrations)**
```bash
cd /home/pavle/Desktop/Projekti/chatgpt-py
chatgpt image "Create a professional illustration of [scene based on post content]. Style: [brand style]. Colors: [brand colors]." --output post-N.png
```
- Best for: custom scenes, illustrations, product mockups, conceptual visuals

**Option 3: imperium-crawl (for stock/real photos)**
```bash
imperium-crawl image-search --query "[relevant topic]" --count 10
imperium-crawl download --url "[best image URL]" --output content/
```
- Best for: real-world photos, screenshots of competitors, industry imagery

**Decision: Use Remotion for 80% of visuals (branded, fast, batch). chatgpt-py for hero/unique images. imperium-crawl for stock photos.**

Output: `content/post-[N]-image.png`

## Carousel Creation

### 6 Carousel Types

| Type | Slides | Best for |
|------|--------|---------|
| **Educational** | 7-10 | Teaching a concept step by step |
| **Listicle** | 5-8 | Tips, tools, resources |
| **Story** | 8-12 | Journey, case study narrative |
| **Comparison** | 6-8 | X vs Y, before/after |
| **Framework** | 5-7 | Introducing a methodology |
| **Data** | 6-10 | Research findings, statistics |

### Carousel Structure
1. **Cover slide** — Hook headline + visual
2. **Content slides** — One point per slide, large text
3. **Summary slide** — Key takeaway
4. **CTA slide** — Follow, share, comment

### Visual Generation (Remotion)
- Each slide as Remotion frame → PNG 1080x1350
- Consistent brand styling across all slides
- Progressive numbering (1/8, 2/8...)
- Output: `content/carousel-[name]/slide-01.png` through `slide-N.png`

## Video Content

### Video Types
| Type | Length | Use case |
|------|--------|---------|
| Product demo | 60-90s | Feature walkthrough |
| Explainer | 30-60s | Concept explanation |
| Social clip | 15-30s | LinkedIn/Twitter video |
| Tutorial | 2-5min | Step-by-step guide |

### Remotion Video Generation
- Combine screenshots + text overlays + transitions
- Brand colors and fonts throughout
- Output: `content/video-[name].mp4`

## Output Structure

```
content/
├── posts/
│   ├── post-1-copy.md          # Post text
│   ├── post-1-image.png        # Remotion visual
│   ├── post-2-copy.md
│   └── post-2-image.png
├── carousels/
│   ├── carousel-1/
│   │   ├── slides.md           # All slide content
│   │   ├── slide-01.png        # Remotion renders
│   │   └── slide-10.png
├── videos/
│   └── demo.mp4                # Remotion video
└── content-plan.md             # Publishing schedule
```
