# Task 002 — Journal Empty State

## Question Being Tested

Can the agent design for a non-happy path with product sensitivity?

## User Problem

When the Journal has no entries, the screen should not feel blank, broken, or generic. Mira should gently invite the user to begin reflecting without making the interface feel like a productivity app or SaaS dashboard.

## Scope

Add an empty state to the Journal screen for the zero-entry case.

The empty state should:

- appear only when there are no journal entries
- encourage the user to write a first reflection
- include a primary action to create a new entry
- use Mira's existing product language, spacing, typography, and components
- preserve the existing populated Journal experience

## Non-goals

- Do not add persistence.
- Do not add onboarding.
- Do not add account/auth flows.
- Do not redesign the entire Journal screen.
- Do not change the entry model or sample data unless needed only to preview/test the empty state.
- Do not use generic empty-state copy such as "No items found" or "Nothing here yet".
