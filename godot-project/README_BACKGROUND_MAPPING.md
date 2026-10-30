# Pizza Panic Alpha 12.58 — background-aware positioning editor

Run `scenes/GraphicsEditor.tscn` as Current Scene. The mapper now starts with the actual Gameplay background. A Background/Scene dropdown in the right sidebar can switch between the 11 source backgrounds. You may paste any `res://` background path and click LOAD BACKGROUND.

To position tables 1–8, select **Gameplay** and each `PP-TABLE-XX` row, then set or drag the image. Image coordinates remain in the original 1280x720 mapper layout and are shown over the restaurant at a 0.75 preview scale (960x540). Because the background is 3200x1806 rather than 16:9, there is a slight ~0.3% aspect-ratio mismatch; this edition uses stretch-scale solely as the alignment guide. Do not treat visual preview as an engine-validated collision/hitbox mapping.

SAVE LAYOUT still stores `user://graphics_layout.json`, not inside the ZIP/project. To retain a prior layout on the same computer, open this new version with the same Godot app user-data folder name (unchanged project display name), or copy the JSON to the new user:// location. All existing IDs and gameplay code are unchanged.

This editor is still a layout PREVIEW. It does not yet drive runtime live sprite variations or update hitboxes. Red/yellow table variants are a pending feature. The game starts with tables 6, 7, 8 under the intended rules, but this code patch does not change their underlying state.
