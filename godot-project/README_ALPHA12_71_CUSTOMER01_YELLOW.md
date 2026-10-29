# Alpha 12.71 — Customer 01 (Yellow Chair Batch)

Approved yellow-table positions only (8 sprites: left and right × waiting, menu, bite, chew).
Each sprite has genuine transparent alpha, is character-only (no table or chair baked in), and occupies a padded 640×928 pixel RGBA canvas for stable animation placement. Do not draw a new furniture layer; use the yellow table already in the game, and preserve visible jeans and pink sneakers beneath the edge of the table.

`assets/animations/customers/customer_01/manifest.json` defines all 26 required character slots. Eight yellow sprites are approved; standing and red-table poses are pending integration. `yellow/yellow_left.tres` and `yellow/yellow_right.tres` supply SpriteFrames with waiting/menu static poses and a two-frame 2 fps eating loop for future visual hookup. The original gameplay code and scenes have not been changed by this batch. Godot execution is not verified here.
