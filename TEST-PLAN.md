# Hyper-Pipeline — End-to-End Test Plan

## Cilj
Proveriti da SVAKA tvrdnja iz LinkedIn posta i README-a ZAISTA radi.
Nijedna laž. Nijedna prečica. Sve mora raditi end-to-end.

---

## Test Projekat

**Spec:** Napraviti mali SaaS — npr. "URL shortener sa AI analytics"
- Dovoljno mali da se izgradi za par sati
- Dovoljno kompleksan da testira sve pipeline komponente
- Ima smisla za lead gen i content

---

## Checklist — Svaka stavka pojedinačno

### 1. ✅ Working App (backend → frontend → AI)

**Test:**
```
/hp-auto docs/SPEC.md
```

**Proverava:**
- [ ] Planner generiše PLAN.md sa svim sekcijama
- [ ] Planner generiše SPRINT-CONTRACT.md sa testable behaviors
- [ ] Generator gradi backend (API endpoints rade)
- [ ] Generator gradi frontend (UI renderuje)
- [ ] Generator integriše AI (Claude API radi)
- [ ] TDD: testovi napisani i prolaze
- [ ] Commit posle svake feature
- [ ] App se pokreće sa `npm run dev` bez errora
- [ ] Evaluator testira sa Playwright — EVAL-REPORT.md generisan
- [ ] Evaluator Visual Audit — screenshotovi pregledani multimodalno
- [ ] Fix loop radi — generator čita eval report i fiksuje bugove

**Hard pass kriterijum:** App radi end-to-end, korisnik može da koristi primary feature.

---

### 2. ✅ Brand Identity (colors, fonts, voice)

**Test:**
```
/hp-plan "URL shortener sa AI analytics"
# Proveriti da PLAN.md ima Brand Identity sekciju
```

**Proverava:**
- [ ] Brand wizard se pokreće (pita archetype, boje, fontove)
- [ ] 12 archetypes tabela prikazana
- [ ] 10-color palette generisana sa hex vrednostima
- [ ] Typography izabrana (heading, body, accent)
- [ ] Voice character (4 spectruma) definisan
- [ ] `.hyper/brand.md` fajl kreiran u projektu
- [ ] `~/.hyper/brands/[name].md` sačuvan u centralnom registru
- [ ] Svi ostali skillovi (content, present, design) ČITAJU brand.md

**Hard pass kriterijum:** brand.md postoji sa svim sekcijama, ostali skillovi ga koriste.

---

### 3. ✅ 500+ Qualified Leads (BANT scored)

**Test:**
```bash
# Korak 1: imperium-crawl scrape
imperium-crawl search --query "SaaS companies marketing tools" --count 20
imperium-crawl batch-scrape --urls "[URLs od rezultata]" --extraction-schema "extract company name, website, contact email, industry, employee count"

# Korak 2: Outreach skill qualification
# BANT scoring na scrape-ovanim podacima
```

**Proverava:**
- [ ] imperium-crawl search vraća rezultate
- [ ] imperium-crawl batch-scrape izvlači strukturirane podatke
- [ ] imperium-crawl ai-extract radi sa --schema "auto"
- [ ] Lead podaci imaju: ime, email/website, industrija
- [ ] BANT scoring primenjen (Budget, Authority, Need, Timeline)
- [ ] Leads filtrirani: hot (≥15), warm (10-14), cold (<10)
- [ ] Output sačuvan u CSV ili MD formatu
- [ ] Realan broj: možemo li zaista dobiti 500+ rezultata?

**Hard pass kriterijum:** Barem 100 realnih leadova scrape-ovano i BANT scored.
**Napomena:** Ako 500 nije realno za svaki query, promeniti tvrdnju u README.

---

### 4. ✅ Cold Email Sequences

**Test:**
```
# Outreach skill generiše sekvence
```

**Proverava:**
- [ ] 3-email sekvenca generisana (initial, follow-up, break-up)
- [ ] Personalizacija: svaki email referencira lead-specific podatke
- [ ] Subject lines < 60 chars, bez spam reči
- [ ] Body < 150 words
- [ ] Jedan CTA po emailu
- [ ] Trigger-based: koristi realan trigger (funding, hiring, tech stack)
- [ ] Ton matchuje brand.md voice character
- [ ] Fajlovi sačuvani u outreach/ direktorijumu

**Hard pass kriterijum:** 3 emaila koja bi realan čovek mogao da pošalje.

---

### 5. ✅ LinkedIn Posts with Branded Images

**Test:**
```
# Content skill generiše post + Remotion sliku
```

**Proverava:**
- [ ] Post copy generisan (hook, body, CTA, hashtags)
- [ ] Post prati jedan od 12 tipova (Story, Listicle, Hot Take, itd.)
- [ ] Hook je engaging (pattern-interrupt, curiosity, authority)
- [ ] Remotion projekat inicijalizovan
- [ ] Remotion komponenta kreirana sa brand bojama
- [ ] `npx remotion preview` — korisnik VIDI pre renderovanja
- [ ] `npx remotion still` — PNG renderovan (1080x1080 ili 1080x1350)
- [ ] Slika matchuje brand.md boje i fontove
- [ ] Visual audit: alignment, typography, contrast OK
- [ ] Post + slika su ready-to-publish

**Hard pass kriterijum:** LinkedIn post sa slikom koji izgleda profesionalno.

---

### 6. ✅ Landing Page (deployed)

**Test:**
```
# Generator pravi landing page + deploy na Vercel
```

**Proverava:**
- [ ] Landing page HTML/React generisan
- [ ] Hero sekcija sa value prop
- [ ] Features sekcija
- [ ] CTA dugme
- [ ] Responsive (mobile + desktop)
- [ ] Brand boje i fontovi primenjeni
- [ ] Deploy na Vercel: `npx vercel --prod`
- [ ] URL radi u browseru
- [ ] Visual audit: izgleda profesionalno, ne "AI slop"

**Hard pass kriterijum:** Živ URL koji izgleda kao pravi produkt.
**Napomena:** Treba Vercel account. Alternativa: Netlify, GitHub Pages.

---

### 7. ✅ Pitch Deck + Demo Video

**Test:**
```
/hp-present
```

**Proverava:**

**Pitch Deck:**
- [ ] 8-12 slideova generisano
- [ ] Remotion komponenta kreirana
- [ ] Preview u browseru — korisnik odobrava
- [ ] PNG renderovanje svake slide
- [ ] PDF generisan (`convert slide-*.png deck.pdf`)
- [ ] PPTX generisan (python-pptx)
- [ ] Slideovi su branded (brand.md boje)
- [ ] Sadržaj: Problem → Solution → How → Demo → Impact → CTA

**Demo Video:**
- [ ] Remotion video kompozicija kreirana
- [ ] App screenshots uključeni
- [ ] Text overlays objašnjavaju feature
- [ ] Smooth transitions
- [ ] 60-90 sekundi
- [ ] MP4 renderovan
- [ ] Video izgleda profesionalno

**Demo Script:**
- [ ] DEMO-SCRIPT.md generisan
- [ ] Tačan timing za svaki korak
- [ ] Fallback plan uključen

**Hard pass kriterijum:** PDF/PPTX deck sa branded slideovima + MP4 demo video.

---

## Bonus Testovi

### 8. Existing Project Support (/hp-go)

**Test:**
```
cd ~/Desktop/Projekti/simple-surplus
/hp-go "dodaj lead scoring feature"
```

**Proverava:**
- [ ] Codebase scan — prepoznaje FastAPI + SQLite
- [ ] Plan referencira existing patterns
- [ ] Reuse existing models i middleware
- [ ] Decision points jasni (plan review, eval review)

---

### 9. Hackathon Mode

**Test:**
```
/hp-auto --hackathon
```

**Proverava:**
- [ ] 8-faza timeline prikazan
- [ ] HACKATHON-CLAUDE.md generisan
- [ ] Phase 0 checklist sa MCP verifikacijom
- [ ] Brainstorm framework sa research support

---

### 10. Visual Validation (Evaluator)

**Test:**
```
/hp-eval
```

**Proverava:**
- [ ] Phase A: Static analysis (tsc, lint, console.log grep)
- [ ] Phase B: Playwright navigira app, klikće, testira
- [ ] Phase C: Claude GLEDA screenshotove multimodalno
- [ ] Phase D: 4 criteria scored (Functionality, Code Quality, Visual, Innovation)
- [ ] EVAL-REPORT.md generisan sa bugovima i preporukama
- [ ] Hard fail uslovi detektovani (ako postoje)

---

### 11. imperium-crawl Full Power

**Test svaki tool koji koristimo:**
```bash
# Search
imperium-crawl search --query "test" --count 5
imperium-crawl news-search --query "AI startups" --count 5
imperium-crawl image-search --query "dashboard UI" --count 5

# Scrape
imperium-crawl scrape --url "https://example.com"
imperium-crawl readability --url "https://news.ycombinator.com"
imperium-crawl ai-extract --url "https://example.com" --schema "auto"

# Social
imperium-crawl youtube --action search --query "AI coding tools"
imperium-crawl reddit --action search --query "Claude Code"

# Batch
imperium-crawl batch-scrape --urls "https://example.com,https://httpbin.org"

# Download
imperium-crawl download --url "https://example.com" --images
```

**Proverava:**
- [ ] Svaki tool vraća rezultate
- [ ] Stealth mode radi (--stealth-level 3)
- [ ] Batch scrape paralelno radi
- [ ] YouTube transcript radi
- [ ] Reddit posts radi

---

### 12. chatgpt-py

**Test:**
```bash
chatgpt status
chatgpt image "minimalist logo for URL shortener app, blue gradient, transparent background" -t -o logo.png
```

**Proverava:**
- [ ] Session aktivan
- [ ] Slika generisana
- [ ] Transparent background radi

---

### 13. Remotion

**Test:**
```bash
cd [remotion project]
npx remotion preview src/index.ts  # PREVIEW FIRST
npx remotion still src/index.ts [comp] output.png --scale 2
npx remotion render src/index.ts [comp] output.mp4
```

**Proverava:**
- [ ] Preview otvara browser
- [ ] Still renderuje PNG
- [ ] Render renderuje MP4
- [ ] Brand boje primenjene

---

## Test Protokol

### Pre-test:
1. Svež Claude Code sesija (čist kontekst)
2. Hyper-pipeline skill instaliran
3. Svi alati verifikovani (imperium-crawl, chatgpt-py, Remotion, Playwright)
4. Brave API key aktivan
5. Vercel CLI ulogovan

### Tokom testa:
1. Koristiti pravi spec fajl
2. NE intervenisati ručno — pustiti pipeline da radi
3. Dokumentovati svaki korak: šta je rađeno, šta je output, šta je puklo
4. Screenshot svaki output

### Posle testa:
1. Lista šta radi ✅ vs šta ne radi ❌
2. Za svako ❌: root cause + fix plan
3. Fix → re-test → push
4. Ažurirati README ako neka tvrdnja nije tačna

---

## Očekivani ishod

Posle testa imaćemo:
- **Realan projekat** izgrađen od nule sa hyper-pipeline
- **Dokaz** da svaka tvrdnja iz posta radi
- **Fixes** za sve što ne radi
- **Ažuriran README** sa istinitim tvrdnjama
- **Screenshotovi** svega za buduće postove

---

## Komanda za pokretanje testa

```bash
# Novi folder
mkdir ~/Desktop/hp-test && cd ~/Desktop/hp-test

# Spec fajl
cat > docs/SPEC.md << 'EOF'
Build a URL shortener with AI analytics.
Short links, click tracking, AI-powered insights about traffic patterns.
Target: marketing teams at SMBs.
Need: landing page, 3 LinkedIn posts, pitch deck.
EOF

# GO
/hp-auto docs/SPEC.md
```
