# Pizza Panic playtest recording

## How to record and send
1. Play normally from Level 1 through 20. The game records the session **automatically** when it launches.
2. When finished or between sessions, click **OPEN PLAYTEST LOGS FOLDER** from the level introduction or results screen.
3. Select every `pizza_panic_*.jsonl` file and compress to one ZIP (Finder: right-click > Compress).
4. Upload **that ZIP of logs** to ChatGPT, rather than only zipping the game project.

Each launch creates a separate file; send all of them if you restart Godot while testing. Do not rename or change the files.

## What's measured
- Monotonic session milliseconds and game elapsed seconds
- Every gameplay tap (local game coordinates), queued actions, task completions
- Arrivals, queue departures, table state transitions, order and cooking stages
- Chef ingredient choices, wrong pizzas, payment amounts and customer patience
- Shift results, upgrades, pause/resume/abandoned shifts

Individual stages are reconstructed by subtracting adjacent transition timestamps. Pauses do not count toward game elapsed time. There is no internet upload.

## Limitations
- Godot user:// data is stored outside the project directory, so project.zip alone does not contain your recorded clicks.
- The local log records input coordinates, NOT operating system screen recordings.
- These are instrumentation changes only; balance settings are intentionally unchanged so we can measure the baseline.
- Godot runtime testing must verify that the logging button and trace work correctly.
