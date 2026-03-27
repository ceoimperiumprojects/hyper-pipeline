---
name: hp-outreach
description: B2B outreach engine — cold email sequences (34 templates, 137 sales triggers), lead scraping via imperium-crawl, lead qualification (BANT/MEDDIC), follow-up cadences.
---

# Outreach Skill

Cold email campaigns, lead generation, and sales pipeline building.

## When to Activate

- User mentions: outreach, cold email, leads, sales, pipeline, prospecting
- `/hp-auto` Sprint 4 (GTM) includes outreach
- User needs to find and contact potential customers

## Lead Generation

### Tool Check

Before starting lead gen, check which tools are available:

```bash
which imperium-crawl 2>/dev/null && echo "imperium-crawl: AVAILABLE" || echo "imperium-crawl: NOT INSTALLED"
```

**If imperium-crawl is NOT installed**, use these fallbacks:
1. **WebSearch** — `WebSearch` tool for finding company directories and contact info
2. **Manual sources** — Ask user for existing lead lists (CSV, CRM export, LinkedIn Sales Navigator export)
3. **Public directories** — Guide user to APR.rs, Infostud, LinkedIn company search
4. **Note in output:** "⚠ imperium-crawl not available — leads sourced via web search. Install `npm i -g imperium-crawl` for automated bulk scraping."

### Using imperium-crawl
```bash
# Search for potential leads
imperium-crawl search --query "[industry] [location] companies" --count 20

# Scrape company data
imperium-crawl batch-scrape --urls "company1.com,company2.com" \
  --extraction-schema "extract company name, contact email, industry, size, key person"

# Extract from directories
imperium-crawl ai-extract --url "https://directory.example.com" \
  --schema '{"companies": [{"name": "string", "email": "string", "industry": "string"}]}'

# LinkedIn research
imperium-crawl search --query "site:linkedin.com [title] [company]" --count 10
```

### Lead Qualification (BANT)
| Criterion | Question | Score |
|-----------|---------|-------|
| **Budget** | Can they afford this? | 1-5 |
| **Authority** | Is this the decision maker? | 1-5 |
| **Need** | Do they have the problem we solve? | 1-5 |
| **Timeline** | Are they looking now? | 1-5 |

Score ≥ 15 = hot lead. Score 10-14 = warm. Score < 10 = cold.

## Cold Email Framework

### 137 Sales Triggers (categories)
1. **Funding trigger** — Company just raised money → needs tools to scale
2. **Hiring trigger** — Hiring for [role] → means they're building that function
3. **Tech trigger** — Using [competitor] → potential switch
4. **Growth trigger** — Revenue milestone → needs optimization
5. **Pain trigger** — Public complaint → they need a solution
6. **Event trigger** — Speaking at conference → warm intro opportunity
7. **Content trigger** — Published about [topic] → thought leader connection
8. **Job change** — New VP/Director → bringing new tools

### Email Sequence Structure (3-email)

**Email 1: Initial Outreach**
```
Subject: [Trigger-based, personalized]

[Name],

[Observation about their company — 1 sentence, shows research]

[Bridge to your solution — 1-2 sentences]

[Value prop — what they get, not what you sell]

[Soft CTA — question, not "book a call"]

[Signature]
```

**Email 2: Follow-up (3 days later)**
```
Subject: Re: [original subject]

[Name],

[New angle or additional value — different from Email 1]

[Social proof — "We helped [similar company] achieve [result]"]

[CTA — slightly more direct]
```

**Email 3: Break-up (5 days later)**
```
Subject: [Name] — should I close your file?

[Name],

[Acknowledge they're busy — 1 sentence]

[Final value point — most compelling]

[Permission-based close: "Should I stop reaching out?"]
```

### Personalization Framework
For each lead, research and include:
1. **Company-specific:** Recent news, funding, product launch
2. **Person-specific:** LinkedIn post, conference talk, article
3. **Industry-specific:** Trend, challenge, regulation
4. **Trigger-specific:** Why NOW is the right time

### Email Rules
- Subject line < 60 chars, no caps, no spam words
- Body < 150 words
- One CTA per email
- No attachments in cold email
- Personalization in first line (not just {name})
- Send Tuesday-Thursday, 8-10am recipient timezone

## Output

```
outreach/
├── leads/
│   ├── raw-leads.csv              # Scraped data
│   ├── qualified-leads.csv        # BANT scored
│   └── lead-research/             # Per-lead research notes
├── sequences/
│   ├── sequence-1/
│   │   ├── email-1.md             # Initial outreach
│   │   ├── email-2.md             # Follow-up
│   │   └── email-3.md             # Break-up
│   └── sequence-2/
├── templates/
│   └── trigger-templates.md       # Reusable templates by trigger
└── outreach-plan.md               # Who, when, what sequence
```
