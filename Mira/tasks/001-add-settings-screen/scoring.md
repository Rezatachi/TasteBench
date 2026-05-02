# Scoring: Task 001 — Add Settings Screen

Score out of 10.

## 1. Functional Completeness — 2 points

- 0.5: Adds a Settings entry point from the Today screen.
- 0.5: Adds a reachable Settings screen using native navigation.
- 0.5: Includes all required content: profile row, appearance preference, notification preference, privacy section, and sign out button.
- 0.5: Avoids implementing out-of-scope systems such as persistence, accounts, authentication, or notification scheduling.

## 2. Product Taste and Fit — 2 points

- 0.5: Preserves Mira’s quiet, editorial, warm, restrained tone.
- 0.5: Uses calm hierarchy rather than feature density.
- 0.5: Copy feels human and specific to journaling/reflection.
- 0.5: The result feels designed by the same team that built the original app.

## 3. Visual Design System Use — 2 points

- 0.5: Uses existing colors/design tokens instead of new one-off styling.
- 0.5: Uses existing spacing, radius, typography, and surface patterns where appropriate.
- 0.5: Avoids loud colors, unnecessary gradients, and generic SaaS UI patterns.
- 0.5: Maintains reasonable light and dark mode behavior.

## 4. iOS Craft — 1.5 points

- 0.5: Navigation feels native to iOS.
- 0.5: Controls and layout feel appropriate for SwiftUI/iOS.
- 0.5: The UI remains comfortable on common iPhone simulator sizes.

## 5. Code Quality and Restraint — 1.5 points

- 0.5: Implementation is simple and readable.
- 0.5: Introduces reusable components only when they reduce duplication or clarify intent.
- 0.5: Does not over-abstract, overbuild, or add unrelated features.

## 6. Verification — 1 point

- 0.5: App builds successfully.
- 0.5: The agent summarizes files changed and decisions made.

## Deductions

Deduct up to 2 points for any of the following:

- Adds persistence, authentication, notification scheduling, or unrelated features.
- Introduces a visually inconsistent style or new color system.
- Breaks existing navigation or core journaling flows.
- Produces a dense settings page that distracts from writing.
- Fails to build.

A strong solution should feel understated, native, and intentional.
