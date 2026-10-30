Pizza Panic Alpha 12.60 — Table 7 texture selection fix

The gameplay renderer now explicitly selects table-7-yellow.png for the 2-seat version of Table 7 and red-7-table.png for its upgraded 4-seat version. All saved position and size values are unchanged, and the existing seating/cooking/progression logic is retained.

Current mapped Table 7: center (668, 588), scale 2.15. All eight table mappings are included in data/graphics_layout.json.

To test: import project.godot, start Level 1 on a new or non-upgraded profile, verify Table 7 is yellow. If the two-chair upgrade was already purchased in the saved progress, red is intentional; test with an unupgraded profile instead of deleting your progress.

Godot could not be executed in the packaging environment; please test in the editor.
