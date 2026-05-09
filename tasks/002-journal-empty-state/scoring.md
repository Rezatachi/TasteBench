# Scoring: Task 002 — Journal Empty State

Score out of 24.

## 1. Functional Correctness — 3 points

- 1: Empty state appears when the Journal has zero entries.
- 1: Empty state includes a primary action that opens the new-entry flow.
- 1: Existing populated Journal behavior remains intact.

## 2. Build and Test Health — 3 points

- 1.5: App builds successfully.
- 1: Existing tests pass.
- 0.5: No obvious warnings or fragile state changes are introduced.

## 3. Visual Consistency — 3 points

- 1: Empty state preserves Mira's quiet, editorial, warm, restrained tone.
- 1: Layout, spacing, and hierarchy feel intentional rather than generic.
- 1: The result feels designed by the same team that built the original app.

## 4. Design System Adherence — 3 points

- 1: Uses existing colors and design tokens instead of raw one-off styling.
- 1: Uses existing typography, spacing, surface, and button styles where appropriate.
- 1: Avoids loud illustrations, gradients, generic icons, or SaaS-style empty-state patterns.

## 5. Interaction Quality — 3 points

- 1: Primary action is clear and easy to tap.
- 1: Navigation to the existing new-entry flow feels native to iOS.
- 1: Empty and populated states transition conceptually cleanly without awkward layout shifts.

## 6. Restraint — 3 points

- 1: Does not add onboarding, persistence, accounts, notification systems, or unrelated features.
- 1: Keeps copy and UI minimal while still useful.
- 1: Does not over-abstract or introduce unnecessary models/components.

## 7. Accessibility — 3 points

- 1: Primary action is accessible and understandable.
- 1: Text hierarchy and readable contrast are reasonable.
- 1: The implementation does not obviously harm VoiceOver or Dynamic Type behavior.

## 8. Regression Risk — 3 points

- 1: Does not break existing Journal entry list, detail navigation, Today, or New Entry flows.
- 1: Changes are limited to expected files/areas.
- 1: Diff size and complexity are appropriate for the task.

## Automated vs Human Scoring

The evaluation script can measure build status, tests, diff size, changed files, raw color heuristics, design-token references, and accessibility references.

Human review is still required for copy quality, visual consistency, restraint, interaction quality, whether the empty state feels like Mira, and final ship readiness.

## Additional Cross-Task Evaluation Dimensions

These dimensions are tracked separately from the 24-point task score for now, but should become first-class in broader TasteBench suites.

### Reviewability — 4 points

- 1: Diff is easy to inspect and limited to relevant files.
- 1: Agent rationale is clear enough for a reviewer to understand key decisions.
- 1: Source trail is clear: task docs, product principles, and changed files are easy to connect.
- 1: Rollback points and uncertainty are explicit enough to support safe review.

### Persistence

Evaluate whether the agent preserves product intent across empty and populated states, follow-up edits, interruptions, and multi-step work — not just whether it completes the immediate task.

### Surface Neutrality

Evaluate agent quality across IDE, CLI, chat, browser, and design-tool workflows so the benchmark does not overfit to one interaction surface.
