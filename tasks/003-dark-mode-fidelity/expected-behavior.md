# Expected Behavior: Task 003 — Dark Mode Fidelity

## Dark Mode

When the app is viewed in dark mode:

- backgrounds should feel warm and calm, not pure black or cold gray
- surfaces should remain distinguishable from the background without harsh contrast
- borders should be visible but subtle
- primary text should be readable without feeling stark
- secondary text should remain legible and calm
- accent color should feel warm and editorial, not neon or overly saturated
- cards/buttons should still feel native to Mira's design language

## Light Mode

Light mode should remain visually stable.

Acceptable light-mode changes:

- tiny token refinements that preserve the existing look
- shared token cleanup if it does not materially alter the light experience

Unacceptable light-mode changes:

- broad redesign
- louder accent colors
- layout changes unrelated to dark mode
- typography/spacing changes that change Mira's feel

## Core Surfaces to Preserve

The change should preserve behavior and hierarchy across:

- Today
- Journal
- Entry Detail
- New Entry
- Settings
- reusable cards/buttons/surfaces

## Copy and Interaction

This task should not add copy, flows, or features. It is a visual/design-system fidelity task.

## Acceptance Criteria

- Dark-mode palette feels intentional, warm, readable, and restrained.
- The implementation uses design tokens rather than one-off screen colors.
- Existing navigation, entry creation, Settings controls, and Journal detail navigation still work.
- The diff is small enough for a reviewer to understand the palette decision.
- Any screenshot or reviewer note can explain what changed and why.
