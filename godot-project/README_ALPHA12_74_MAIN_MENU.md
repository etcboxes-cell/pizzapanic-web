# Pizza Panic Alpha 12.74 — Main Menu

**Approved visual:** `assets/ui/main_menu/main-menu-screen.png`

## Board button order, top to bottom
1. Play — existing Level Select
2. Shop — existing Upgrades store
3. How to Play — existing tutorial guide
4. Settings — existing preferences

Main menu artwork uses full 1280×720 viewport; button anchors in game pixels: x=924, width=294, height=76; y=296/387/478/569. All the click targets are independent Godot TextureButtons to preserve navigation and touch support.

Opening skip-intro button removed as requested; Next and Main Menu remain.

**Testing:** ZIP and asset references verified; Godot runtime validation pending.
