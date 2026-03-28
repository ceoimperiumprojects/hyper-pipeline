---
description: 'Generate CI/CD pipeline for the project. Auto-detects stack, creates GitHub Actions workflows for lint/test/build on PR and deploy on merge. Sets up the full automation pipeline.'
---

# /hp-ci — CI/CD Pipeline Setup

Automate everything — lint, test, build, deploy.

## Usage

```
/hp-ci                        # Auto-detect and generate
/hp-ci github-actions          # Force GitHub Actions
/hp-ci --with-deploy           # Include deploy step
```

## Flow

```
1. DETECT PROJECT
   🤖 Read package.json / requirements.txt / go.mod / Cargo.toml
   🤖 Identify:
      - Language: TypeScript, Python, Go, Rust
      - Framework: Next.js, Express, FastAPI, etc.
      - Test runner: Vitest, Jest, pytest, go test
      - Linter: ESLint, Ruff, golangci-lint
      - Build command: npm run build, etc.
      - Deploy target: Vercel, Railway, Docker

2. GENERATE WORKFLOWS
   🤖 Create .github/workflows/ci.yml:

   PR workflow (on pull_request):
   - Checkout
   - Setup Node/Python/Go
   - Install dependencies
   - Lint
   - Type check (tsc --noEmit)
   - Run tests
   - Build (verify it compiles)

   Deploy workflow (on push to main):
   - Same as PR workflow +
   - Deploy to production
   - Verify production is live

3. ENVIRONMENT SETUP
   🤖 Identify required env vars from .env / .env.example
   🤖 List which secrets need to be added to GitHub:
      "Add these secrets in Settings → Secrets → Actions:
       - DATABASE_URL
       - API_KEY
       - VERCEL_TOKEN (if deploying to Vercel)"

4. COMMIT
   🤖 git add .github/
   🤖 git commit -m "ci: add GitHub Actions workflow"
```

## Generated Workflow Template (Node/Next.js)

```yaml
name: CI
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
      - run: npm ci
      - run: npx tsc --noEmit
      - run: npm run lint
      - run: npm test
      - run: npm run build

  deploy:
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    needs: quality
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

## Rules

- CI must run on EVERY PR — no exceptions
- Tests must pass before merge — enforce branch protection
- Deploy only from main branch
- All secrets in GitHub Secrets, never in workflow file
- Cache dependencies (npm, pip) for speed
