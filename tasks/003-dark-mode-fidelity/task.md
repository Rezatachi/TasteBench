# Task 003 — Dark Mode Fidelity

## Question Being Tested

Can the agent improve dark mode while preserving Mira's product intent, warmth, restraint, and design-system coherence?

## User Problem

Mira already has light/dark color tokens, but dark mode should feel intentionally designed rather than mechanically inverted. The dark experience should remain calm, warm, readable, and native to iOS without becoming stark, high-contrast, neon, or generic.

## Scope

Improve Mira's dark mode fidelity across the core app surfaces.

The improvement should:

- preserve Mira's quiet, editorial, warm, restrained product language
- improve readability and hierarchy in dark mode
- keep surfaces, borders, accent color, and text colors harmonious
- avoid raw one-off colors in screens/components
- keep the light-mode experience visually unchanged or minimally changed
- use or refine existing design tokens rather than scattering special cases
- preserve Today, Journal, Entry Detail, New Entry, and Settings behavior

## Non-goals

- Do not redesign the entire app.
- Do not add theme settings or persistence.
- Do not add new onboarding or preference flows.
- Do not introduce gradients, illustrations, neon accents, or loud dark-mode effects.
- Do not replace the design system with a new abstraction layer.
- Do not use generic black/white dark mode unless it is intentionally wrapped in Mira tokens.
