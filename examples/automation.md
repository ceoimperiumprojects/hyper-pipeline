# Example: n8n Automation Workflow

Scenario: CoGrader Revenue Ops — build a lead enrichment workflow.

```
You: /hp-auto "Build n8n workflow: webhook receives new HubSpot contact →
      enrich with Clearbit → score lead (BANT) → if hot lead →
      create task in HubSpot → notify Slack channel"

🤖 PLAN
   PLAN.md:
   - 5 n8n nodes: Webhook → HTTP (Clearbit) → Code (scoring) → HubSpot → Slack
   - Error handling on each node (retry + fallback)
   - Test with sample webhook payload
   - Sprint contract: 8 testable behaviors

🤖 BUILD
   - n8n workflow JSON exported
   - Code node: BANT scoring logic (Budget 1-5, Authority 1-5, Need 1-5, Timeline 1-5)
   - Error handling: if Clearbit fails → skip enrichment, still score
   - If HubSpot fails → log to error queue, retry in 5min
   - Test data: 3 sample contacts (hot/warm/cold)

🤖 EVAL
   Backend Quality: 8/10
   - Code node has proper error handling ✓
   - Scoring logic tested with edge cases ✓
   - Retry logic on external APIs ✓
   - No hardcoded API keys ✓

🤖 DONE
   - Workflow JSON ready for n8n import
   - docs/API.md with webhook payload schema
   - Test results documented
   Total: ~30 min
```
