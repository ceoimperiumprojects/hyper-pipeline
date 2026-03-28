---
description: 'Deploy app to production. Auto-detects platform (Vercel, Railway, Netlify, Docker, static). Runs build + tests first, deploys, verifies live, logs URL. Use after /hp-build or /hp-auto completes.'
---

# /hp-deploy — Deploy to Production

Build, verify, deploy, confirm it's live.

## Usage

```
/hp-deploy                    # Auto-detect platform
/hp-deploy vercel             # Force Vercel
/hp-deploy railway            # Force Railway
/hp-deploy static             # Static HTML (landing pages)
/hp-deploy docker user@host   # Docker + SSH to VPS
```

## Flow

```
1. PRE-FLIGHT
   🤖 npm run build (must pass)
   🤖 npm test (must pass — no deploying broken code)
   🤖 Check .env.production exists (warn if missing)
   🤖 Check no secrets in code (grep for hardcoded keys)

2. DETECT PLATFORM
   🤖 vercel.json exists? → Vercel
   🤖 railway.toml exists? → Railway
   🤖 netlify.toml exists? → Netlify
   🤖 Dockerfile exists? → Docker
   🤖 Single HTML file? → Static (Vercel/Netlify)
   🤖 Nothing detected? → Ask user or default to Vercel

3. DEPLOY
   Vercel:   npx vercel --prod
   Railway:  railway up
   Netlify:  npx netlify deploy --prod --dir=out
   Docker:   docker build → docker push → ssh deploy
   Static:   npx vercel --prod (single file)

4. VERIFY
   🤖 curl production URL — expect 200
   🤖 Check critical pages load
   🤖 Screenshot production with Playwright (optional)

5. LOG
   🤖 Write docs/DEPLOY-LOG.md:
      - URL: [production URL]
      - Platform: [vercel/railway/etc]
      - Deployed at: [timestamp]
      - Git commit: [hash]
      - Build status: PASS
      - Tests status: PASS
      - Verified: [curl result]
```

## Platform-Specific Setup

### Vercel (recommended for Next.js)
```bash
# First time
npx vercel link
# Deploy
npx vercel --prod
```

### Railway
```bash
# First time
railway login && railway link
# Deploy
railway up
```

### Docker + VPS
```bash
# Build
docker build -t [app-name] .
# Push to registry
docker push [registry]/[app-name]
# SSH deploy
ssh user@host "docker pull [registry]/[app-name] && docker-compose up -d"
```

### Static (Landing Pages)
```bash
# Deploy single HTML to Vercel
npx vercel --prod landing.html
# Or Netlify
npx netlify deploy --prod --dir=.
```

## Rules

- NEVER deploy without build passing
- NEVER deploy without tests passing
- NEVER deploy with secrets in code
- ALWAYS verify production is live after deploy
- ALWAYS log deployment in DEPLOY-LOG.md
- If deploy fails → diagnose, fix, retry (max 3 attempts)
