# Visual assembly preview (experimental)

Open `scenes/RestaurantVisualPreview.tscn` in Godot 4.7.2 and press **F6** to run the preview scene. The main game remains unchanged and still launches through `scenes/Main.tscn`.

This preview imports the user's four original transparent asset sheets and assembles a clickable dining room with three starting tables, a kitchen region, sample pizza placement, and an expandable layout of up to eight tables. Tap a table to toggle its sample pizza, or tap + TABLE / - TABLE to expand or shrink the preview. This is an asset/layout integration prototype, **not** a fully connected replacement gameplay scene. Some sheet cutouts are approximate and require production-quality per-sprite segmentation and scale calibration.

No existing campaign logic, levels, upgrades, or saves are modified.
