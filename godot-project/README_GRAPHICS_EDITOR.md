# Pizza Panic Alpha 12.56 — Graphics Positioning Editor

Open `scenes/GraphicsEditor.tscn` and press **F6** in Godot, or click **GRAPHICS EDITOR** at the bottom right of the main game. The editor is a **standalone alignment and mapping tool**, not yet a replacement of the original code-drawn graphics.

## Your workflow
1. Copy each transparent PNG to `assets/replacements/`.
2. Select an item by its ID in the editor.
3. Type `res://assets/replacements/your_image.png` and click **APPLY IMAGE**.
4. Drag the preview to position it, or enter X/Y coordinates and size percentage.
5. Click **SAVE LAYOUT**. Layout data is saved at `user://graphics_layout.json`, separate from campaign saves.
6. Send your PNGs and naming/mapping list back for connection to the live gameplay draw functions.

There are **85 unique named mapping targets** in `GRAPHICS_ASSET_MAPPING.csv`. These are **mapping targets, not included images**. There are no fabricated 100 PNGs in this build.

## Important limitations
- The editor preview displays the **selected object** on a simplified canvas. It does not replace the actual gameplay render yet.
- It does not edit table seating, tap zones, timers, upgrade rules, customer logic, or saved progress.
- If you open the editor from the running game, the current shift will restart when you return; finish/save first.
- For shipping mobile builds, remove or hide the development editor launcher.
- New PNGs should have true alpha transparency; avoid checkerboard patterns.
