# TasteBench Evaluation Principles

TasteBench evaluates whether coding/design agents can preserve product quality, not just complete isolated tasks.

## 1. Persistence over one-shot completion

Agents should be evaluated on whether they preserve product intent across:

- refactors
- UI changes
- repeated tasks
- interruptions and resumed work
- partially completed or ambiguous instructions

A strong agent should keep the product's design language, interaction model, and quality bar intact even as the codebase changes over time.

## 2. Reviewability as a first-class score

A good agent should make its work easy to inspect. Reviewability includes:

- readable diffs
- clear rationale
- source trails and references to task/product docs
- explicit uncertainty
- obvious rollback points
- small, inspectable changes when possible

Reviewability is separate from whether the app builds. An agent can produce working code that is still hard to review, trust, or safely merge.

## 3. Surface neutrality

Agents should be evaluated across the surfaces real builders use:

- IDE
- CLI
- chat
- browser
- design tools

Real product work moves between surfaces constantly. TasteBench should avoid overfitting to a single workflow or agent interface.

## 4. Product-quality failures matter even when automation passes

Automated checks can verify build health, tests, diffs, token usage, and some accessibility signals. Human review should still catch product-quality failures such as:

- poor spacing or padding
- slow or awkward motion
- misaligned text
- broken hierarchy
- generic UI that violates product intent
- changes that are technically correct but not shippable
