# Pizza Panic Alpha 12.68 — Animation foundation

Based on supplied Alpha 12.67. Integrated reusable animations in `scripts/ui_motion.gd` and `scripts/logo_drips.gd` into the existing `Main.tscn` project's `main.gd`.

- Native buttons across screens: gentle idle glow and brighter pointer-hover feedback.
- Main menu and other modal titles: subtle animated color pulse.
- Logo heading: looping pizza-cheese/sauce-style falling drips, transparent and procedural.
- Opening image: gentle opacity breathing.
- Newly created store/UI buttons are discovered automatically; no scene-by-scene animation programming needed.

**Not yet done:** true multi-frame character animations, independent art movement on *every* scene, or spritesheet processing. Those require further implementation and artwork. The package retains the source project's 105 PNG files, but these do not constitute 100 verified unique sprite animations. Game execution not verified here (Godot 4.7 runtime unavailable).
