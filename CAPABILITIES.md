# Hyper-Pipeline — Capabilities Manifest

Pipeline agents READ this file to know what tools are available. Update when new tools are installed.

---

## imperium-crawl (33 tools)

**THE primary web tool. Use for ALL web operations.**

### Scraping (6 tools)
| Tool | Command | Use for |
|------|---------|---------|
| scrape | `imperium-crawl scrape --url URL` | Get page content (markdown/html) |
| crawl | `imperium-crawl crawl --url URL --max-depth 2` | Crawl entire site |
| map | `imperium-crawl map --url URL` | Discover all URLs on a site |
| extract | `imperium-crawl extract --url URL --selectors '{}'` | CSS-based data extraction |
| readability | `imperium-crawl readability --url URL` | Clean article text |
| screenshot | `imperium-crawl screenshot --url URL --full-page` | Page screenshot |

### Search (4 tools) — Brave API
| Tool | Command | Use for |
|------|---------|---------|
| search | `imperium-crawl search --query "..." --count 20` | Web search |
| news-search | `imperium-crawl news-search --query "..." --freshness pw` | News search |
| image-search | `imperium-crawl image-search --query "..." --count 10` | Find images |
| video-search | `imperium-crawl video-search --query "..." --count 10` | Find videos |

### AI Extraction (1 tool)
| Tool | Command | Use for |
|------|---------|---------|
| ai-extract | `imperium-crawl ai-extract --url URL --schema "auto"` | LLM-powered data extraction |

### Social Media (3 tools) — NO API key needed
| Tool | Command | Use for |
|------|---------|---------|
| youtube | `imperium-crawl youtube --action search/video/transcript/chapters/channel` | YouTube search, transcripts, channel analysis |
| reddit | `imperium-crawl reddit --action search/posts/comments/subreddit` | Reddit mining |
| instagram | `imperium-crawl instagram --action search/profile/discover` | Instagram profiles, influencer discovery |

### Media Download (1 tool)
| Tool | Command | Use for |
|------|---------|---------|
| download | `imperium-crawl download --url URL --images --all` | Download images/video from any page, YouTube, TikTok |

### RSS/Feeds (1 tool)
| Tool | Command | Use for |
|------|---------|---------|
| rss | `imperium-crawl rss --url URL --since 2026-01-01` | Read RSS/Atom feeds |

### API Discovery (3 tools)
| Tool | Command | Use for |
|------|---------|---------|
| discover-apis | `imperium-crawl discover-apis --url URL --wait-seconds 10` | Find hidden APIs |
| query-api | `imperium-crawl query-api --url URL --method GET` | Test discovered APIs |
| monitor-websocket | `imperium-crawl monitor-websocket --url URL --duration 30` | Monitor WebSocket traffic |

### Browser Interaction (2 tools)
| Tool | Command | Use for |
|------|---------|---------|
| interact | `imperium-crawl interact --url URL --actions '[...]'` | Click, type, navigate |
| snapshot | `imperium-crawl snapshot --url URL` | Get accessibility tree with refs |

### Batch Processing (4 tools)
| Tool | Command | Use for |
|------|---------|---------|
| batch-scrape | `imperium-crawl batch-scrape --urls "url1,url2" --concurrency 5` | Parallel scraping |
| list-jobs | `imperium-crawl list-jobs` | Check batch jobs |
| job-status | `imperium-crawl job-status --job-id ID` | Job progress |
| delete-job | `imperium-crawl delete-job --job-id ID` | Clean up |

### Skills (3 tools)
| Tool | Command | Use for |
|------|---------|---------|
| create-skill | `imperium-crawl create-skill --url URL --name NAME` | Create reusable scraper |
| run-skill | `imperium-crawl run-skill --name NAME` | Run saved scraper |
| list-skills | `imperium-crawl list-skills` | List saved scrapers |

### Knowledge (1 tool)
| Tool | Command | Use for |
|------|---------|---------|
| knowledge | `imperium-crawl knowledge --domain X --sort success_rate` | Check scraping stats per domain |

### CLI Gotchas
- Boolean flags: `--full-page` (no value) ✅ `--full-page true` ❌
- JSON params: single quotes `--selectors '{"key":"val"}'`
- Batch URLs: `--urls "url1,url2,url3"` (comma-separated, quoted)
- Freshness: `pd`=day, `pw`=week, `pm`=month, `py`=year
- Stealth: `--stealth-level 3` for anti-bot sites

---

## chatgpt-py (Image Generation)

**Generates images via ChatGPT web interface using Playwright automation.**

| Command | Use for |
|---------|---------|
| `chatgpt image "prompt" --output name.png` | Generate image from text prompt |
| `chatgpt image "prompt" --transparent` | Generate with transparent background |
| `chatgpt download --output name.png` | Download last generated image |

**GitHub:** [github.com/ceoimperiumprojects/chatgpt-py](https://github.com/ceoimperiumprojects/chatgpt-py)
**Install:** `git clone https://github.com/ceoimperiumprojects/chatgpt-py && cd chatgpt-py && pip install -e .`
**Output dir:** `~/Desktop/content/chatgpt-images/`

Use for: logos, branded illustrations, custom visuals, product mockups, social media images, app icons, favicons — when Remotion templates aren't enough.

---

## Brave Search API (via imperium-crawl)

Full search capabilities beyond web:

| Type | Command | Returns |
|------|---------|---------|
| **Web** | `imperium-crawl search --query "..."` | Web pages, descriptions, URLs |
| **News** | `imperium-crawl news-search --query "..." --freshness pd` | Latest news articles |
| **Images** | `imperium-crawl image-search --query "..."` | Image URLs, thumbnails |
| **Videos** | `imperium-crawl video-search --query "..."` | Video URLs, durations |

Freshness filters: `pd`=past day, `pw`=past week, `pm`=past month, `py`=past year

---

## Visual Generation Stack

| Tool | Best for | Output |
|------|----------|--------|
| **Remotion** | Branded templates, slides, carousels, demo videos | PNG/MP4 |
| **chatgpt-py** | Custom illustrations, unique visuals, complex scenes | PNG |
| **imperium-crawl image-search** | Finding existing stock images | URLs |
| **imperium-brain:find-images** | AI-curated image selection with visual review | Downloaded PNGs |
| **imperium-crawl download** | Download images/video from any URL | Files |
| **ffmpeg** | Audio/video processing, conversion, trimming | Various |

**Decision tree for visual generation:**
```
Need a LOGO?
  → chatgpt-py (with --transparent for PNG logo)
  → Prompt: "Minimalist logo for [brand]. Style: [archetype]. Colors: [from brand.md]"

Need a branded template (post, slide, card)?
  → Remotion

Need a unique illustration or custom scene?
  → chatgpt-py

Need an app icon / favicon?
  → chatgpt-py --transparent → resize with ffmpeg

Need stock/existing photos?
  → imperium-crawl image-search + download

Need to process/convert media?
  → ffmpeg
```

---

## Content & Transcription

| Tool | Use for |
|------|---------|
| **Whisper API** | Audio/video → text transcription (captions, subtitles) |
| **ffmpeg** | Extract audio, convert formats, trim, merge |
| **Remotion** | Programmatic video rendering |
| **chatgpt-py** | Image generation |

---

## MCP Servers

| Server | Use for |
|--------|---------|
| **playwright** | Browser automation for QA (evaluator) |
| **supabase** | Database management, auth, storage, edge functions |
| **obsidian** | Notes, tasks, project management — vault at ~/Obsidian/Imperium/ |
| **claude-peers** | Inter-session messaging for generator↔evaluator harness |
| **crawl4ai** | Alternative web fetching |
| **context7** | Live documentation lookup |
| **Figma** | Design file access |
| **stitch** | Google Stitch 2.0 UI design (when configured) |

---

## CLI Tools

| Tool | Location | Use for |
|------|----------|---------|
| node/npm/npx | /usr/bin/ | JavaScript runtime |
| python3/pip | /usr/bin/ | Python runtime |
| git | /usr/bin/ | Version control |
| gh | /usr/bin/ | GitHub CLI |
| docker | /usr/bin/ | Containerization |
| ffmpeg | /usr/bin/ | Media processing |
| playwright | npm global | Browser automation |
| pm2 | npm global | Process manager |
| pnpm | npm global | Package manager |
| agent-browser | npm global | AI browser agent |
| vercel | npm global | Vercel deploy (`vercel --prod`) |
| supabase | npx | Supabase CLI — DB, auth, storage, functions (`npx supabase`) |
| railway | npm global | Railway deploy |
| claude-peers | ~/claude-peers-mcp | Generator↔Evaluator peer messaging |
| openspace | ~/OpenSpace | Self-improving skills (autofix/autoimprove/autolearn) |
| obsidian-vault-cli | npm global | Obsidian vault management from CLI |
| mcp2cli | npm global | Convert MCP → CLI for 96-99% token savings |

---

## How Pipeline Uses This

Planner reads this file and selects tools per sprint:

```
Task: "Build ad monitoring platform with lead gen and content"

Sprint 1 (Backend):
  → Standard coding (no special tools)

Sprint 2 (Frontend + AI):
  → Stitch MCP or manual design
  → Claude API for AI features

Sprint 3 (Research + Leads):
  → imperium-crawl search (competitor research)
  → imperium-crawl batch-scrape (lead scraping)
  → imperium-crawl youtube (competitor demo videos)

Sprint 4 (Content + GTM):
  → Remotion (LinkedIn images, carousel, demo video)
  → chatgpt-py (custom illustrations for landing page)
  → imperium-crawl image-search (stock photos)
  → imperium-crawl news-search (industry news for content)
  → Whisper (if video content needs captions)
  → ffmpeg (video processing)
```
