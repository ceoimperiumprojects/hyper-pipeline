# Pipeline Core Rules

These rules apply to ALL pipeline modes (daily and hackathon).

## Workflow Rules

1. **Plan before build** — Never start coding without `docs/PLAN.md` and `docs/SPRINT-CONTRACT.md`
2. **Feature by feature** — Build one feature at a time, commit each, never batch
3. **45-minute rule** — If a feature isn't working in 45 min, simplify or cut. Log in `docs/BLOCKERS.md`
4. **Never break the build** — App must be runnable after every commit
5. **Evaluate, don't assume** — Use the Evaluator to verify quality. Self-praise is unreliable.
6. **State on disk** — All important state goes in docs/ files, never only in context

## Agent Rules

7. **Planner is high-level** — Specify WHAT, not HOW. Granular tech details cascade errors.
8. **Generator self-evaluates** — Check your own work before handing off to Evaluator
9. **Evaluator is skeptical** — Never rationalize bugs away. If it's broken, it's broken.
10. **Max 3 eval iterations** — Prevent infinite fix-eval loops

## Code Quality

11. **No console.log** — Use proper logging or remove debug statements
12. **No lorem ipsum** — Real or realistic data only
13. **Error handling** — Every async operation needs error handling
14. **Loading states** — Every async UI operation needs a loading indicator
15. **Mobile-responsive** — Build responsive from the start, not as afterthought

## UI Quality (Anthropic Harness Design Standard)

16. **No default framework styling** — Default shadcn/ui, Bootstrap, or any component library with zero customization is NEVER acceptable. Always customize beyond defaults.
17. **Every screen must be distinctive** — Not recognizable as generic framework output. Apply Uncodixfy skill on every frontend build.
18. **Bold aesthetic direction required** — Apply frontend-design skill. Every UI needs a clear conceptual direction — NOT "clean and modern" (meaningless AI slop).
19. **Screenshot self-evaluation** — After building UI, take screenshot via Playwright and ask: "Would this get engagement on Dribbble? Can I tell which framework built this?" If either fails, iterate.
20. **Visual Quality iteration loop** — If evaluator scores Visual Quality below 7, generator MUST iterate on UI (up to 5 rounds). Single-pass UI generation is NOT acceptable for production output.

## Git Discipline

21. **Conventional commits** — feat:, fix:, refactor:, docs:, test:
22. **One feature per commit** — Atomic, revertable changes
23. **Never force push** — Use revert if needed
24. **Tag milestones** — Tag at sprint completion: v0.1, v0.2, v1.0

## Context Management

25. **Strategic compaction** — Compact at phase transitions, not mid-feature
26. **Re-read docs/ after compaction** — State is in files, restore it
27. **Keep 20%+ context headroom** — Don't fill the context window
