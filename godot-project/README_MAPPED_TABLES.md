# Pizza Panic — Saved table layout integration

Your uploaded `graphics_layout.json` is now bundled under `data/graphics_layout.json` and read at startup.

Permanent numbering: top row 1–2, middle 3–5, bottom 6–8.
Level 1 playable positions: 6 (red/4), 7 (yellow/2), 8 (red/4).
Chair upgrade changes Table 7 from yellow/2 to red/4 with the same mapped center and size.
The three expansion purchases add tables 4, 3, and 5 in that order; positions 1 and 2 stay locked until future expansion upgrades are authored.
Unopened tables are shown with the existing `table-unlock.png` overlay, and do not accept seating clicks.
Existing cooking, serving, payments, patience, replay and save behaviors were left in place.

Note: The current progression supports purchasing up to six tables. Seven/eight table unlocks require new progression rules.
The table mapping `x`, `y`, `width`, `height`, `scale` and art paths come directly from the uploaded layout.
The gameplay background uses `assets/replacements/backgrounds/game-play-screen.png`; change that file to your CLEAN unnumbered backdrop when ready.
