# Pizza Panic Alpha 12.66 — 100-Level Content Expansion

## Implemented in this build
- Preserves the existing 20 levels and adds 80 playable parameterized campaign shift configurations (Days 21–100) with chapter-specific themes and changing mission targets, scheduled parties, time windows, and patience difficulty. The new days are **design-generated and have not yet been human balanced**.
- Five chapter tabs of twenty days each now have real entries, instead of 'coming soon'. Progression and save file can unlock all 100.
- A milestone mini-game is offered after winning each fifth day, Days 5,10,...,100. Four existing gameplay prototypes rotate every 20 levels. Scores are keyed by specific day, so Day 25 does not overwrite Day 5. Weekly practice mode is independent from Day 25 and now has a distinct sentinel ID.
- Day 20 is no longer the final campaign ending. Day 100 concludes the campaign. Endless Restaurant unlock moves to Day 100; offline personal bests remain in the device-local save.
- Keeps the original Initial -> Story 1 -> Story 2 -> Main Menu flow, level select, upgrades, table layout, reputation and saved progress, graphic mapper, and font-loader integration.
- Online leaderboard remains READ-ONLY / not configured by default. This build contains **no Firebase credential, live server, verified multiplayer leaderboard, payment processing, or remote cloud save**.
- Weekly mode is local practice; never use these scores for cash prizes or public competitive rankings without server validation.

## Validation
Static Python checks confirmed 100 campaign data entries and 20 mini-game milestone IDs. The project has not been run or tested inside Godot in this environment. Do not treat this ZIP as production-ready.

## Next technical tasks for actual online competitions
1. Create a Firebase project for development and one for production, and configure Firebase Authentication (guest accounts, optional Apple sign-in where required).
2. Provision Cloud Firestore and App Check where supported; deploy a Cloud Function that creates time-limited challenges with authoritative server time and a fixed seed.
3. Modify the Godot client to request challenge tokens and send event streams, never an arbitrary untrusted total score. Validate timestamps, sequence, score caps, retries, replay/duplicate submissions and account abuse server-side.
4. Persist rankings server-side, expose paged and rate-limited read-only results, and implement reports/moderation and privacy controls.
5. Test iOS and Android account deletion, offline saves, sync conflicts, secure purchases, consent and Crashlytics/analytics.

## Playtesting gates before release
1. Start a new profile and complete Days 1–5; verify same-tap touch targets, timers and ratings.
2. Test Day 20 -> Day 21 and Day 40 -> 41 to validate chapter transitions.
3. Test Day 25 mini-game and separate weekly practice (no score collision).
4. Verify 20 mini-games across 100 days, Day 100 -> Endless, chapter navigation, and all existing upgrades.
5. Verify saved progress from Alpha 12.65 remains readable, and existing table-7 upgraded image stays red when upgrade is owned.
6. Balance all generated Days 21–100 with humans; verify no impossible revenue/guest targets.

## Known limitations
80 generated levels repeat known gameplay mechanics; they do not add all the new art, boss types, restaurant scenes, marketing integrations, or server-run competitions we discussed. Full rollout requires user-provided accounts/credentials and additional implementation and QA. The Lilita One font file is not embedded if absent from assets/fonts; download and install it separately as previous instructions describe.
