# Task 003 Comparison — Dark Mode Fidelity

## Summary

Task 003 asked agents to improve Mira's dark-mode fidelity while preserving the app's quiet, editorial, warm, restrained, native iOS product language. Both runs were valid comparable product runs: they changed only allowed app design-system/component paths, passed build/tests, and produced inspectable dark-mode palette work.

Bottom line: Codex is the cleaner winning run for this task. Hermes had one product-system idea worth stealing — stronger shared dark-mode surface borders — but Codex better respected design-token hygiene and produced a smaller, cleaner implementation.

## Result Matrix

| Agent | Build | Tests | Files | + / - | Raw color usages | Token refs | Human score | Ship readiness |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| codex | True | True | 4 | 64 / 22 | 0 | 37 | 23.0/24 | yes |
| hermes | True | True | 5 | 45 / 17 | 28 | 39 | 20.5/24 | yes-with-minor-cleanup |

## Winner

Winner: Codex

Why:

- Higher human score: 23/24 vs. Hermes at 20.5/24.
- Zero raw color heuristic hits, compared with Hermes's 28 raw color usages.
- Cleaner centralization of mood colors through `MiraColors.moodTint(for:)`.
- Better design-system adherence while preserving light-mode stability.
- Smaller changed-file surface: 4 files vs. 5 files.

## What Codex Did Well

Codex changed:

- `Mira/Mira/Components/PrimaryButton.swift`
- `Mira/Mira/DesignSystem/MiraColors.swift`
- `Mira/Mira/DesignSystem/MiraShadow.swift`
- `Mira/Mira/DesignSystem/MoodStyle.swift`

The strongest Codex choices:

- Introduced `accentForeground` so button text no longer uses raw `Color.white`.
- Introduced `shadow` so the shared shadow no longer uses raw `Color.black`.
- Kept dark-mode palette work centralized in `MiraColors`.
- Moved mood tint selection behind `MiraColors.moodTint(for:)`, preserving existing light-mode values while adding warmer, more legible dark-mode values.
- Maintained a small, reviewable diff.

Main caveat:

- Disabled primary-button contrast should still get a simulator/screenshot pass because disabled foreground and background both derive from secondary text treatment.

## What Hermes Did Well

Hermes changed:

- `Mira/Mira/Components/PrimaryButton.swift`
- `Mira/Mira/DesignSystem/MiraColors.swift`
- `Mira/Mira/DesignSystem/MiraShadow.swift`
- `Mira/Mira/DesignSystem/MiraSurfaceStyle.swift`
- `Mira/Mira/DesignSystem/MoodStyle.swift`

The strongest Hermes choices:

- Improved background, surface, text, accent, border, and shadow values in a warm restrained direction.
- Added `onAccent` for primary-button foreground color.
- Added a shared `MiraSurfaceStyle` dark-mode border opacity adjustment, which is a good design-system primitive for improving card separation across the app.
- Kept the work scoped to design-system/component files with no unrelated features.

Main caveat:

- Hermes left mood tint RGB values in `MoodStyle` as raw dynamic `UIColor(red:)` calls. The evaluator flagged this as 28 raw color usages. That is a real maintainability concern, not just a noisy heuristic, because it splits palette ownership between `MiraColors` and `MoodStyle`.

## Product/Design Takeaway

This task is useful because both agents passed conventional coding checks and both were broadly product-valid. The meaningful difference was not whether the app built; it was whether the implementation preserved the product system cleanly.

TasteBench signal from Task 003:

1. Build/test success is table stakes.
2. Small diffs can still differ materially in product quality.
3. Design-token hygiene is measurable enough to guide review, but still needs human interpretation.
4. The best product answer may combine ideas across agents: use Codex's centralization plus Hermes's shared surface-border improvement.

## Recommended Manual Merge Direction

If we turn Task 003 into an actual Mira product improvement, use this hybrid:

- Start from Codex's `MiraColors` / `moodTint(for:)` structure.
- Keep Codex's `accentForeground` and `shadow` token cleanup.
- Borrow Hermes's `MiraSurfaceStyle` dark-mode border opacity adjustment.
- Keep all RGB values centralized in `MiraColors` or clearly approved design-system files.
- Add screenshot evidence for Today, Journal, Entry Detail, New Entry, and Settings in dark mode.

## Portfolio Angle

Task 003 is a strong public example because the distinction is subtle and PM/design-relevant:

- Both agents shipped something reasonable.
- One had cleaner system thinking.
- The other had one better primitive but weaker token discipline.
- The evaluator caught a real implementation smell, while human review decided whether that smell mattered to product quality.

A concise public framing:

> In TasteBench Task 003, both agents improved dark mode and passed build/tests. The winner was not the one with the most code — it was the one that preserved Mira's design system most cleanly. Product taste showed up as restraint, token hygiene, and knowing where color decisions belong.

## Artifact Links

- Codex result: `runs/codex/003-dark-mode-fidelity/result.json`
- Codex human review: `runs/codex/003-dark-mode-fidelity/human-review.md`
- Codex diff: `runs/codex/003-dark-mode-fidelity/diff.patch`
- Hermes result: `runs/hermes/003-dark-mode-fidelity/result.json`
- Hermes human review: `runs/hermes/003-dark-mode-fidelity/human-review.md`
- Hermes diff: `runs/hermes/003-dark-mode-fidelity/diff.patch`
