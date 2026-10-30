Pizza Panic Alpha 12.92 — Menu and Shop Navigation Repair

- Settings navigation now explicitly hides any stale level-select / pre-level interface before showing Settings.
- Settings page is raised above other menus and refreshed when opened.
- Shop is raised above pre-level and navigation UI.
- Shop close X and next arrow now call close_store() and next_page() directly, rather than no-op handlers.
- Removed the redundant global Shop mouse handler to prevent double triggering.
- Gameplay, assets, level logic, and purchase mechanics unchanged.

Validation: script-level checks and ZIP integrity; no Godot runtime installed in this environment.
