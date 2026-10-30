# Pizza Panic Alpha 12.75 — Story Next Button

The supplied green Next button has been added as `assets/ui/story/next-button-story.png` (RGBA with genuine transparency).

- Story 1: tap the image button to show Story 2.
- Story 2: tap the same image button to open the Main Menu.
- Initial screen: button is hidden until Story 1.
- Placement: lower-right in the game's 1280×720 design coordinates (1010,585,220×110), image retains 2:1 aspect ratio.
- Existing game logic, levels, purchases, and navigation preserved.

Validation: image alpha checked, archive CRC/ZIP read verified and flow references statically verified. Runtime Godot testing not performed.
