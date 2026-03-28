---
description: 'Debug and fix bugs with a structured workflow. Reproduces the bug, finds root cause, writes a failing test, fixes it, verifies nothing else broke. Use when something is broken and needs surgical fixing.'
---

# /hp-fix — Debug + Fix Bugs

Find it. Prove it. Fix it. Verify it.

## Usage

```
/hp-fix "login button doesn't respond when clicked"
/hp-fix "API returns 500 on POST /api/users with special characters"
/hp-fix "prices show NaN after currency conversion"
/hp-fix                    # Asks for bug description
```

## Flow

```
1. UNDERSTAND
   🤖 Read bug description
   🤖 Identify affected area (file, component, endpoint)
   🤖 Check recent git history for related changes (git log, git blame)

2. REPRODUCE
   🤖 Try to reproduce the bug:
      - If UI bug → Playwright MCP to navigate and click
      - If API bug → curl/fetch the endpoint
      - If logic bug → write a quick script that triggers it
   🤖 Capture exact error (stack trace, HTTP status, console error)

3. ROOT CAUSE
   🤖 Trace the error to source:
      - Stack trace → file:line
      - git blame on affected lines
      - Grep for related functions
      - Check recent changes to that file
   🤖 Document root cause in commit message

4. WRITE FAILING TEST
   🤖 Write a test that REPRODUCES the bug
   🤖 Run it — it MUST fail (proves the bug exists)
   🤖 This test becomes the regression guard

5. FIX
   🤖 Minimal change to fix the root cause
   🤖 Run the failing test — it MUST now pass
   🤖 Run ALL other tests — nothing else should break

6. VERIFY
   🤖 Run full test suite
   🤖 If UI bug → Playwright re-test the flow
   🤖 If API bug → curl the endpoint again
   🤖 Confirm fix works end-to-end

7. COMMIT
   🤖 git commit -m "fix: [description]

   Root cause: [what was wrong]
   Fix: [what was changed]
   Test: [test that guards against regression]"
```

## Rules

- ALWAYS reproduce before fixing (don't guess)
- ALWAYS write a test that catches the bug
- MINIMAL fix — don't refactor while fixing
- Run ALL tests after fix, not just the new one
- One bug per commit — atomic fixes
