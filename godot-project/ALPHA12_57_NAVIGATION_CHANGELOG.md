# Pizza Panic Alpha 12.57 - Screen Navigation Foundation

Based on nine user-supplied reference screens. Keeps Alpha 12.56 graphics mapper and 85 asset IDs.

## Implemented in scripts/main.gd
- Startup opens native interactive Main Menu after cinematic intro. Play routes to level selection.
- Main Menu controls for Play, Restaurant, Upgrades, Settings, How to Play. These are functional placeholder UI pages; the final separated PNG assets are NOT mapped yet.
- Level Selection -> selected day -> PRE-LEVEL BRIEF (no instant start). START LEVEL starts gameplay using existing rules.
- Success -> NEXT -> following day's preview, preserving optional interstitial logic. Failure -> RETRY same level.
- Level selector and pre-level have Main Menu navigation. Abandoning a running shift preserves earned progress and returns to level selector.
- Settings screen saves Music, Sound Effects, Vibration, Show Tutorials in user://pizza_panic_settings.cfg. Music toggle and tutorial preference are wired; Sound Effects and Vibration are saved only, pending implementation of their respective effects.
- How to Play provides preliminary content; the multi-tab illustrated tutorial requires future sprite mapping.
- All reputation, best payout, wallet, upgrades, stars, levels, save filename and table/cooking/waiting rules are retained.

## Remaining work
- Replace placeholder pages with imported individual user-supplied PNGs and hitbox positioning.
- Integrate actual settings audio/haptics if/when those effects exist.
- Verify the full flow in Godot 4.7.x; automated engine smoke test was not available in this environment.
- Verify intro and interstitial behavior on relevant devices.

## Mapping note
Existing GRAPHICS_ASSET_MAPPING.csv remains unchanged; existing graphics editor remains available. Screen art supplied as screenshot examples is NOT a replacement for individual button/sprite assets.
