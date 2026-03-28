---
name: hp-peers
description: Generator↔Evaluator physical separation via Claude Peers MCP. Enables true Anthropic Harness Design — generator builds in one session, evaluator QAs in another, they communicate via instant messaging. The gold standard for avoiding self-evaluation bias.
origin: hyper-pipeline
---

# Peers Workflow — True Harness Separation

From Anthropic's paper: "Separating the agent doing the work from the agent judging it proves to be a strong lever."

Claude Peers MCP provides PHYSICAL separation — generator and evaluator run in different processes with different context windows. No shared bias.

## Prerequisites

Claude Peers MCP must be installed:
```bash
git clone https://github.com/louislva/claude-peers-mcp.git ~/claude-peers-mcp
cd ~/claude-peers-mcp && bun install
claude mcp add --scope user --transport stdio claude-peers -- bun ~/claude-peers-mcp/server.ts
```

Launch with channels:
```bash
claude --dangerously-skip-permissions --dangerously-load-development-channels server:claude-peers
```

## Architecture

```
            ┌─────────────────────────┐
            │  Broker Daemon          │
            │  localhost:7899 + SQLite │
            └─────┬──────────────┬────┘
                  │              │
            MCP Server A    MCP Server B
            (stdio)         (stdio)
                  │              │
            Claude A         Claude B
            GENERATOR        EVALUATOR
            (builds)         (judges)
```

## Workflow: /hp-auto with Peers

### Step 1: Detect Peers

At the start of /hp-auto, check if an evaluator peer is available:

```
list_peers → check for peer with summary containing "evaluator" or "QA"
If found → use peers workflow
If not found → fallback to single-session workflow
```

### Step 2: Generator Session (Terminal 1)

```
1. set_summary "HP Generator — building [project name]"
2. Run Planner phase:
   - Generate PLAN.md with Visual Design Language
   - Generate SPRINT-CONTRACT.md
   - Generate brand.md
3. Notify evaluator: send_message [evaluator_id] "Planning complete. Review SPRINT-CONTRACT.md"
4. Build features one at a time
5. After sprint complete:
   send_message [evaluator_id] "Sprint N complete. App running on localhost:PORT. Evaluate against docs/SPRINT-CONTRACT.md"
6. Wait for evaluator response (check_messages)
7. Read EVAL-REPORT.md
8. Strategic decision: REFINE or PIVOT
9. Fix issues from eval
10. Repeat 5-9 until evaluator sends PASS
11. Proceed to GTM phase
```

### Step 3: Evaluator Session (Terminal 2)

```
1. set_summary "HP Evaluator — skeptical QA, waiting for generator"
2. Load evaluator persona:
   - Read HARNESS-DESIGN.md for calibration examples
   - Read evaluator.md for grading criteria
   - Be SKEPTICAL by default
3. Wait for generator message (check_messages periodically)
4. On message "Sprint N complete, localhost:PORT":
   a. Read docs/SPRINT-CONTRACT.md
   b. Navigate app with Playwright MCP
   c. Screenshot every page
   d. Grade 4 criteria:
      - Design Quality (HIGH weight)
      - Originality (HIGH weight)
      - Backend Quality (API, tests, security, performance, architecture)
      - Functionality
   e. Write docs/EVAL-REPORT.md
   f. send_message [generator_id]:
      "FAIL — Visual Quality 4/10, Backend 7/10. Issues: [specific list]"
      OR
      "PASS — Score 34/40. Ship it."
5. Wait for next iteration
```

### Communication Protocol

Messages between generator and evaluator:

**Generator → Evaluator:**
- `PLAN_READY: Review docs/SPRINT-CONTRACT.md before I start building`
- `SPRINT_COMPLETE: Sprint N done. App on localhost:PORT. Evaluate.`
- `FIX_COMPLETE: Fixed N issues from EVAL-REPORT. Re-evaluate.`

**Evaluator → Generator:**
- `CONTRACT_APPROVED: Sprint contract looks good. Build.`
- `CONTRACT_REVISION: Add these behaviors: [list]`
- `EVAL_FAIL: Score X/40. Critical issues: [list]. Fix and re-submit.`
- `EVAL_PASS: Score X/40. Quality approved. Proceed.`

## Fallback: Without Peers

If Claude Peers MCP is not installed or no evaluator peer is found:
- Generator self-evaluates (current behavior)
- Less effective but still works
- Uses file-based communication (EVAL-REPORT.md)
- Apply extra skepticism in self-evaluation prompts

## When to Use Peers vs Single Session

| Scenario | Recommendation |
|----------|---------------|
| Complex app with UI | **Peers** — visual quality needs external judgment |
| Simple automation/script | Single session — evaluator overhead not worth it |
| Hackathon (time pressure) | Single session — faster, peers add latency |
| Production quality required | **Peers** — paper shows dramatically better results |
| Daily bug fix | Single session — /hp-fix doesn't need evaluator |

## MCP Tools Available

| Tool | What it does |
|------|-------------|
| `list_peers` | Find other Claude Code instances on this machine |
| `send_message` | Send instant message to a peer by ID |
| `set_summary` | Describe what you're working on (visible to peers) |
| `check_messages` | Check inbox for new messages |
