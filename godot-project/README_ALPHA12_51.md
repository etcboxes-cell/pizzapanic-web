# Alpha 12.51 — Cinematic Intro (Mac / Godot 4.7.2)

On launch: animated Pizza Panic title over the existing reference artwork, three story beats, Skip Intro and LET'S COOK. On subsequent launches: two-second logo sequence. Replay the full opening via the day-selection screen (the replay currently uses the short returning-player version). Intro seen state is stored at `user://pizza_panic_intro_seen.flag`, independent of the campaign save.

No campaign reset. No gameplay economy changes. Note: this is a Godot UI-based cinematic, not a pre-rendered video. Runtime testing in Godot is still required.
