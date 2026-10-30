# Restaurant review and replay economy
A completed day's record stores best payout including Rush bonus and fewest walkouts.
Your wallet receives only MAX(0, new day payout - previous best), on a successful shift.
Review starts at 5.00, decreases 1/3 star per recorded unhappy walkout across all completed days, and can improve by replaying days with fewer walkouts.
Four-star review required for separate Pizza Toss after Day 20; below threshold, replay earlier days until reviews improve.
Older save compatibility: days that have pre-existing best_cash but no old walkout records are treated as 0 walkouts, because historic walkouts were not saved. A new clean start uses actual counts.
The day-end status shows gross payout and incremental coins. Testing is required in Godot.
