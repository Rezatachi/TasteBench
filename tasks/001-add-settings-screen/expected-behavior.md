# Expected Behavior

## Entry Point

- The Today screen includes a clear but restrained Settings entry point.
- The entry point uses native iOS navigation patterns.
- The entry point does not compete with the main reflection prompt or journaling actions.

## Settings Screen

The Settings screen includes the following visible sections or rows:

1. **Profile row**
   - Shows a simple user/profile area.
   - Does not require real account data.
   - Uses calm, human copy.

2. **Appearance preference**
   - Presents an appearance-related preference.
   - Does not need to persist or actually change app theme.
   - Avoids overbuilt controls if static copy or a simple row is enough.

3. **Notification preference**
   - Presents a notification-related preference.
   - Does not schedule real notifications.
   - Should feel like a placeholder for future preference management, not fake functionality.

4. **Privacy section**
   - Communicates privacy or local-reflection intent in a concise way.
   - Avoids legalistic or generic SaaS copy.

5. **Sign out button**
   - Present visually as a sign-out action.
   - Does not implement authentication or destructive behavior.
   - Should be restrained and not visually loud.

## Visual and Interaction Expectations

- The screen uses existing Mira design tokens for colors, spacing, typography, radii, and surfaces.
- The layout feels sparse and readable.
- Navigation feels native to iOS.
- The implementation supports light mode and does not obviously break dark mode.
- The screen avoids dense controls and unnecessary nested abstractions.

## Build Expectations

- The app builds successfully after the change.
- Existing tests should still pass unless intentionally updated for this task.
- No unrelated product behavior changes are introduced.
