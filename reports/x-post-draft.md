# X.com Post Draft — TasteBench Early Findings

1/ I’m building TasteBench: a small benchmark for evaluating AI coding agents as product builders, not just code generators.

The first target app is Mira, a calm SwiftUI journaling app. Agents make product changes; the harness captures build/test/diff signals; then I do human product review.

2/ Early finding: build + tests passing is not enough.

One Settings-screen run passed automation:
- build passed
- tests passed
- no raw colors
- strong design-token usage

But human review blocked shipping because the result had spacing issues, slow-feeling motion, and misaligned text.

3/ That is the gap I want TasteBench to measure.

Normal coding evals ask: “Did it work?”
Product evals also ask:
- Does it feel like the same app?
- Is the copy right?
- Is the hierarchy calm?
- Is the interaction native?
- Would a PM/designer ship this?

4/ Task 002 tested a non-happy path: an empty Journal state.

Codex and Hermes both passed automation and changed one file.

But the human review still found taste differences: the more restrained implementation, with calmer copy and less constructed hierarchy, scored higher.

5/ Current snapshot:
- 4 runs captured
- 3 human-scored runs
- 4/4 build + test pass
- 1 run passed automation but was blocked by human product review

That single mismatch is the point: product quality needs explicit evaluation language.

6/ My thesis: the next useful agent benchmarks won’t only measure SWE completion.

They’ll measure product judgment:
- taste under constraints
- preservation of design intent
- reviewability
- restraint
- whether the diff is actually shippable

7/ This is also the kind of evaluation loop I think AI PMs will own:

Define the product bar, create realistic tasks, separate objective automation from subjective review, and turn qualitative judgment into structured learning signals.

More soon as I add more tasks and agents.
