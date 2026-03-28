---
description: 'Safe refactoring with test safety net. Scans codebase for issues, refactors incrementally, runs tests after each change, reverts if anything breaks. Use when code works but needs cleanup.'
---

# /hp-refactor — Safe Refactoring

Make it better without breaking it.

## Usage

```
/hp-refactor                              # Full codebase scan + refactor
/hp-refactor "extract auth logic into service"
/hp-refactor "split UserController into smaller files"
/hp-refactor src/services/               # Refactor specific directory
```

## Flow

```
1. BASELINE
   🤖 Run ALL existing tests → record pass count
   🤖 git stash any uncommitted changes
   🤖 Create refactor branch: git checkout -b refactor/[description]

2. SCAN
   🤖 Identify refactor targets:
      - Files > 300 lines → split candidates
      - Functions > 50 lines → extract candidates
      - Duplicated code → DRY candidates
      - Mixed concerns (route handler doing business logic + DB)
      - Dead code (unused exports, unreachable branches)
      - Inconsistent patterns (some files use X, others use Y)
   🤖 Prioritize by impact (most-touched files first)

3. REFACTOR (one change at a time)
   For each refactor:
   🤖 Make ONE targeted change
   🤖 Run ALL tests immediately
   🤖 If tests PASS → commit: "refactor: [what changed]"
   🤖 If tests FAIL → revert: git checkout -- [files]
   🤖 Move to next refactor

4. VERIFY
   🤖 Run full test suite → compare pass count to baseline
   🤖 Same or more tests passing = success
   🤖 Fewer tests passing = something broke, investigate

5. REPORT
   🤖 Summary of what was refactored
   🤖 Before/after metrics (file sizes, function counts)
   🤖 Any deferred refactors (too risky, need more tests first)
```

## Rules

- NEVER refactor without tests as safety net
- ONE change per commit — easy to revert
- Tests must pass after EVERY change
- If tests break → revert immediately, try different approach
- Don't add features while refactoring
- Don't fix bugs while refactoring (use /hp-fix for that)
- Feature branch — never refactor on main directly
