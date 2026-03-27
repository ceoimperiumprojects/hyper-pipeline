---
name: hp-research
description: 9-phase competitive intelligence framework. Maps markets from zero to complete intel. Uses imperium-crawl for deep research (YouTube, Reddit, batch scraping) with WebSearch fallback.
---

# Research Skill

Systematic 9-phase framework for mapping ANY technology market from zero to complete competitive intelligence.

## When to Activate

- User mentions: research, competitors, competitive analysis, ecosystem, market map, gap analysis
- `/hp-plan` needs market context
- `/hp-auto` includes research in scope

## Auto Mode Research Scope

In `/hp-auto`, run **abbreviated research** to avoid context exhaustion:
- Phase 1: Ecosystem Mapping — top 5 competitors only (not 20)
- Phase 3: Feature Matrix — top 5 only
- Phase 7: Pricing Benchmark — quick scan
- Phase 9: Synthesis — 1-page summary
- **Total target: 10-15 min of research, not 2+ hours**
- Skip Phases 2, 4, 5, 6, 8 unless spec explicitly demands deep research

In `/hp-go` or standalone: run full 9-phase framework if user requests.

## Tool Selection

### Tier 1: Quick (always available)
- WebSearch for simple queries
- Good for 1-5 sources

### Tier 2: Deep (if imperium-crawl installed — 33 tools)
```bash
# Search (Brave API)
imperium-crawl search --query "..." --count 20              # Web search
imperium-crawl news-search --query "..." --freshness pw     # News (past week)
imperium-crawl image-search --query "..." --count 10        # Find images
imperium-crawl video-search --query "..." --count 10        # Find videos

# Scraping
imperium-crawl scrape --url URL --stealth-level 3           # Anti-bot sites
imperium-crawl readability --url URL                        # Clean article
imperium-crawl batch-scrape --urls "url1,url2" --concurrency 5  # Parallel!
imperium-crawl ai-extract --url URL --schema "auto"         # AI extraction

# Social Media (NO API key needed!)
imperium-crawl youtube --action search --query "..."        # YouTube search
imperium-crawl youtube --action transcript --url "..."      # Get transcript
imperium-crawl youtube --action channel --channel-url "..." # Channel analysis
imperium-crawl reddit --action search --query "..."         # Reddit search
imperium-crawl reddit --action posts --subreddit "startups" # Subreddit posts
imperium-crawl instagram --action search --query "..."      # IG search
imperium-crawl instagram --action profile --username "..."  # IG profile

# Media
imperium-crawl download --url URL --images --all            # Download media
imperium-crawl screenshot --url URL --full-page             # Page screenshot

# API Discovery
imperium-crawl discover-apis --url URL --wait-seconds 10    # Find hidden APIs

# Reusable Scrapers
imperium-crawl create-skill --url URL --name "NAME"         # Save scraper
imperium-crawl run-skill --name "NAME"                      # Run saved scraper
```

**CLI Gotchas:**
- Boolean flags: `--full-page` (no value) ✅
- JSON: single quotes `--schema '{"key":"val"}'`
- Batch URLs: `--urls "url1,url2"` (comma, quoted)
- Freshness: pd=day, pw=week, pm=month, py=year

## 9-Phase Framework

### Phase 1: Ecosystem Mapping (P0)
- Identify market center and leaders
- Map ALL competitors using 12 search strategies:
  1. Direct: "[category] software"
  2. Alternative: "[leader] alternatives"
  3. Review sites: "best [category] tools 2026"
  4. GitHub: "topic:[category]" sorted by stars
  5. Product Hunt: search category
  6. Reddit: "r/[industry] what do you use"
  7. Hacker News: search Show HN
  8. G2/Capterra: category listings
  9. Crunchbase: funding data
  10. LinkedIn: company search
  11. Regional: China/India/EU variants
  12. Niche: industry-specific directories

### Phase 2: Top 20 Deep Dive
- UI/UX screenshots of each competitor
- Demo video analysis (YouTube transcripts)
- Feature inventory per product

### Phase 3: Feature Matrix
- Build comparison table: rows=features, columns=competitors
- Identify table-stakes vs differentiators
- Find gaps no one fills

### Phase 4: User Sentiment
- Reddit threads, G2 reviews, Twitter mentions
- Common complaints = opportunities
- NPS indicators

### Phase 5: Technical Architecture
- Tech stack detection (Wappalyzer, BuiltWith)
- API documentation review
- Integration ecosystem

### Phase 6: Positioning Map
- Price vs feature completeness 2x2
- Target market segments

### Phase 7: Pricing Benchmark
- Extract pricing tiers from all competitors
- Free vs paid feature boundaries
- Price-to-value analysis

### Phase 8: Gap Analysis
- Features no one has
- Underserved segments
- Technical capability gaps

### Phase 9: Synthesis
- Final report with all deliverables
- Strategic recommendations
- Go/no-go assessment

## Output

10 deliverable documents saved to `docs/research/`:
1. Ecosystem Map
2. Competitor Profiles (top 20)
3. Feature Matrix
4. Demo Video Library
5. UI Pattern Analysis
6. Gap Analysis
7. User Sentiment Report
8. Pricing Benchmark
9. Technical Architecture Overview
10. Strategic Recommendations
