# Alpha 12.65 - Milestone Mini-Games and Competitions

## What's included
- Four playable 30–40-second arcade challenges after successful campaign days 5/10/15/20: Pizza Toss, Perfect Pizza, Kitchen Rush and Pizza Championship.
- First completion of a milestone automatically shows its mini-game; later replays can use PLAY DAY X MINI-GAME on the results screen.
- Main menu COMPETITIONS with a local personal-record scoreboard, endless-round record, and a weekly practice challenge with a deterministic target pattern.
- Separate `user://pizza_panic_competitions.cfg` persistence, preserving the pre-existing campaign save. Changing machines requires transferring both files.
- Optional read-only online leaderboard GET integration, disabled until a trustworthy HTTPS URL is provisioned. Expected JSON: `{"rankings":[{"name":"Player","score":123}]}`. Call `competition_hub.set_online_endpoint("https://...")` after you deploy your own endpoint.

## NOT yet implemented, and not claimed
- No Firebase deployment, player accounts, cloud saves, authoritative score verification, hosted leaderboards, real-money payments, or anti-cheat enforcement. A game client cannot securely verify scores by itself.
- The weekly mode currently saves *personal bests on one device* and uses device-local dates, so it is NOT suitable for official competitions or cash prizes.
- The new mini-games are functional arcade prototypes with UI buttons, not final animation-heavy mini-games. A single milestone coin reward is described in UI but is NOT awarded by the new hub yet; this prevents accidental coin duplication until economy integration is tested.
- No in-engine test performed here. Test in the Godot editor and report any errors.

## Online architecture to implement before public launch
Use Firebase Auth or another identity provider; issue time-bounded per-attempt tokens server-side; stream or validate challenge events against a server-known seed; enforce minimum session times, maximum scores and request rate limits; timestamp submissions on the server; write authoritative results via a privileged Cloud Function; expose read-only, paginated leaderboards. In-app purchase advantages should be excluded from standardized weekly competitions.

## Testing checklist
1. New profile wins Days 5, 10, 15, 20: correct challenge opens once.
2. Replay milestone: button opens game without blocking next level.
3. Fail milestone day: no auto mini-game.
4. Mini-games run for their time limits and save best score on restart.
5. COMPETITIONS displays local records and weekly challenge.
6. Without endpoint, online button clearly reports 'not configured'.
7. Existing purchases, saved table layouts, reputation and endless game remain unchanged.
