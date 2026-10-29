# Pizza Panic Alpha 12.16

Based directly on Alpha 12.15. No progress reset or save namespace change.

## Fix
The Level 20 chapter-complete panel previously displayed gross cash plus Rush bonus as newly earned wallet coins, even on replays that award only an improvement. It now displays `wallet_gain`, consistent with the saved wallet and the other levels.

## Playtest
1. Complete Level 20 and note wallet gain.
2. Replay with equal or lower gross payout; verify wallet gain displays 0.
3. Replay with higher payout; verify only the difference is awarded.
4. Check the 4-star gate and separate Pizza Toss access.
5. Confirm existing saves, upgrades, and playtest JSONL logs persist.

This package has not been runtime-tested in Godot 4.7.2 in this environment.
