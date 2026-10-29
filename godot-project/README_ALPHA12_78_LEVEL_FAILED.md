# Pizza Panic Alpha 12.78 — Level Failed Screen

- Original high-resolution user artwork preserved: `fail-level-screen.png`, `replay-button(3).png`, and `select-level-button-fail.png`.
- 3 silver stars taken from the previously supplied `gray-star.png`.
- Coins shown are actual wallet gains for the failed attempt (0 under current campaign rules).
- Red angry face counter is *served guests / guests arrived* to mirror the example's 10/21; no fictitious sample numbers displayed during gameplay.
- Replay restarts the **same** level via `try_start_game()`.
- Select Level uses `show_stage_select()` and preserves all unlock and saved-progress rules.
- Applies only to failed campaign days. Successful results and Endless mode remain unchanged.
- All positions target the game's 1280×720 virtual viewport; original PNGs are not resampled in the project ZIP.
- ZIP CRC and structural assertions checked; a real Godot runtime playtest is still required.
