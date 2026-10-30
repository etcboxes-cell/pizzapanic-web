# Pizza Panic Alpha 12.3 — AdMob mobile test integration

Base: User-uploaded Alpha 12.1 with installed Poing Studios AdMob addon.

- Run on desktop to test gameplay; desktop will never load an ad.
- Export to iOS/Android with plugin enabled and appropriate native dependencies installed.
- All ad units in `scripts/admob_bridge.gd` use Google sample IDs because `TEST_MODE = true`.
- Production App IDs are in `project.godot`; production ad unit IDs are in bridge constants but are NOT used until TEST_MODE is intentionally set false after review.
- After Days 4, 6, 8... completed for the first time, the Next Day action may show an interstitial when cached and eligible; if not available, advance immediately.
- Mobile pre-level panel has a voluntary +50 coin rewarded-ad button; coins are issued ONLY on reward callback.
- $5.99 Remove Ads is not yet implemented. Do not simulate purchase as paid.
- Privacy/consent SDK, purchase verification, SSV, anti-fraud, live ads, and on-device acceptance tests remain pending.
- Source-only change: not runtime-tested in Godot; report parser errors for immediate patching.

Alpha 12.3.1: Fixed Node.ready name collision in scripts/admob_bridge.gd.
