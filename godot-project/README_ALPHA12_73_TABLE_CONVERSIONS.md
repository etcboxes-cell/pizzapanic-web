# Pizza Panic Alpha 12.73 — Yellow Table / Red Conversion Progression

## What changed
- Levels 1 and 2: starter Tables **#6, #7, #8** are all yellow, two-seat tables (6 seats total).
- Level 3 onward: convert any currently owned yellow table to red (4 seats) for **150 coins per table**, one permanent purchase per table. No per-level conversion limit: buying more is limited only by earned wallet coins.
- Conversions can be made between shifts in **STORE / UPGRADES**; no automatic purchases. The shop stays open after each conversion, allowing multiple purchases in one visit.
- The user may, for example, convert #7 at Level 3 and #6 at Level 5 (or sooner if they have enough coins).
- On Level 6 the fourth-table expansion remains a separate purchase (350 coins), adding a yellow two-seat Table #4. That new table can then be converted for another 150 coins. Future expansions follow the same rule.
- The original Table #7 upgrade key `chairs` is preserved so existing saves remain compatible. Other conversions have unique saved purchase keys.
- Level 3 continues introducing 3- and 4-person parties **after the first red conversion**. If the player does not buy one, those larger arrivals are temporarily replaced with 1- or 2-person parties to avoid unseatable parties.
- The Level 8 birthday reservation is a group of 4 when red seating exists, or a group of 2 if not; optional upgrades do not block progression.
- Yellow art uses the approved Table #7 yellow two-chair asset wherever a unique yellow PNG is not available; red art uses each table's red PNG.
- Purchases persist in save data and replays, though Levels 1 and 2 always render yellow two-seat tables for early-level teaching.

## Unchanged
- Existing customer, chef and waitress PNGs, animation resources, kitchen rules, payment rules, coins, cooking, timers, and party counts.
- No requirement to buy an upgrade to pass a level. Existing table expansions remain optional.

## QA status
- Verified static game-code logic, data consistency, sprite path existence, and ZIP integrity.
- Godot GUI/runtime playtest is still required (no Godot binary in this environment).
