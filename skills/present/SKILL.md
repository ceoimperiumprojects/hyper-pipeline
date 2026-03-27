---
name: hp-present
description: Remotion-first visual engine for ALL visual outputs — LinkedIn images, carousels, demo videos, slides, product screenshots, pitch decks. Exports PNG, MP4, PPTX. Reads .hyper/brand.md for consistency.
origin: hyper-pipeline
---

# Present — Remotion Visual Engine

Creates ALL visual outputs using Remotion as the default rendering engine.

## When to Activate

- User invokes `/hp-present`
- Hackathon mode, Phase 7
- When LinkedIn content needs images/carousels
- When any visual output is needed
- When imperium-brain:linkedin or content skill generates a post → this creates the image

## Prerequisites

**Remotion must be initialized in the project:**
```bash
# Initialize Remotion project (one-time)
npx create-video@latest --template=blank

# Or use existing Remotion project if available
# Check: ls src/index.ts remotion.config.ts
```

If no Remotion project exists, fall back to:
1. chatgpt-py for individual images
2. python-pptx for PPTX slides
3. HTML for presentations

## Remotion Output Types

| Output | Component | Size | Export | Command |
|--------|-----------|------|--------|---------|
| LinkedIn post image | `LinkedInPost.tsx` | 1080x1080 | PNG | `npx remotion still src/index.ts LinkedInPost out.png --scale 2` |
| LinkedIn carousel | `CarouselSlide.tsx` | 1080x1080 | PNG series | `npx remotion still ... --frame N` per slide |
| Demo video | `DemoVideo.tsx` | 1920x1080 | MP4 | `npx remotion render src/index.ts DemoVideo out.mp4` |
| Presentation | `PitchSlide.tsx` | 1920x1080 | PNG/MP4/PPTX | Render frames → convert |
| Product screenshot | `ProductFrame.tsx` | 2400x1600 | PNG | Still render |
| OG / social image | `OGImage.tsx` | 1200x630 | PNG | Still render |

## Remotion Workflow

### Step 1: Check Remotion Setup
```bash
# Check if Remotion project exists
ls remotion.config.ts src/index.ts 2>/dev/null
# If not: npx create-video@latest --template=blank
```

### Step 2: Create Composition
Write a React component for the visual output:
```tsx
// src/MyVisual.tsx
import { AbsoluteFill } from 'remotion';

export const MyVisual: React.FC = () => (
  <AbsoluteFill style={{ background: '#0a0a0f' }}>
    {/* Read .hyper/brand.md colors */}
    {/* Layout content */}
  </AbsoluteFill>
);
```

### Step 3: Register in Root.tsx
```tsx
<Composition
  id="MyVisual"
  component={MyVisual}
  width={1080}
  height={1080}
  durationInFrames={1}
  fps={30}
/>
```

### Step 4: Preview FIRST (ALWAYS)
```bash
npx remotion preview src/index.ts
# User looks at it in browser, gives feedback
# NEVER render without preview
```

### Step 5: Render (after approval)
```bash
# Still image (PNG)
npx remotion still src/index.ts MyVisual output.png --scale 2

# Video (MP4)
npx remotion render src/index.ts MyVisual output.mp4

# Carousel (multiple frames)
for i in $(seq 0 7); do
  npx remotion still src/index.ts Carousel slide-$i.png --frame $i --scale 2
done

# Convert to PDF (for LinkedIn carousel upload)
convert slide-*.png carousel.pdf
```

### Step 6: PPTX Export
```bash
# Render all slides as PNGs first, then:
python3 -c "
from pptx import Presentation
from pptx.util import Inches
import glob

prs = Presentation()
prs.slide_width = Inches(10)
prs.slide_height = Inches(10)

for img in sorted(glob.glob('slide-*.png')):
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    slide.shapes.add_picture(img, 0, 0, prs.slide_width, prs.slide_height)

prs.save('carousel.pptx')
"
```

## Brand Integration

ALL Remotion compositions MUST read `.hyper/brand.md` for:
- Color palette → backgrounds, accents, text colors
- Typography → font family, sizes, weights
- Archetype → visual mood and feel
- Apply WCAG AA contrast (4.5:1 minimum)

## LinkedIn Post Images

When content skill generates a post:
1. Read post copy → extract key stat/headline
2. Create Remotion component with brand colors
3. **Preview first** → user approves
4. Render to PNG 1080x1080 at 2x scale
5. Output: `content/post-N-image.png`

## Carousel Generation

1. Create data file with slide content (heading, body, bullets, codeBlock, checklist)
2. Create carousel component (one frame per slide)
3. **Preview first** → user checks all slides
4. Render PNG series
5. Convert to PDF: `convert slide-*.png carousel.pdf`

## Demo Video

1. Capture app screenshots at key interaction points
2. Create Remotion sequence with transitions, text overlays, zoom
3. **Preview first**
4. Render to MP4 (60-90s)

## Presentation Slides

1. Create slide data (12-15 slides for 5 min)
2. Build Remotion composition
3. **Preview first**
4. Export as: PNG series + PDF + PPTX + optionally MP4

## Fallbacks (if Remotion not available)

| Need | Fallback |
|------|----------|
| LinkedIn image | chatgpt-py → `chatgpt image "..." -o post.png` |
| Carousel | python-pptx (imperium-brain:carousel cookbook) |
| Presentation | HTML single file (zero-dep) |
| Demo video | Screen recording + ffmpeg |

## Key Rules

1. **ALWAYS preview before render** — `npx remotion preview` first
2. **Read brand.md** — every visual must be on-brand
3. **2x scale for stills** — `--scale 2` for crisp output
4. **PDF for LinkedIn** — convert PNG series to PDF for carousel upload
5. **Fallback gracefully** — if Remotion not set up, use alternatives
