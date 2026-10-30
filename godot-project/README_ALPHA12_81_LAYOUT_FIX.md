# Pizza Panic Alpha 12.81 — Layout and Settings Repair

Build based on the supplied Alpha 12.80 master ZIP. Original gameplay and progress rules are preserved.

## Corrected
- Scaled illustrated How To Play background, active blue tab, instructions panel, and close button to 1280 x 720 design coordinates.
- Scaled Shop background and upgrade icons. Refined footer contrast. Three cards per page; one forward arrow wraps to page 1.
- Scaled Level Select background, top coin/star bars, mini-game badge and level/star tiles. 20 levels per page, five pages.
- Added original approved full-screen Settings artwork; 4 separate rows: Earn More Coins, Follow Us, Music, Sound Effects. Red close button returns to Main Menu.
- Persisted music/effects toggles via existing user://pizza_panic_settings.cfg code.
- Rewarded-ad action uses existing ads_bridge; it credits coins only on the existing rewarded_completed signal, if a video is actually available.
- Follow Us shows a no-URL-configured notice until the game's Instagram URL is supplied; no made-up URL.
- `ui_motion.gd` now validates watched entries and stored button instances before treating an instance as a Button.
- Scaled the Level Complete and Level Failed background/stars the same way, preventing oversized artwork on those screens as well.

## Notes
- The generated previews (provided separately) are layout composites, NOT screenshots captured from Godot.
- Godot runtime validation is still required on the user's version; Godot is not installed in this tool environment.
- User-specific error line/stack trace has not been supplied; button-watching fix is preventative until confirmed.
- The newest customer and table artwork from the chat is not included in this batch because the user has not yet approved/integrated the new design system.
- Original project folder structure and assets are maintained.
