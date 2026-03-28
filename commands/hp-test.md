---
description: 'Add tests to untested code. Scans for gaps, prioritizes by risk, writes tests module by module. Use when codebase has low or no test coverage and needs hardening.'
---

# /hp-test — Add Test Coverage

Find what's untested. Test it. Harden it.

## Usage

```
/hp-test                              # Scan and test everything
/hp-test src/services/                # Test specific directory
/hp-test "add integration tests for all API endpoints"
/hp-test --coverage                   # Run with coverage report
```

## Flow

```
1. SCAN FOR GAPS
   🤖 Detect test framework (Jest, Vitest, pytest, Go test)
   🤖 Find all source files
   🤖 Find all existing test files
   🤖 Identify untested modules:
      - Source files with no corresponding test file
      - Exported functions with no test coverage
      - API endpoints with no integration test
      - Edge cases not covered (empty, null, boundary)

2. PRIORITIZE BY RISK
   Priority 1: Business logic (calculations, transformations, rules)
   Priority 2: API endpoints (request → response → side effects)
   Priority 3: Data access (queries, mutations, transactions)
   Priority 4: Utils and helpers
   Priority 5: UI components (interaction, state)

3. WRITE TESTS (module by module)
   For each untested module:
   🤖 Read the source code to understand behavior
   🤖 Write tests covering:
      - Happy path (normal input → expected output)
      - Edge cases (empty, null, zero, max, special chars)
      - Error cases (invalid input → proper error)
      - Boundary values (off-by-one, limit values)
   🤖 Run tests → must pass
   🤖 Commit: "test: add tests for [module]"

4. COVERAGE REPORT
   🤖 Run coverage: npx vitest --coverage / npx jest --coverage / pytest --cov
   🤖 Report: lines, branches, functions covered
   🤖 Identify remaining gaps
   🤖 Write docs/TEST-COVERAGE.md with results

5. INTEGRATION TESTS (if API exists)
   🤖 For each API endpoint:
      - Test happy path (valid request → correct response + DB state)
      - Test validation (invalid input → 400 + error message)
      - Test auth (no token → 401, bad token → 403)
      - Test not found (bad ID → 404)
      - Test edge cases (concurrent requests, large payloads)
```

## Test Quality Rules

- Tests must be READABLE — test name describes the scenario
- Tests must be INDEPENDENT — no shared state between tests
- Tests must use REALISTIC data — not "test", "foo", "bar"
- Tests must verify BEHAVIOR, not implementation details
- Each test tests ONE thing
- No flaky tests — if it sometimes fails, fix it
