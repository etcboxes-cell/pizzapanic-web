# Pizza Panic Alpha 12 — Development Tracker

## Added in source (unverified runtime)
- Playable day definitions 11–20, and Next Day unlock extends through Day 20.
- Day 11 Chef popup for per-table toppings: cook, close & resume; shift timer remains active.
- Day 14 additional toppings, Day 15 multi-ingredient custom orders.
- Food preparation mapped to table orders; recipe confirmation occurs before cooking.
- Visible numbered table queue markers.
- Robot Waiter, Turbo Oven, saved purchases and seating expansion retained from Alpha 11.8.

## Requires testing / balancing
- Actual Godot import, GDScript parser, every level start/finish and save progression.
- Arrival counts, coin milestones and eight-table mobile touch targets.
- Custom pizza throughput, robot behaviour, closing logic and 20-day goals.
- Correct chef UI layering and time progression during the popup.

## Not built / roadmap
- Cancel and reorder pending tap actions.
- Production artwork, sprite animations, character personalities, expansion celebration.
- Analytics / playtests, full 100 days, online leaderboards and backend.
- Real-money coin packs, monthly prizes, merch store, partner pizzeria coupons, expansion packs.


## Alpha 12.1 — Next Day Progression Fix
- **Fixed in source, runtime testing required:** Any level reaching its cash goal passes once all arrivals and remaining guests are resolved; optional special challenge no longer blocks next-day progression.
- **Fixed in source:** Results show an enabled, focused `PLAY NEXT DAY N` button after success (except the final day). Clicking it advances and immediately starts gameplay.
- Progress is persisted when advancing. Failed days still show `RETRY LEVEL`.
- Regression checklist: win Days 1, 2, 3, 4, 5 consecutively, click Next every time; restart and verify highest unlocked day. Also replay an earlier day and use Next.
- Merchandise, pizzeria affiliations, 5 chapter-end mini-games, premium sprites/animations remain on roadmap.


## Alpha 12.3 — AdMob SDK integration (mobile test mode)
- [x] Preserve user's Poing Studios Godot AdMob addon.
- [x] Configure iOS + Android app IDs and ad unit mappings (test ad units used).
- [x] Interstitial on eligible NEW completed Days 4, 6, 8, etc.; minimum 5 minutes, no blocking when not loaded.
- [x] Voluntary rewarded ads: grant 50 coins only on SDK reward callback; 3-minute client cooldown.
- [x] Desktop and Steam completely bypass advertising.
- [ ] Godot parser/runtime validation on Godot 4.7.2, mobile device testing, SDK initialization and consent testing.
- [ ] Server-side reward verification, anti-fraud and multi-device limits.
- [ ] App store billing and verified $5.99 no-ads entitlement (NOT implemented; do not enable fake purchase).
- [ ] Consent manager, App Tracking Transparency as applicable, privacy policy, production release checks.

## Alpha 12.3.1 — Godot parser fix
- Renamed AdMob bridge variable `ready` to `ads_initialized` to avoid native `Node.ready` member collision.
- Source patched; Godot runtime test still required.


## Alpha 12.5 — Pause and Exit Level
- **Added (requires Godot runtime test):** In-shift PAUSE button at top right; RESUME and EXIT LEVEL — CHOOSE DAY menu.
- **Added (requires Godot runtime test):** Paused game stops shift timer, arrivals, waiting and seated customer patience, robot, movement, cooking, eating, effects and background music playback.
- **Added (requires Godot runtime test):** Exit abandons the unfinished shift without awarding shift coins, stars, trophies or new-level unlocks. Previously saved progress and upgrades remain intact.
- **QA:** Test pause during active queue, during chef popup, after closing, and tap exit then replay the day. Confirm menu taps work on Mac and mobile.


## Alpha 12.6 — Level 6 Table Expansion Fix
- Fixed: mandatory table-expansion gate before Levels 6, 11 and 16.
- Day 6 requires the **Expansion: 4 Tables** item (1,200 coins), NOT the independent **Two Extra Chairs** upgrade (150 coins).
- Day 11 requires the six-table expansion; Day 16 requires the eight-table expansion.
- Direct day-selection PLAY, Next Day, and pre-level Start follow the same expansion check.
- After buying a table expansion, rebuild the dining-room layout; show exact count in the Store and game HUD.
- If coins are insufficient, players can replay unlocked days. No real-money purchase required.
- **Status:** Source patched and ZIP verified; Godot runtime test needed on Mac.


## Alpha 12.7 — Kitchen sequence and topping difficulty repair
- **Fixed in source:** Selecting a pizza topping in Days 6–20 starts cooking only; it never makes guests eat, pay, leave or skip dishes.
- Required path: Seat > 3s decide > Take Order > ORDER DISH > Chef ingredient popup > COOK > oven > PICKUP BAR > Deliver to matching table > Eat > Collect Payment > Gather dishes > DISHWASHING.
- Ingredient tiers: Days 1–5 standard pizza; Days 6–10 exactly 1 topping; Days 11–15 exactly 2 toppings; Days 16–20 exactly 3 toppings.
- Ingredient popup enforces the maximum toppings for the current day and matches exact requested ingredients. More toppings become available on Day 14.
- Existing purchased four-table expansion and HUD count fix from Alpha 12.6 preserved.
- **Needs Godot 4.7.2 runtime testing** with existing save data, especially Days 6, 11, and 16 and the full ticket-to-dishes cycle.


## Alpha 12.8 — Strict party limits
- **Coded; Godot runtime verification required.** Each level uses `party_cap` from its level configuration (8 parties on Day 1, growing across the campaign).
- Opening three parties count toward the cap, including groups of one or more customers.
- Remaining parties arrive on scheduled slots within the first 90% of the shift. No unlimited new arrivals, no closing-time backlog dump.
- When the cap is reached, admissions stop even if shift time remains.
- After closing, existing parties can be seated and served; their patience still matters.
- HUD displays ARRIVALS (arrived parties / scheduled total).
- Test edge cases: VIP/reservation days, full waiting lines, paused shifts, and final party.
- Future balancing: adjust each level's `party_cap` alongside its goal to maintain achievable earnings.


## Alpha 12.9 — Goal screen navigation fix
- Level briefing now scrolls inside its fixed panel, keeping START, STORE and BACK TO DAY SELECTION accessible. Code updated; Godot runtime test pending.
- Deciding time 3→4 seconds; standard cooking base 4→5; turbo cooking scales from new base; eating 7→8 seconds. Gameplay balance to verify.
- Future cart upgrades (Day 15: 3 dishes; Day 20: 4 dishes) remain planned, not coded.


## Alpha 12.10 — Wallet, fair pricing, optional rewarded videos
- **Coded, not Godot-runtime-tested:** Saved wallet made visible separately from SHIFT CASH in the HUD.
- **Coded, not Godot-runtime-tested:** Result displays wallet BEFORE shift + cash earned = new saved wallet, including non-winning finished shifts. Previous wallet persists in user://pizza_panic_progress.cfg.
- **Coded, not Godot-runtime-tested:** Store purchase feedback shows old balance minus cost equals remaining balance. No double purchase of owned upgrades.
- **Proposed balanced prices (playtesting required):** 4 tables Day 6: 750; 6 tables Day 11: 2,200; 8 tables Day 16: 3,800; turbo oven Day 7: 400; Robot Day 16: 2,300; robot speed Day 18: 850; two-pizza robot Day 20: 1,100.
- **Existing test-only AdMob code retained:** Optional +50 coin rewarded video can be requested again after a completed watch, three-minute cooldown, and successful SDK load. Coins credited only on SDK reward callback. Not available on desktop.
- **Planned:** Add persistent real-money wallet accounting, server-side verification of rewards, ad privacy/consent, economy playtest and progress balancing for Days 1–20.


## Alpha 12.10.2 - Parser fix
- Fixed GDScript purchase flow local declaration (`var wallet_before_purchase: int = wallet_coins`).
- No changes to coin reward (50 coins), upgrade prices, or gameplay rules.
- Static inspection and archive integrity verified; Godot 4.7.2 runtime validation pending.

## Alpha 12.10.3 — Chef ticket queue and Check Order Again
- [x] After **COOK PIZZA**, immediately open the next submitted ingredient ticket when one is queued; the cooked pizza proceeds through the oven/pickup workflow independently.
- [x] Rename **X LATER** to **CHECK ORDER AGAIN**. Deferring saves the current ingredient selections and queues the ticket for review, without cooking it.
- [x] When multiple tickets are queued, deferring one shows the next ticket; when no other ticket is queued, tap ORDER DISH to reopen the saved ticket.
- [x] Clear saved ingredient selections at the start of each level and after successful cooking.
- [ ] Godot runtime QA: multiple queued orders, saved selection restoration, failed recipe, oven pickup, delivery and pause.


## Alpha 12.10.4 — Wrong Pizza & Reuse
- [x] Cook selected toppings even when they differ from the ticket; verify at delivery.
- [x] Wrong pizza rejected: customer upset (-15 patience), combo reset, remake ticket back in chef queue.
- [x] Automatically route returned pizza to another submitted waiting chef ticket with EXACT matching toppings; pizza becomes ready at pickup.
- [x] If no matching order exists, discard returned pizza and allow a fresh attempt.
- [x] Support both waitress and robot delivery paths.
- [ ] Runtime QA in Godot 4.7.2, especially deferred popup and robot interactions.


## Alpha 12.10.5 — Day 6 seating, ingredient warning, and walkouts
- [x] Day 6+ first expansion seating: three 4-seat tables + one 2-seat table = 14 chairs even with optional chair purchase.
- [x] Day 6 briefing highlights picky customers, precise topping matching, rejection, and remake/reuse.
- [x] Guests leaving before ever ordering leave an empty reusable table without a plate or dirty-dish task.
- [x] Later walkouts still produce existing cleaning flow.
- [ ] Runtime QA in Godot 4.7.2.


## Alpha 12.10.6 — Pickup Labels and Table Numbers
- [x] Large, permanent numbered badges on each table.
- [x] Pizza pickup bar displays each ready pizza's assigned table and ACTUAL cooked ingredients.
- [x] Pickup bar rotates among ready pizza labels when more than 3 are waiting.
- [x] Pickup confirmation includes carried table numbers.
- [x] Returned/reassigned pizza uses its new table number on the pickup bar.
- [ ] Playtest display, legibility, multiple pickups in Godot 4.7.2.

## Alpha 12.10.7 — Correct Delivery & Seating Patience
- [x] Successful correct pizza delivery removes deferred/pending chef tickets and closes any stale ingredient popup for that table.
- [x] Chef queue ignores tickets with no remaining seated party; cooked tickets removed from queue.
- [x] Seating restores 50% of lost patience, capped at 100, with floating feedback.
- [x] Correct pizza proceeds to 8-second eating state.
- [ ] Manual Godot runtime gameplay QA.
- [x] Fast order-taking (at least 75 patience remaining) restores 25 patience once per party, capped at 100.


## Alpha 12.10.8 — Pause vs Ingredient Popup
- [x] Pause dialog z-index raised above ingredient builder.
- [x] Pause hides active ingredient builder without discarding ticket or selected toppings.
- [x] Resume restores exact active ingredient builder.
- [x] Exit discards in-progress shift without reopening popup.
- [x] Disallow advancing chef queue while paused.
- [ ] Runtime-test in Godot on desktop/mobile.


## Alpha 12.10.9 — Chef Popup Repeat Fix
- [x] Ingredient popup only opens from submitting orders, pressing Cook for the next ticket, or choosing ORDER DISH to revisit an unfinished ticket.
- [x] Wrong-pizza delivery queues remake without immediately reopening ingredients.
- [x] Correct delivery clears all stale duplicates from chef queue; table enters eating state.
- [x] Resume only restores ingredient popup for an active waiting-chef ticket.
- [ ] Godot 4.7.2 gameplay smoke test on Level 6.


## Alpha 12.11.0 — Mixed simple and custom pizza orders
- [x] Day 6–10: 75% custom ingredient pizzas / 25% classic cheese (expected random share); one requested ingredient for custom pizzas.
- [x] Day 11–15: 65% custom / 35% classic; two ingredients per custom pizza.
- [x] Day 16+: 60% custom / 40% classic; three ingredients per custom pizza (current ingredient count rule).
- [x] Classic cheese orders bypass ingredient popup; cook normally, pickup, deliver, eat, pay.
- [x] Preserve correct recipe verification and remakes for custom pizzas only.
- [x] Pickup bar labels classic cheese clearly.
- [ ] Runtime Godot QA of mixed orders and chef popup queue.


## Alpha 12.11.1 — Natural Customer Arrivals
- [x] Shift begins with one party, not three stacked at the entrance.
- [x] Other groups arrive with mildly randomized spacing across the shift.
- [x] Party caps remain unchanged; customers stop arriving after roster complete.
- [x] Birthday reservation retains its planned special arrival slot.
- [x] Closing stops admission; existing parties can still be served.
- [ ] Test visually in Godot 4.7.2 and tune intervals if required.

## Alpha 12.11.2 — Remove unwanted takeaway Delivery tap
- [x] Remove standalone scooter DELIVERY READY: TAP button and click zone.
- [x] Day 7 replaced takeaway mini-objective with 8 dine-in guests.
- [x] Retain waiter-to-table pizza delivery and pickup bar.
- [x] Remove unused takeaway requirements from scoring so days do not get stuck.
- [ ] Test in Godot 4.7.2.


## Alpha 12.11.3 — Economy and party mix (code changes, pending runtime QA)
- [x] Level 7 cycles 1/2/3/4-person parties; other days include solo diners.
- [x] Target approximately 100 coins per well-served shift and up to approximately 120 on near-perfect service; amounts vary with parties served, patience, and VIPs.
- [x] Expert benchmark 120 coins; minimum pass goal 80 coins.
- [x] Mandatory expansion prices rebalanced for smaller shift payouts: 350 / 650 / 900 coins at days 6/11/16.
- [x] Turbo Oven now 600 coins, unlock day 15; Entertainer 550 coins, unlock day 15.
- [ ] Full 20-day playtesting and tuning of coin targets, arrival pacing, challenge goals, and upgrade affordability.

## Alpha 12.11.4 — Turbo Oven speed
- [x] Turbo Oven cooks every pizza in exactly 3 seconds (including ingredient pizzas); ignores level cooking multipliers.
- [x] Unlock still Level 15; price still 600 coins.
- [ ] Godot runtime testing pending.


## Alpha 12.11.5 - Entertainer unlock timing
- Accordion Entertainer unlocks at Level 20 (was Level 15); 550 coins unchanged.
- Turbo Oven remains Level 15 at 600 coins, 3-second cook time.
- Godot gameplay/store gating still needs runtime verification.


## Alpha 12.12 — Two-Level Progression / Fresh Save
- [x] New save namespace starts from Day 1 with 0 saved coins, unlocked levels and upgrades. Old saves retained separately.
- [x] Every odd Day (1, 3, 5, 7, 9, 11, 13, 15, 17, 19) gets a headline mechanic in the Level briefing; next Day reinforces it.
- [x] Table patience countdown labels from Day 1.
- [x] Double pizzas introduced Day 7: 2 deliveries before eating.
- [x] Extra dishes introduced Day 13: 2 wash pickups needed for affected tables.
- [x] Small 3-dish cart unlock Day 15 (400 coins), large 4-dish cart Day 20 (450 coins, requires small cart).
- [x] Stronger patience-weighted tips from Day 9.
- [x] Turbo Oven still Day 15 (600 coins, 3 seconds); Entertainer still Day 20 (550 coins).
- [ ] Manual runtime QA: two-pizza tickets/robot path, cart pickup and reuse, saves, all 20 levels.
- [ ] Dedicated Level 20 Pizza Toss mini-game remains planned, not implemented.


## Alpha 12.13 — Local Playtest Recorder
- [x] Persist timestamped JSONL records of clicks, table states, arrival/disappearance, chef choices, completed actions, payment/patience, purchases, shift start/finish, pause/resume.
- [x] Add OPEN PLAYTEST LOGS FOLDER button to level/shift screens.
- [x] Preserve normal game save and previous progression; logging has no gameplay timing changes.
- [ ] Runtime verification on macOS Godot, logging exports, full 1–20 analysis.


## Alpha 12.14 — Rush Days & separate bonus mini-game
- [x] Rush Days on Days 5, 10, 15, 20: customer patience drains 25% faster (equivalent to 20% less waiting time) in line and while seated.
- [x] Pre-shift warning and up to +20 coins: +10 completed, +5 no walkouts, +5 perfect (no walkouts or wrong pizzas). Bonus applied once per successful shift, reported separately.
- [x] After winning Day 20, unlock a standalone Pizza Toss bonus stage; never runs during normal restaurant shift.
- [x] Pizza Toss uses a separate 20-second countdown, timing-based accuracy, score/attempt counters and one-time 50-coin achievement reward at 8 accurate tosses; replay for practice.
- [x] Pizza Toss completion reward stored in the fresh-start campaign save, preventing unlimited reward farming.
- [x] Keep Alpha 12.13 gameplay recorder and all previously implemented restaurant mechanics.
- [ ] Runtime QA in Godot 4.7.2 is required, including Day 20 completion flow and mobile UI touch targets.
- [ ] Days 40, 60, 80, 100 bonus mini-games are future roadmap only; they are not included in the 20-day campaign.

## Alpha 12.14.1 — Campaign reset
- [x] New isolated save file for a fresh Level 1 campaign (wallet 0, no owned upgrades, no completed stages).
- [x] Preserve old save files and playtest logs.
- [ ] Test in Godot runtime.


## Alpha 12.14.2 — Waiting party patience
- [x] Waiting parties keep losing patience when every table is occupied.
- [x] Waiting parties keep losing patience when the shift arrival timer reaches zero; no new parties arrive after closing.
- [x] Waiting party cards show approximate seconds left and the existing bar.
- [x] Pause behavior remains unchanged.
- [ ] Run Godot runtime QA (full tables, closing, entertainer, rush day).


## Alpha 12.14.3 — Fast service patience & color bars
- [x] Correct final pizza delivered within 5 seconds of order-taking: increase remaining patience by 25% once.
- [x] Collect payment within 5 seconds after eating: increase remaining patience by 25% once before tip calculation.
- [x] Patience may briefly exceed normal 100-point baseline, capped at 125 points.
- [x] Table and queue patience bars green (>50%), yellow (26–50%), red (0–25%).
- [x] Track fast-service bonuses in playtest logs.
- [ ] Runtime QA, including multi-pizza order, quick payment and UI visibility.


## Alpha 12.15 — Reviews and replay-based earnings
- [x] Each successfully completed day's best walkouts tracked, with one-third star deducted per best-record walkout from five-star restaurant reputation.
- [x] Replaying with fewer walkouts replaces that day's review penalty; a worse replay never harms its best review.
- [x] Each day's highest completed-shift payout tracked; successful replay awards only positive difference over that record; failed shifts pay nothing.
- [x] Review and wallet totals in HUD and local reputation/money records screen.
- [x] Four-star gate on the separate Day-20 Pizza Toss milestone reward. Ordinary shift replay remains available.
- [x] Correct pizza delivered within 5s of order and payment within 5s of meal completion: +25% remaining patience, once each.
- [x] Green-yellow-red table/queue patience bars.
- [ ] Godot runtime testing (especially Day 20 gate, legacy saves, and replay money).


## Alpha 12.16 — Chapter payout display correction
- [x] Correct Level 20 completion screen to show actual incremental wallet gain instead of gross shift payout; prevents misleading earnings display on replays.
- [x] Preserve campaign save namespace, existing progress, reputation, upgrades, rush rewards, logging, and Pizza Toss behavior.
- [ ] Godot 4.7.2 runtime validation unavailable in this build environment; user playtest still required.
- [ ] Full Levels 1–20 balance and regression pass remains outstanding.

## Alpha 12.17 — Waiting time extension
- Added 10 seconds to every newly arriving party’s queue patience, including birthday arrivals.
- Queue clocks still run while tables are full.
- Waiting patience bars scale to the extended starting amount.
- Existing save data, replay accounting, reputation, bonuses, and gameplay logging remain unchanged.
- Static inspection only; Godot 4.7.2 runtime playtest still required.


## Alpha 12.18 — Live review and requested level reset
- Fixed HUD reputation not updating when a party walks out: display immediate -1/3-star preview per walkout.
- Retained best-completed-day replay restoration; no failed-attempt record replacement.
- Reset campaign via isolated save namespace, without deleting prior progress files or gameplay logs.
- Runtime verification pending.

## Alpha 12.19 — Level 5 oven normalization
- Removed Level 5 slow-oven modifier (cook 1.9 -> 1.0): standard pizza cooks in 5 seconds, Turbo Oven in 3 seconds.
- Updated Level 5 challenge text; retained Rush Day mechanics, customer patience, reputation, replay accounting, save namespace, and gameplay logging.
- Godot runtime verification pending.

## Alpha 12.20 — Three-second order bonus
- When a seated party finishes its four-second decision period and shows READY TO ORDER, a three-second response window begins.
- Collecting the order ticket in that window increases remaining patience by 25% (capped at 125), once per party.
- Replaced the old >=75 patience threshold and flat +25 points bonus.
- Preserved existing save namespace, levels, replay accounting, reviews, other bonuses, and gameplay logging.
- Static inspection completed; Godot runtime verification pending.


## Alpha 12.21 — Input timing telemetry and 70-point starting patience
- Customer parties start with 70 patience points, without the prior +10-second queue allowance.
- Seating no longer restores spent patience; quick-action +25% bonuses remain.
- Recorder schema v2 captures raw mouse clicks (including UI), screen taps, and sampled mouse movement every >=100ms and >=12 pixels, alongside existing action/party/table events.
- Log files remain local in `user://playtest_logs` and can be opened from the in-game button. No network upload.
- NOTE: patience points and displayed seconds are not necessarily equivalent because level-specific decay rates and Rush Day modifiers remain in effect. Godot runtime test pending.

## Alpha 12.22 — Action timing recorder
- Removed mouse movement/cursor sampling; records clicks and timing between gameplay action clicks instead.
- Task completion events include elapsed milliseconds since latest action click; existing gameplay events preserved.
- No change to customer patience, level progress, reputation or save namespace.
- Static edit only; Godot runtime validation pending.


## Alpha 12.23 — Requested campaign reset
- New isolated save path: `user://pizza_panic_alpha12_23_reset_levels.cfg`.
- Fresh Level 1, zero wallet and campaign stats, no upgrades, 5-star reputation. Prior saves and playtest logs preserved.
- No changes to action timing recorder or game mechanics. Runtime validation pending.

## Alpha 12.24 — Queue clock calibration
- Set initial queue time to 80 real seconds on standard levels and 70 on Rush Days 5/10/15/20, independent of level queue decay.
- Preserve existing queue countdown, seated patience, action timing recorder, reputation and replay logic.
- Runtime verification in Godot still pending.

## Alpha 12.25 — Automatic upgrade shop prompt
- After a successful shift, if the wallet can buy at least one currently unlocked, prerequisite-eligible upgrade, automatically open the shop with all options.
- Purchases remain optional; close the shop to continue. No automatic spending or interruptions during gameplay.
- Record `shop_auto_opened` in the playtest log. Existing save data and campaign progression are preserved.
- Godot runtime verification pending.

## Alpha 12.26 — Table expansion persists on replay
- Fixed seating_table_count() incorrectly capping purchased tables by replayed day. Owned expansions now show on every level, including Level 4 replays.
- Preserve existing campaign save path, wallet, purchase state, logging and progression.
- Runtime testing in Godot pending.

## Alpha 12.27 — Campaign reset requested
- Fresh save namespace pizza_panic_alpha12_27_reset_levels.cfg; Level 1, zero coins, no upgrades, five stars.
- Old save data and logs left intact; all Alpha 12.26 mechanics preserved.
- Runtime verification pending.


## Alpha 12.28 — Day 5 expansion shop redirect
- After successful Day 5, open the Upgrade Shop directly with the required 4-table expansion explanation (even if coins are insufficient).
- If a later day is gated by a missing expansion, redirect directly to the shop instead of leaving only an EXPANSION REQUIRED button.
- No automatic purchase, save reset, or changes to replay payout logic.
- Added gameplay log events `milestone_expansion_shop_opened` and `expansion_shop_redirect`.
- Godot runtime verification pending.

## Alpha 12.29 — Day 7 double-pizza clarity
- Replaced ambiguous CHEF TICKET table label with explicit pizzas remaining.
- Chef popup shows PIZZA 1 OF 2 / PIZZA 2 OF 2 and logs ticket openings.
- Preserved cooking, orders, timers, save namespace, and progress.
- Further timing balance pending actual playtest logs; Godot runtime not available here.


## Alpha 12.30 — Learning-curve balancing (2026-10-21)
- Levels 6–10: longer shifts and fewer simultaneous parties, particularly Days 7–8, to allow time to learn ingredients, double pizzas, and reservations.
- Levels 6–10: seated service-state patience drain reduced from 1.5 to 1.15 points/sec; queue timers remain 80 sec on normal days and 70 sec on Rush Days.
- Selected goals reduced to match gentler learning curve.
- No save namespace changes, campaign reset, or changes to reputation, purchases, or action-timing logging.
- Static code patch only; Godot runtime verification pending.

## Alpha 12.31 — Fresh campaign reset
- User-requested reset to Level 1, zero coins, five-star reputation, no purchased upgrades, and only Level 1 unlocked.
- New save namespace `pizza_panic_alpha12_31_reset_levels.cfg`; previous campaign files and gameplay logs are not deleted.
- Retains Alpha 12.30 learning curve, action timing recorder, upgrades, and all other mechanics.
- Godot runtime verification pending.

### Alpha 12.32 — Table capacity colors
- Four-seat tables use red mats; two-seat tables use yellow mats.
- Colors derive from actual seat count, including chair upgrades and earlier-level replays.
- No gameplay, save, or campaign reset changes. Godot runtime test pending.

### Alpha 12.33 — Three-second delivery patience bonus
- Correct final pizza delivered within 3 seconds of order collection gives +25% of remaining patience (once per party).
- No campaign reset; all other mechanics unchanged.
- Caveat: standard oven takes 5 seconds, so this threshold may be unattainable in ordinary play. Revisit bonus start event during balancing.
- Static code verification only; Godot runtime test pending.

## Alpha 12.34 — Quick Delivery Timing Fix
- Quick delivery +25% remaining patience now checks 3 seconds from pizza READY at pickup, not order collection.
- Logs `pizza_ready_for_pickup` for timing analysis. No campaign reset.
- Godot runtime test pending.

## Alpha 12.35 — Mandatory dish cleanup
- All levels now require every dirty dish set to be collected and washed before opening results / next level.
- Includes double-dish tables and dishes already on the cart. No save reset.
- Runtime validation in Godot still required.

## Alpha 12.36 — Unpaid meal walkout
- If patience expires at payment after eating, party leaves with zero payment/tip, -1/3 star, and dirty dishes (including double dish sets).
- Dish cleanup remains mandatory before results; log `unpaid_meal_walkout`.
- No campaign reset. Godot runtime test pending.

## Alpha 12.37 — Shop purchase flow
- After a successful upgrade purchase, close Store and show START LEVEL briefing without navigating through Day Selection.
- If purchased from a successful day-results screen, advance to the next day first. No automatic shift start, no progress reset.
- Gameplay event `upgrade_return_to_start` recorded. Runtime verification pending.

## Alpha 12.38 — Table chef-ticket shortcut
- A table displaying `TAP: 1 PIZZA LEFT` or `TAP: 2 PIZZAS LEFT` now opens that table's specific ingredient-selection popup when clicked.
- Prioritizes the selected table's pending ticket without discarding other tickets or ingredient selections.
- Cooking and pickup still follow existing kitchen workflow; this is only a shortcut to the correct ingredient selection.
- Records `chef_ticket_table_shortcut` in playtest logs. No campaign reset or save namespace change.
- Godot runtime testing pending.

## Alpha 12.39 — Day 12 waiting-time balance
- Day 12 (Topping Trouble) starts arriving parties with 110 seconds of queue waiting time instead of 80.
- Day 12 arrivals spaced 6.0 seconds apart instead of 4.0; shift arrival window extended from 90 to 110 seconds so the 17-party cap remains achievable.
- Other days retain 80-second normal / 70-second Rush Day queue clocks.
- No save namespace change or progress reset; playtest action logging preserved.
- Static code verification performed; Godot runtime testing pending.

## Alpha 12.40 — Seating patience bonus
- Seating a waiting party grants +50% of its remaining patience once, at the moment of seating.
- The patience bar maximum expands if needed; the existing 25% quick-action bonuses remain.
- Added seating before/after patience and bonus percentage to playtest logging.
- Retains Alpha 12.39 Day 12 timing changes and campaign save behavior; runtime test pending.


## Alpha 12.41 — Mobile-first input reliability
- Existing tap-to-plan waitress FIFO action queue retained; capped at four planned stops to reduce stale taps.
- Deduplicate touch-generated synthetic mouse events (350 ms, 28 px) to prevent double actions on mobile.
- Backspace clears pending planned stops on desktop; logs `planned_actions_cleared`.
- Existing landscape 1280x720 layout and game mechanics preserved. Touch UI resizing and real device validation still pending.
- Godot 4.7.2 runtime not available in build environment; code inspection only.


## Alpha 12.42 — Day 11 Learning Curve
- Day 11 shift arrival window increased from 90 to 115 seconds.
- Day 11 party cap reduced from 16 to 12 and spawn interval increased from 4 to 7 seconds.
- Keeps two-ingredient recipes, existing customer patience and seating bonuses, upgrades, save namespace, and gameplay recorder.
- Runtime playtest in Godot 4.7.2 pending; no save reset.

## Alpha 12.43 — Wrong-ingredient delivery validation
- Validate the actual cooked toppings against the requested toppings for every ingredient-bearing pizza, including deliveries by the robot.
- Reject mismatched pizzas, apply the existing patience penalty and remake workflow, and record rejected/accepted deliveries with ingredient details.
- Preserve campaign save namespace, level 11 pacing, and all other gameplay mechanics. Runtime validation in Godot remains pending.

## Alpha 12.45 (2026-10-21)
- Added guided first-day popup sequence, tutorial pause, skip and replay controls.
- Added purchase confirmation for upgrades.
- Replaced large expansion jumps with one table at Days 6, 11 and 16.
- Added Day 13 full-wallet serving tray and one-pizza pre-tray carry restriction.
- Requires Godot runtime validation; do not mark as fully playtested.

## Visual assembly preview
- Added independent `RestaurantVisualPreview.tscn` for early asset layout validation.
- Imported four user-provided transparent PNG atlases, without modifying campaign saves or logic.
- Interactive 3–8 table placement test and kitchen cutout placement.
- Next: refine individual sprites and connect visuals to existing gameplay state after user approves layout.

## Alpha 12.53 — Approved restaurant interactive layout
- Added approved 8-table restaurant illustration as the visual layout backdrop for `scenes/RestaurantVisualPreview.tscn`.
- Implemented touch/mouse hotspots for tables 1–8, with 7–8 initially locked, visual seating markers, and expansion preview controls.
- The backdrop is still a flattened concept illustration: customer, oven, floor, and table sprites are not yet individually separated or wired to the real campaign logic.
- Campaign gameplay and saved data deliberately remain unchanged pending sprite extraction and integration testing.

## Alpha 12.54
- Integrated four waitress poses and four chef poses into live gameplay rendering.
- Preserved existing mechanics and campaign save handling.
- Pending: Godot runtime test, full walking-cycle animations and visual alignment tuning.


## Alpha 12.56 Graphics Editor
Added separate GraphicsEditor scene, ID-based asset mapping catalog, image-path assignment, drag positioning, size adjustment, visibility toggle, and user:// layout persistence. Gameplay drawing is unchanged until asset mapping/integration phase.

## Alpha 12.68 — Reusable screen motion (2026-10-25)
- Added scripts/ui_motion.gd: reusable native-Control button highlight and idle glow across navigation, store, stage browser, tutorial and other dynamically created UI, with subtle menu headings and opening-background breathing. Original button hitboxes, pressed signals and gameplay logic preserved.
- Added scripts/logo_drips.gd: procedurally animated golden/orange drips attached to Main Menu heading. Drawn transparently, no checkerboard asset or flat overlay.
- Animation setup runs after all primary UI is initialized. Future buttons are discovered automatically.
- Character pose images remain static artwork; genuine multi-frame sprite animations and per-scene art choreography remain pending source artwork and runtime visual QA.
- Godot binary unavailable in this environment, so engine execution, scene layout and iOS/Android touch QA are NOT claimed.


## Alpha 12.69 — Approved waitress walking sprites (2026-10-25)
- Added approved 8-frame walking sequence as original RGBA art, normalized game-ready horizontal sheet and 8 individual RGBA PNGs.
- Added reusable Godot SpriteFrames animation resource with walk loop set to 8 FPS and an asset manifest.
- Existing gameplay untouched; animation playback on moving waitress must be linked during character-state integration and engine-tested.
- Next: chef walking and chef oven/tray/turning/ingredient actions, pending visual approval.

## Alpha 12.69 — approved chef animation batch 2
- Approved 4-frame chef front preparation and 4-frame chef rear oven-loading poses, transparent RGBA PNG at 768x800 per frame.
- Loaded and selected automatically by the cooking visual layer.
- Chef cooking state machine, customer patience, money, levels, shop, timers, and scoring left unchanged.
- Chef oven-out/turn/tray animation awaits user review.
- Validation: source paths / metadata / alpha and ZIP integrity; no Godot runtime test available.

## Alpha 12.70 — chef oven-out / turn animation approved
- Four individual 768x800 RGBA true transparent sprites added under assets/animations/chef/oven_out/.
- Hooked 4-frame visual sequence to existing 'cooking -> ready' transition; no changes to cooking durations, tables, money, patience, level progression, or control inputs.
- Chef now visually withdraws pizza from the background oven and rotates toward existing tray area. Background oven and tray remain separate and unmodified.
- Approved walk (8), pizza preparation (4), oven-in (4), and oven-out/turn (4) sprites are retained.
- ZIP asset and patch verification passed; interactive Godot test not run because Godot executable unavailable in build environment.


## Alpha 12.71 - Customer 01 Yellow Chair Approved
- Eight approved yellow-seat visual sprite cutouts added (left/right: waiting/menu/bite/chew), 640x928 RGBA.
- Added per-side Godot SpriteFrames resources and 26-slot character manifest.
- No gameplay code or scene state machines changed by this batch; visual wiring/gameplay tests pending.
- Extracted atlas silhouettes need small-edge visual validation in Godot at play size.


## Alpha 12.72 — Levels 1–5 party size changes
- Level 1 and 2 accept only parties of 1 or 2.
- Level 3 introduces parties of 3 or 4; first appearance guaranteed.
- Levels 4 and 5 increase the share of large parties.
- Party rosters are 8, 9, 10, 11, 11 respectively.
- Level 2 mission updated from impossible 3/4-person seating to serving 7 guests.
- All character artwork and game systems retained; Godot playtest remains pending.


## Alpha 12.73 — Yellow tables and red conversions
- On Levels 1–2, Tables 6/7/8 are yellow with two seats each.
- Starting on Level 3, each available yellow table can be purchased as a permanent red four-seat conversion for 150 coins. Multiple conversions may be purchased in the same store visit with accumulated coins.
- The Level 6 expansion adds yellow Table 4; later expansions also start yellow.
- Old save key `chairs` still upgrades Table 7; all conversions are saved separately.
- Parties of three and four start from Level 3 after a red table is acquired. Otherwise arrivals are capped at two to avoid impossible seating. The birthday reservation uses the same safety fallback.
- Godot editor/runtime playtesting is still pending. ZIP and static checks completed.


## Alpha 12.74 — Approved main menu art and click targets
- MainMenu now uses provided full-screen 2048x1155 restaurant illustration, scaled to 1280x720 game viewport.
- Functional separately clickable transparent button artwork laid on the original board, top-to-bottom: Play, Shop, How to Play, Settings.
- Button routes reuse existing game navigation (`play`, `upgrades`, `help`, `settings`), with no changes to gameplay state machines or level rules.
- Removed opening `SKIP INTRO` button; original `NEXT`/`MAIN MENU` flow retained.
- Asset and code references checked statically. Godot runtime/mobile tap validation remains pending in engine. Optional third-party font in AdMob editor theme omitted, using engine fallback.


### Alpha 12.75 — Story navigation button
- Story 1 and Story 2 use the supplied green `next-button-story.png` artwork on a clickable `TextureButton`.
- Existing flow preserved: automatic initial screen → Story 1 → Story 2 → Main Menu.
- No changes to stage gameplay, save data, or other screen navigation.
- Static checks passed; actual Godot playtest required.


## Alpha 12.76 — How To Play tab artwork
- Full-screen How To Play background uses uploaded `how-to-screen-v2.png`.
- The five uploaded blue buttons display only for the active tab; hidden brown buttons remain in the background.
- Basics displays the user's example instructions artwork (seat, order, cook, serve, clean).
- Kitchen, Customers, Tips and Reputation show editable placeholders pending user-approved content.
- The BACK button returns to Main Menu; existing gameplay is untouched.
- Godot runtime test pending.

- Red close icon at upper-right of How To Play board returns to Main Menu.
- Replaces interim bottom-left Back button. Other help tabs and gameplay unchanged.
- Expanded Basics content crop to avoid truncating rightmost text in supplied example.


## Alpha 12.79
- New image-backed pre-level screen with approved challenge checklist icon, actual goal/party data, Start Level and Close actions.
- New high-resolution Level Select storefront (20 tiles/page, 5 pages). Saved coin wallet, unlocked levels, 3-star ratings and chapter star counter are dynamic.
- Existing level gates, saved campaign progress, upgrades, and gameplay unchanged.
- Runtime test in Godot remains pending.


## Alpha 12.80: Shop screen graphical integration
- Uses user-supplied original Shop background, icon PNGs, green Buy buttons, red Close, and single right arrow (wraps).
- Three upgrades/page. Page 1: Chairs +, Carrying Tray, Dish Tray. Other purchases follow on pages 2–5.
- Chairs + targets next purchasable yellow table, allowing repeated permanent conversions.
- Purchase confirmation and wallet/best-level persistence reused from main.gd. Locked, unavailable, and low-balance purchases disabled.
- Shopping no longer automatically jumps a level; multiple purchases allowed in one visit. Existing prices/unlock levels remain unchanged.
- Click Shop from Main Menu or pre-level. Close from menu returns to Main Menu.
- All original high-resolution source PNGs preserved, scaled only in Godot.
