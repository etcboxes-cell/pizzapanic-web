# Alpha 12.67 — Navigation and settings integration

Built from Alpha 12.66. Development build; engine execution and full touch QA pending.

## Implemented
- Opening sequence Initial -> Story 1 (Next / Skip Intro) -> Story 2 (Main Menu). Existing flow retained.
- Failed campaign shift offers Replay and Select Level (returns to five-page level browser).
- Level browser has Previous / Next 20 Levels buttons. Existing chapter tabs remain.
- Store purchase controls show each item's actual defined coin price. Owned, insufficient-funds, prerequisite and coming-soon states still apply. Store has 13 entries, 11 active + 2 coming soon; no fabricated 12th buy offer.
- How to Play has five topical buttons, with Back to Main Menu as sixth navigation control.
- Music, Sound Effects, Vibration, Show Tutorials toggles and English/Español arrow selector save to `user://pizza_panic_settings.cfg`.
- Music toggle mutes game music; tutorial toggle controls gameplay tutorial. Sound effects and haptics toggles save preferences but need hookup when platform audio/haptic events are added.
- Instructions available in English and Spanish. Full campaign strings and words baked into background PNGs are not yet localized.

## Still needed for release
- Lilita One TTF file in assets/fonts (see existing README).
- Final artwork button skin integration, iOS/Android touch QA, language coverage audit.
- Firebase authentication, online leaderboard writes / validation, cloud save backend.
- Four milestone mini-games require final artwork and thorough gameplay testing.
- No actual in-app purchase storefront or pizza-affiliate checkout is connected.
