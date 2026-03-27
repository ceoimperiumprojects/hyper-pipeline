---
name: pipeline-plan
description: Planning skill that expands short prompts into comprehensive specs with sprint contracts and testable acceptance criteria.
origin: hyper-pipeline
---

# Pipeline Plan

Transforms a 1-4 sentence description into a full product spec with testable sprint contracts.

## When to Activate

- User invokes `/hp-plan`
- User says "plan this", "spec this out", "what should we build"
- Starting any non-trivial feature or project

## Core Principle

From Anthropic's Harness Design research: "Without the planner, the generator under-scoped: given the raw prompt, it would start building without first speccing its work, and end up creating a less feature-rich application."

Planning is the highest-leverage phase. A 5-minute plan saves hours of wasted building.

## Process

### 1. Gather Context
```
Read existing codebase → Understand patterns → Identify reusable pieces
```
- Glob for project structure
- Grep for related functionality
- Read key config files (package.json, tsconfig, etc.)

### 2. Expand Requirements
```
Short prompt → Full feature list → Acceptance criteria → Sprint plan
```
- Be ambitious but realistic
- AI should be core, not decorative
- Every feature needs a testable "done" condition

### 3. Generate Artifacts

**docs/PLAN.md** contains:
- Product overview (3-5 sentences)
- Core features with priorities (P0/P1/P2)
- Architecture decisions with reasoning
- Sprint plan (2-3 sprints max)
- Innovation argument
- Demo script outline
- Risks & mitigations
- Success criteria (testable)

**docs/SPRINT-CONTRACT.md** contains:
- Per-sprint deliverables
- Testable behaviors in format: "User can [action] and sees [result]"
- API contracts: "POST /api/X accepts {input} returns {output}"
- Error states: "When [condition], user sees [message]"
- Hard fail conditions

### 4. User Review
Present plan and wait for approval. The user may:
- Approve as-is
- Request changes
- Add/remove features
- Change priorities

## Key Rules

1. **High-level, not granular** — Specify WHAT, not HOW
2. **Testable criteria** — Every feature must have a verifiable "done"
3. **UI timing** — Sprint 1 is backend. Design comes after. Sprint 2 is frontend+AI.
4. **Innovation angle** — Find where AI is the unlock, not a bolt-on
5. **Demo-first thinking** — If it can't be shown in 2 minutes, deprioritize
