# Alpha 12.86 screen integration

- Main game now instantiates the editable HowToPlay.tscn screen, so changes in the editor affect the actual game.
- All five tabs use fixed-size TextureButtons, with content panels in the correct parchment area. Close returns to main menu.
- Opening overlay is above the menu (z=900 vs 600) to prevent the menu hiding it.
- The uploaded ZIP does not contain initial-screen.png, story1.png or story2.png at the paths referenced by the game. The opening flow now shows labeled fallbacks until those approved files are provided. Intro -> Story 1 -> Story 2 -> Menu remains wired.
- Gameplay mechanics have not been intentionally modified.
- This package has not been run in the Godot editor; visual testing is still required.
