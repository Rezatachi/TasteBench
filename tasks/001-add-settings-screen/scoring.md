# Scoring: Task 001 — Add Settings Screen

Score out of 24.

## 1. Functional Correctness — 3 points

- 1: Adds a Settings entry point from the Today screen.
- 1: Adds a reachable Settings screen using native navigation.
- 1: Includes all required content: profile row, appearance preference, notification preference, privacy section, and sign out button.

## 2. Build and Test Health — 3 points

- 1.5: App builds successfully.
- 1: Existing tests pass.
- 0.5: No obvious warnings or changes that suggest fragile behavior.

## 3. Visual Consistency — 3 points

- 1: Preserves Mira’s quiet, editorial, warm, restrained tone.
- 1: Maintains calm hierarchy rather than feature density.
- 1: The result feels designed by the same team that built the original app.

## 4. Design System Adherence — 3 points

- 1: Uses existing colors and design tokens instead of new one-off styling.
- 1: Uses existing spacing, radius, typography, and surface patterns where appropriate.
- 1: Avoids loud colors, unnecessary gradients, and generic SaaS UI patterns.

## 5. Interaction Quality — 3 points

- 1: Navigation feels native to iOS.
- 1: Controls and layout feel appropriate for SwiftUI/iOS.
- 1: The UI remains comfortable on common iPhone simulator sizes.

## 6. Restraint — 3 points

- 1: Avoids persistence, accounts, authentication, notification scheduling, and unrelated systems.
- 1: Keeps settings shallow and easy to understand.
- 1: Does not over-abstract or introduce unnecessary models/components.

## 7. Accessibility — 3 points

- 1: Important interactive controls have understandable labels where needed.
- 1: Text hierarchy and tappable areas are reasonable.
- 1: The implementation does not obviously harm VoiceOver or Dynamic Type behavior.

## 8. Regression Risk — 3 points

- 1: Does not break existing Today, Journal, Entry Detail, or New Entry flows.
- 1: Changes are limited to expected files/areas.
- 1: Diff size and complexity are appropriate for the task.

## Automated vs Human Scoring

The evaluation script can measure build status, tests, diff size, changed files, raw color heuristics, design-token references, and accessibility references.

Human review is still required for visual consistency, restraint, copy quality, interaction quality, and final ship readiness.

## Additional Cross-Task Evaluation Dimensions

These dimensions are tracked separately from the 24-point Task 001 task score for now, but should become first-class in broader TasteBench suites.

### Reviewability — 4 points

- 1: Diff is easy to inspect and limited to relevant files.
- 1: Agent rationale is clear enough for a reviewer to understand key decisions.
- 1: Source trail is clear: task docs, product principles, and changed files are easy to connect.
- 1: Rollback points and uncertainty are explicit enough to support safe review.

### Persistence

Evaluate whether the agent preserves product intent across refactors, follow-up edits, interruptions, and multi-step work — not just whether it completes the immediate task.

### Surface Neutrality

Evaluate agent quality across IDE, CLI, chat, browser, and design-tool workflows so the benchmark does not overfit to one interaction surface.
