# Scoring: Task 003 — Dark Mode Fidelity

Score out of 24.

## 1. Functional Correctness — 3 points

- 1: App still responds correctly to system light/dark appearance.
- 1: Core screens continue to render and behave normally.
- 1: The change actually targets dark-mode fidelity rather than unrelated UI work.

## 2. Build and Test Health — 3 points

- 1.5: App builds successfully.
- 1: Existing tests pass.
- 0.5: No obvious warnings, fragile color hacks, or state changes are introduced.

## 3. Visual Consistency — 3 points

- 1: Dark mode preserves Mira's quiet, editorial, warm, restrained tone.
- 1: Surface/background/text hierarchy feels intentional and comfortable.
- 1: Dark mode feels designed by the same team as light mode.

## 4. Design System Adherence — 3 points

- 1: Uses/refines shared Mira design tokens rather than one-off screen colors.
- 1: Keeps color, surface, border, typography, and spacing decisions coherent.
- 1: Avoids pure black/white, neon accents, harsh contrast, unnecessary gradients, and generic SaaS dark-mode patterns.

## 5. Interaction Quality — 3 points

- 1: Buttons, navigation, text fields, cards, and toggles remain readable and tappable.
- 1: Focus remains on journaling/reflection rather than visual effects.
- 1: Changes do not create awkward visual jumps between screens or sheets.

## 6. Restraint — 3 points

- 1: Does not add theme settings, persistence, onboarding, or unrelated features.
- 1: Keeps the diff minimal and focused on dark-mode fidelity.
- 1: Avoids over-abstracting the design system beyond what the task requires.

## 7. Accessibility — 3 points

- 1: Text contrast is reasonable in dark mode.
- 1: Secondary text and controls remain legible.
- 1: The implementation does not obviously harm VoiceOver, Dynamic Type, or native appearance behavior.

## 8. Regression Risk — 3 points

- 1: Light mode is unchanged or minimally changed.
- 1: Changes are limited to expected files/areas.
- 1: Diff size and complexity are appropriate for a palette/fidelity task.

## Automated vs Human Scoring

The evaluation script can measure build status, tests, changed files, diff size, raw color heuristics, token references, and accessibility references.

Human review is still required for dark-mode warmth, comfort, contrast nuance, restraint, whether the palette feels like Mira, and final ship readiness.

## Additional Cross-Task Evaluation Dimensions

### Reviewability — 4 points

- 1: Diff is easy to inspect and limited to relevant files.
- 1: Agent explains which palette/surface decisions changed and why.
- 1: Source trail is clear: product principles, design tokens, and changed files are easy to connect.
- 1: Rollback points and uncertainty are explicit enough to support safe review.

### Persistence

Evaluate whether the agent preserves product intent across light/dark modes and across all core screens, not just whether it tweaks a token.

### Surface Neutrality

Evaluate agent quality across IDE, CLI, chat, browser, and design-tool workflows so the benchmark does not overfit to one interaction surface.
