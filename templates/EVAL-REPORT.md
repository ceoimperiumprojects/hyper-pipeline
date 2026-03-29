# Evaluation Report — Sprint [N] (Round [R]/3)

**Date:** [date]
**Evaluator:** pipeline-evaluator (Opus ultrathink)
**App URL:** [URL]
**Harness Round:** [1/2/3] of max 3

## Overall: [PASS / FAIL] — Score: [X/50]

## Hard Fail Check

| Check | Result | Notes |
|-------|--------|-------|
| App runs without crashes | PASS/FAIL | |
| Primary feature works E2E | PASS/FAIL | |
| AI features handle errors | PASS/FAIL | |
| UI renders on desktop | PASS/FAIL | |
| Data persists correctly | PASS/FAIL | |
| Visual Quality ≥ 7 | PASS/FAIL | Score: X/10 |
| Backend Quality ≥ 5 | PASS/FAIL | Score: X/10 |
| No AI slop patterns | PASS/FAIL | |
| Framework not identifiable | PASS/FAIL | |
| Tests exist for business logic | PASS/FAIL | |
| No secrets in code | PASS/FAIL | |
| Input validation on endpoints | PASS/FAIL | |

**Hard fail triggered:** [Yes/No — which one]

## Sprint Contract Verification

| # | Testable Behavior | Result | Notes |
|---|-------------------|--------|-------|
| 1 | [from contract] | PASS/FAIL | [specific details] |
| 2 | [from contract] | PASS/FAIL | [specific details] |

**Contract pass rate:** [X/Y] behaviors passing

## Backend Quality (Anthropic Harness Standard)

| Sub-Criterion | Score | Details |
|--------------|-------|---------|
| API Design | X/2 | [RESTful? validation? error format? status codes?] |
| Test Coverage | X/2 | [unit? integration? edge cases? realistic data?] |
| Security | X/2 | [no secrets? sanitization? auth? CORS?] |
| Performance | X/2 | [indexed? no N+1? paginated? async?] |
| Architecture | X/2 | [separation? error middleware? env config? migrations?] |
| **Total** | **X/10** | |

## Visual Quality (Anthropic 4 Criteria)

| Criterion | Score | Details |
|-----------|-------|---------|
| Design Quality | X/10 | [cohesive whole? distinct mood? identity?] |
| Originality | X/10 | [custom decisions? NOT template/library defaults?] |
| Craft | X/10 | [typography hierarchy? spacing? color harmony? contrast?] |
| Functionality | X/10 | [users understand? find actions? complete tasks?] |

**Dribbble Test:** [PASS — would get engagement / FAIL — generic]
**Framework Test:** [PASS — not identifiable / FAIL — recognizably shadcn/tailwind]

## Visual Audit Findings

| # | Screen | Issue | Fix |
|---|--------|-------|-----|
| 1 | [page] | [specific visual issue] | [specific CSS/component fix] |

## Bugs Found

| # | Severity | Description | Reproduction Steps | Suggested Fix |
|---|----------|-------------|-------------------|---------------|
| 1 | Critical | [desc] | 1. Go to... 2. Click... 3. See... | [with file:line ref] |
| 2 | Major | [desc] | 1. ... | [suggestion] |

## Strategic Recommendation for Generator

**Decision:** [REFINE / PIVOT]
**Reasoning:** [scores trending up → refine / flat → pivot to different approach]
**Specific actions for next round:**
1. [action with file reference]
2. [action with file reference]
3. [action with file reference]

## Edge Cases Tested

| Test | Result | Notes |
|------|--------|-------|
| Empty input | PASS/FAIL | |
| Very long input | PASS/FAIL | |
| Special characters | PASS/FAIL | |
| Mobile viewport (375px) | PASS/FAIL | |
| Rapid double-click | PASS/FAIL | |
| Unauthorized access | PASS/FAIL | |
| Invalid ID in URL | PASS/FAIL | |
| Concurrent requests | PASS/FAIL | |
