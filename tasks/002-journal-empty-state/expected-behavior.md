# Expected Behavior — Task 002 Journal Empty State

## Empty Journal State

When the Journal has zero entries, the Journal screen should show a calm empty state instead of an empty list or awkward blank space.

The empty state should include:

- human, Mira-specific copy
- a short explanation or invitation to begin reflecting
- a primary action that opens the existing new-entry flow
- visual treatment that feels quiet, editorial, warm, and restrained

## Populated Journal State

When entries exist, the existing Journal list should continue to work as before.

The implementation should not regress:

- navigation to entry detail
- entry card appearance
- date/mood display
- the existing new-entry flow

## Copy Guidance

Good copy should feel like Mira:

- reflective
- calm
- specific
- human
- low-pressure

Avoid generic system copy such as:

- "No items found"
- "No data available"
- "Nothing here yet"
- "Create item"

## Visual Guidance

The empty state should:

- use existing typography tokens
- use existing spacing and surface patterns
- use `PrimaryButton` or the established primary action style
- avoid loud illustration, generic icons, gradients, or decorative overwork
- remain comfortable on common iPhone simulator sizes

## Acceptance Criteria

- Empty state appears only when Journal has no entries.
- Empty state includes a primary action to create a new entry.
- Copy is calm and human, not generic.
- Existing populated Journal behavior still works.
- App builds and tests pass.
- Changes stay focused on Journal, components, design-system usage, and tests if needed.
