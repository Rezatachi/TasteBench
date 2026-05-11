# TasteBench X Thread Draft

## Short single-post version

I built TasteBench: a benchmark for whether AI coding agents can make product-quality app changes, not just code that builds.

Current results:
- 3 product/design tasks
- 3 agents tested
- 6/6 runs passed build + tests
- 1 run passed automation but failed human product review
- 14 simulator screenshots captured

The signal: build/test success is table stakes. Product taste shows up in copy, hierarchy, restraint, interaction feel, and design-system hygiene.

## Thread version

1/ I’ve been building TasteBench: a benchmark for AI coding agents as product builders, not just code generators.

The test app is Mira, a small SwiftUI journaling app. Agents get product/design tasks, then I score both objective code signals and subjective product taste.

2/ Current benchmark snapshot:

- 3 tasks
- 3 agents: Claude Code, Codex, Hermes
- 6 captured runs
- 5 scored runs
- 6/6 passed build + tests
- average human score: 20.6/24
- 14 simulator screenshots captured

3/ The important result: passing build/tests was not enough.

One Settings-screen run passed automation but was not shippable: padding issues, slow animations, and misaligned text.

That’s the gap TasteBench is trying to measure.

4/ Task 002 tested empty-state taste.

Both Codex and Hermes changed one file and passed automation.

Codex: 21.7/24, ship with polish
Hermes: 22.8/24, ship-ready

The difference was subtle: Hermes had calmer copy and more restrained hierarchy.

5/ Task 003 tested dark-mode fidelity.

Both agents passed build/tests and improved the app.

Codex: 23/24, ship-ready
Hermes: 20.5/24, ship with minor cleanup

The difference wasn’t “more code.” It was design-system hygiene.

6/ Codex won Task 003 because it centralized color decisions cleanly:

- 4 changed files
- 64 additions / 22 deletions
- 0 raw color heuristic hits
- 37 design-token refs
- 23/24 human score

7/ Hermes had one strong design-system idea — better shared dark-mode surface borders — but left mood colors as raw UIColor values outside the central color system.

The evaluator flagged 28 raw color usages.

That’s a real maintainability smell, not just a lint nit.

8/ My takeaway:

Coding-agent evals need separate lanes:

- Did it build?
- Did tests pass?
- Is the diff narrow?
- Is the implementation reviewable?
- Does it preserve product taste?

Most evals stop too early.

9/ TasteBench’s thesis:

The next useful coding-agent benchmarks won’t only ask “did the model solve the task?”

They’ll ask: did it preserve the product?

Copy, hierarchy, restraint, native feel, and design-system discipline are measurable — but not fully automatable.

10/ Next I’m adding more tasks around writing-flow polish, interaction details, and multi-step product persistence.

The goal is a portfolio-grade dashboard showing metrics, diffs, screenshots, and human review side by side.

## Suggested images to attach

1. Screenshot of reports/tastebench-dashboard.html hero + charts.
2. Task 003 Codex dark-mode screenshot grid.
3. Task 003 comparison report snippet showing 23/24 vs 20.5/24 and 0 vs 28 raw color usages.
4. Run matrix showing 6/6 build/tests passed but one human-blocked run.

## Strong hook alternatives

- “I don’t think coding-agent evals should stop at build passing.”
- “I built a benchmark for AI product taste.”
- “Two agents can pass tests and still differ meaningfully in product quality.”
- “The hardest part of evaluating coding agents isn’t code. It’s taste.”
