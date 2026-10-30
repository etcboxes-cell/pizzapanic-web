# Alpha 12.54 — Animated character art integration (first pass)

This build replaces the procedural waitress and chef figures in the gameplay drawing with the supplied illustrated character poses. The waitress selects among carrying pizza, taking orders, carrying dishes and serving; the chef switches between idle, working and pizza-ready poses. Character textures are preloaded once and scaled at runtime. Existing gameplay, timing, saved progress, and input remain unchanged.

This is a pose-based first pass, not yet frame-by-frame walking animation. The supplied 4-pose character art was cropped into separate transparent PNGs in `assets/characters`. Additional sprite-sheet frames can be incorporated later.

Test in Godot by opening `project.godot` and running the project. No Godot executable was available here for a runtime verification.
