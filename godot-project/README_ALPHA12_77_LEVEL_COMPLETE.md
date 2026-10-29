# Pizza Panic Alpha 12.77 — Level Complete Screen

- Uses supplied `complete-level.png` (2048×1155) as a full-screen background.
- 3 dynamically updated gold/gray stars use the game's existing `earned_stars(true)` score.
- Coin counter shows coins **actually awarded to the wallet this run** (a replay only awards a new personal-best improvement). No fake score is used.
- Customer counter shows people successfully served / people who arrived during the shift (tracks arrivals without changing party selection).
- Replay uses `try_start_game()` to restart the same level; Next Level uses the existing `next_level()` logic. No changes to cash, unlock, or stored-score calculations.
- Optional upgrades and milestone mini-game prompts remain accessible, but appear after Next Level instead of covering results.
- Final (100th) level hides Next Level; previous failure and endless-results UI are preserved.
- Coordinates target 1280×720 virtual viewport. Original images are kept at source resolution; in-game textures only scale when rendered.
- Godot runtime testing is pending; static checks and ZIP CRC validation performed.
