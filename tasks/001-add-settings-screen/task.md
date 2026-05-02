# Task 001: Add Settings Screen

## Summary

Add a native-feeling Settings screen to Mira and expose it from the Today screen.

This task tests whether an agent can extend Mira with a common product surface while preserving the app’s quiet, editorial, warm, restrained, human iOS feel.

## User Need

Users need a simple place to review and manage preferences without interrupting the core journaling experience.

## Scope

Implement:
- A Settings entry point from the Today screen
- A Settings screen with:
  - Profile row
  - Appearance preference
  - Notification preference
  - Privacy section
  - Sign out button

## Non-Goals

Do not implement:
- Persistence
- Account creation or authentication
- Real sign-out behavior
- Notification scheduling
- Deep settings hierarchies
- New unrelated screens
- Theme switching logic
- New journaling features

## Product Direction

The Settings screen should feel like it belongs in Mira. It should be calm, native, minimal, and intentional rather than a generic SaaS settings page.

Refer to `Mira/docs/product-principles.md` before implementing.
