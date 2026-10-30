# Pizza Panic Alpha 12.64 — First 20 Days, Endless Restaurant & ethical monetization

## What is actually built
- Rebalanced all 20 campaign days. Early arrivals are fewer and the clock is longer; pace increases over later days.
- Each visible special-mission target now matches its goal-check threshold for large parties, cleaning, VIPs, and correct orders. These missions remain optional for unlocking the next day; the shift cash goal remains the completion requirement.
- Optional seating expansions: purchases no longer prevent starting the next day. The table system still uses purchased upgrades and up to six active tables; the remaining two positions are reserved for future expansion logic.
- Four-pizza tray now has a fixed 450-coin cost; it no longer takes every coin in the player's wallet.
- Automatic between-day interstitial request removed. Existing mobile rewarded ad remains opt-in and only awards after the ad-completion callback. Desktop does not show the rewarded-ad button.
- ENDLESS RESTAURANT mode added to Main Menu. Unlocks only when a saved completion star exists for Day 20. It uses the normal restaurant interactions and increasing round-by-round customer demands.
- Endless rounds use player-owned table upgrades, rotate five challenge themes, cap the difficulty ramp after round 19, and remember best completed round and best cash. Finishing a wave presents a button for the next round. Failing lets the player retry the current wave.
- Endless payout pays only the *improvement* over the player's best score for each wave, to limit replay farming. Campaign review history and campaign day unlocks are not modified by endless scores.
- Campaign saved progress is retained in the same user:// configuration file as previous versions; endless records are a new section.

## Limitations and caveats
- This is an untested engineering build. Godot executable is not available in this environment. Import and test in Godot; keep the earlier version as a backup.
- 'Endless' currently means an unlimited sequence of repeatable **rounds**, not a single uninterrupted survival clock or a server leaderboard. The next round opens after a result screen.
- Rotating themes are informational except for the VIP interval: ingredients gameplay remains the core objective on every endless round. Theme-specific bespoke modifiers, seeded daily challenges, endless streak multipliers, and achievements remain future work.
- No real-money payments, merchandise checkout, coupon redemption, or restaurant affiliate integrations are connected. The in-game coin-bundle screen remains explicitly a demo. Do not publish its listed prices as live offers.
- No guarantee that the rebalanced goals are achievable or enjoyable; the first 20 days must be tested by people new to the game.

## Suggested A/B playtest (do before buying ads)
- Run 20–30 blind testers through Days 1–5 and 10–20 testers through Days 6–20.
- Track completion and fail rate per day, number of interactions needed, which kitchen actions caused confusion, time of each wait/walkout, and total time to finish each shift.
- Target first-day completion >=75%; a common new mechanic should not cause a sudden >20 percentage-point drop in level completion.
- Run 100+ externally recruited installs for day-1 and day-7 retention before increasing marketing spending.
- Remove unnecessary forced interruption between days. Rewarded offers must be explicitly optional; purchases cannot be prerequisites for campaign progression.

## Monetization rollout plan (not implemented as live transactions)
**Phase 1:** Measure sessions and retention. Use one explicitly optional +50-coin rewarded ad button between shifts when the ad SDK is available. Test rewarded video completions and ad fill in each region. Avoid banners over the game board.
**Phase 2:** After retention is validated, implement platform-native billing for modest coin packs and one small cosmetic bundle, with clear prices, server-side purchase validation, restore purchases, and refund handling. No pay-to-win progression gates.
**Phase 3:** Pilot pizza discount codes with 1–3 actual pizzerias, using opt-in location selection and redeemed-order tracking. No restaurant names, offers, rates, commissions, or deadlines may be represented as signed until agreements are in place.
**Phase 4:** Only after audiences demonstrate demand, sell merchandise via made-to-order fulfillment; measure contribution profit after returns, shipping and production.

## Endless test steps
1. Import project as a separate new Godot project. Your prior user:// save might be shared if the Godot app's project-data identifiers match; back up saves before testing.
2. Confirm NEW or unfinished accounts see Endless on menu but tapping it leads to Day Selection, not Endless gameplay.
3. Confirm completion of campaign Day 20 unlocks Endless on next visit to menu.
4. Launch Round 1; confirm 13 scheduled parties, 150-second arrival clock, cash goal 100; customers must still finish service after closing.
5. Complete wave, use Next Endless Round, confirm wave number increments and challenge gets harder.
6. Lose a wave, confirm Retry Endless Round does not skip ahead.
7. Quit and reload; confirm best cleared round persists, other campaign progress and upgrades remain unchanged.
8. Replay completed waves and verify wallet only increases when beating previous best payout.
9. Verify purchased Table 7 chair upgrade persists as red/4 chairs, and unupgraded Table 7 is yellow/2 chairs.
10. Confirm no forced interstitial between campaign days and the opt-in rewarded ad remains separate from regular game progression.

## Strong recommendations for next iteration
- Day-1 visual tutorial should demonstrate exactly one action at a time; never start with a frantic queue.
- Add explicit button labels / hitboxes to kitchen stations instead of covering the kitchen background with opaque panels.
- On levels 5, 10, 15 and 20 add a short milestone animation with restaurant improvement, not just another harder day.
- Add a one-time mistake protection tool in early levels, but do not monetize it until effectiveness is measured.
- Build theme-specific endless modifiers and a real offline scoreboard after the basic endless waves have passed testing.
