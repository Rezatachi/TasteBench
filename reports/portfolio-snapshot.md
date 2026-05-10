# TasteBench Portfolio Snapshot

TasteBench evaluates whether AI coding agents can make product-quality app changes, not just code that builds.

## Current Dashboard Summary

- Runs captured: 6
- Scored runs: 5
- Average human score: 20.6
- Build+test pass count: 6
- Automated pass but human-blocked count: 1
- Agents: claude-code, codex, hermes
- Tasks: 001-add-settings-screen, 002-journal-empty-state, 003-dark-mode-fidelity

## Run Matrix

| Task | Agent | Build | Tests | Files | + / - | Human score | Ship readiness |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| 001-add-settings-screen | claude-code | True | True | 13 | 933 / 0 | pending | invalid-run |
| 001-add-settings-screen | codex | True | True | 3 | 197 / 2 | 15.0/24 | no |
| 002-journal-empty-state | codex | True | True | 1 | 46 / 7 | 21.7/24 | yes-with-polish |
| 003-dark-mode-fidelity | codex | True | True | 4 | 64 / 22 | 23.0/24 | yes |
| 002-journal-empty-state | hermes | True | True | 1 | 35 / 5 | 22.8/24 | yes |
| 003-dark-mode-fidelity | hermes | True | True | 5 | 45 / 17 | 20.5/24 | yes-with-minor-cleanup |

## Early Findings

1. Build/test success is necessary but not sufficient. Task 001 passed automation but failed human product review because visual spacing, motion, and alignment were not shippable.
2. Small diffs can still show meaningful taste differences. For Task 002, both agents changed one file and passed automation, but the more restrained copy/hierarchy reviewed better.
3. Product-management review needs separate language from code review: copy, hierarchy, restraint, interaction feel, and product fit deserve explicit scoring.

## Per-Run Notes

### 001-add-settings-screen — claude-code

Result: `runs/claude-code/001-add-settings-screen/result.json`
Human review: `runs/claude-code/001-add-settings-screen/human-review.md`

Human review found this is not a valid comparable Settings-screen product run. The artifacts primarily capture benchmark harness/bootstrap changes, the diff.patch is empty, and changed files are mostly repo/task/tooling docs rather than the requested Mira Settings implementation. Exclude from product-quality scoring.

Human scores pending.

### 001-add-settings-screen — codex

Result: `runs/codex/001-add-settings-screen/result.json`
Human review: `runs/codex/001-add-settings-screen/human-review.md`

Automated checks passed, but human review found severe product-quality issues: padding/layout problems, slow animations, and misaligned text. Not ship-ready without visual and interaction polish.

| Dimension | Score |
| --- | ---: |
| Functional | 3/3 |
| Build/test | 3/3 |
| Visual | 1/3 |
| Design system | 1.5/3 |
| Interaction | 1/3 |
| Restraint | 2/3 |
| Accessibility | 1.5/3 |
| Regression risk | 2/3 |

### 002-journal-empty-state — codex

Result: `runs/codex/002-journal-empty-state/result.json`
Human review: `runs/codex/002-journal-empty-state/human-review.md`

Automated checks passed and the implementation is broadly product-aligned. Human review finds it shippable with polish: the empty state is calm and functional, but the all-caps eyebrow, extra hierarchy, and slightly terse CTA make it feel a bit more designed/constructed than Mira's quietest moments.

| Dimension | Score |
| --- | ---: |
| Functional | 3/3 |
| Build/test | 3/3 |
| Visual | 2.3/3 |
| Design system | 2.5/3 |
| Interaction | 3/3 |
| Restraint | 2.4/3 |
| Accessibility | 2.5/3 |
| Regression risk | 3/3 |

### 003-dark-mode-fidelity — codex

Result: `runs/codex/003-dark-mode-fidelity/result.json`
Human review: `runs/codex/003-dark-mode-fidelity/human-review.md`

Human review: strong, shippable dark-mode token refinement. Codex keeps the work narrow, preserves light mode, removes raw component colors, and produces a warm readable palette; only minor caveats around disabled button contrast and lack of screenshot-based review.

| Dimension | Score |
| --- | ---: |
| Functional | 3/3 |
| Build/test | 3/3 |
| Visual | 3/3 |
| Design system | 3/3 |
| Interaction | 2.5/3 |
| Restraint | 3/3 |
| Accessibility | 2.5/3 |
| Regression risk | 3/3 |

### 002-journal-empty-state — hermes

Result: `runs/hermes/002-journal-empty-state/result.json`
Human review: `runs/hermes/002-journal-empty-state/human-review.md`

Automated checks passed and human review finds the result ship-ready. The implementation is narrow, calm, and product-sensitive; the copy feels more human and less generic than a typical empty state, with only minor polish questions around the surfaced card treatment/shadow.

| Dimension | Score |
| --- | ---: |
| Functional | 3/3 |
| Build/test | 3/3 |
| Visual | 2.7/3 |
| Design system | 2.7/3 |
| Interaction | 3/3 |
| Restraint | 2.8/3 |
| Accessibility | 2.6/3 |
| Regression risk | 3/3 |

### 003-dark-mode-fidelity — hermes

Result: `runs/hermes/003-dark-mode-fidelity/result.json`
Human review: `runs/hermes/003-dark-mode-fidelity/human-review.md`

Human review: shippable directionally, with a better shared surface-border adjustment than Codex, but less clean design-system adherence because mood colors remain raw UIColor values outside MiraColors and the raw-color heuristic flags 28 usages.

| Dimension | Score |
| --- | ---: |
| Functional | 3/3 |
| Build/test | 2.5/3 |
| Visual | 3/3 |
| Design system | 2/3 |
| Interaction | 2.5/3 |
| Restraint | 2.5/3 |
| Accessibility | 2.5/3 |
| Regression risk | 2.5/3 |
