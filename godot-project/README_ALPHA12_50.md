# Alpha 12.50 — Patience-based tip reduction

When a party finishes eating, its remaining patience is recorded. At 25 seconds or above, its tip is unchanged. Below 25 seconds, only the tip portion is multiplied by remaining_patience / 25, reaching zero at 0 seconds. Base pizza earnings are unchanged. The snapshot prevents a second tip penalty while awaiting payment. Quick payment bonuses still work for customer patience. No save reset.
