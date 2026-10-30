# Pizza Panic Alpha 12.82 — Universal Button Press Feedback

This update retains Alpha 12.81 game files and adds a global, visual-only button animation.

## Effects
- On touching/holding any enabled `BaseButton`: squashes to 97.5% width / 87% height and darkens briefly (0.065 seconds).
- On releasing: animates back to the exact original scale, tint, and pivot (0.13 seconds).
- Uses an upper-third pivot so the press appears to move inward, like the provided Quit example.
- Includes Godot `Button`, `TextureButton`, and other `BaseButton` controls (image-based, text-based, and runtime-created).
- Click callbacks, game timers, purchasing/coins, saves, and progression remain unchanged.
- Disabled buttons do not animate. Frees old tweens when buttons leave the scene.

## Implementation
- `scripts/button_press_fx.gd` is loaded by `[autoload] ButtonPressFX` in `project.godot`.
- No extra sprite files are needed for the pressed state; the effect uses the original high-resolution art and GPU transforms.
- `scripts/ui_motion.gd` continues controlling unrelated glow/hover/intro animations.

## How to check in Godot 4.x
1. Open `project.godot` and run the game.
2. Press and hold **Play**, **Shop**, **Settings**, **How to Play**, and other buttons; they must visibly squash/darken under the finger or mouse.
3. Release; the button should spring back and its existing action should fire exactly once.
4. Test both **Buy** and **Cancel/Close** with disabled and enabled upgrades; coin/purchase logic must not change.
5. Test generated buttons in Level Select and Shop page changes, plus in-game buttons and Pause.
6. Use keyboard focus + Space/Enter on buttons to verify equivalent behavior.

Static packaging/integrity has been checked. Full runtime verification still requires opening it in Godot.
