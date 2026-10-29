# Alpha 12.41 — Mobile-first input reliability

The game already had a tap-to-plan queue. This release fixes mobile duplicate tap processing and limits the queue to four upcoming stops. Finger taps and mouse clicks share the same action path. Backspace clears queued actions on desktop.

Test on mobile: tap once on a party/table; confirm it does not process twice. While waitress walks, tap two upcoming destinations; verify FIFO completion. Test ingredient overlay, shop, pause and replay saves.

No progress reset. Runtime validation pending.
