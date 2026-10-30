extends Control
## Alpha 12.81: High-resolution, properly scaled Settings UI.
## The four rows are independent controls, not words baked into the artwork.
var game: Node
var music_switch: TextureButton
var effects_switch: TextureButton
var status_label: Label
const UI_SIZE := Vector2(1280, 720)
const ASSETS := "res://assets/ui/settings/"
# Replace this with the official game Instagram URL when supplied.
const INSTAGRAM_URL := ""

func texture(parent: Control, filename: String, pos: Vector2, dimensions: Vector2) -> TextureRect:
    var view := TextureRect.new()
    view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    view.texture = load(ASSETS + filename)
    view.custom_minimum_size = Vector2.ZERO
    view.position = pos
    view.size = dimensions
    view.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(view)
    return view

func picture_button(parent: Control, filename: String, pos: Vector2, dimensions: Vector2, action: Callable) -> TextureButton:
    var view := TextureButton.new()
    var art: Texture2D = load(ASSETS + filename)
    view.texture_normal = art
    view.texture_pressed = art
    view.texture_hover = view.texture_normal
    view.ignore_texture_size = true
    view.stretch_mode = TextureButton.STRETCH_SCALE
    view.position = pos
    view.size = dimensions
    view.pivot_offset = dimensions * 0.5
    view.focus_mode = Control.FOCUS_ALL
    view.mouse_filter = Control.MOUSE_FILTER_STOP
    view.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    if filename == "go-to-button.png" or filename.begins_with("switch-"):
        view.set_meta("no_press_shrink", true)
    view.pressed.connect(action)
    parent.add_child(view)
    return view

func label(parent: Control, name_id: String, contents: String, pos: Vector2, dimensions: Vector2, font_size: int) -> Label:
    var view := Label.new()
    view.name = name_id
    view.text = contents
    view.position = pos
    view.size = dimensions
    view.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    view.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    view.add_theme_font_size_override("font_size", font_size)
    view.add_theme_color_override("font_color", Color("5a2911"))
    if game.get("game_display_font") != null:
        view.add_theme_font_override("font", game.get("game_display_font"))
    view.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(view)
    return view

func setup(host: Node) -> void:
    game = host
    name = "SettingsPage"
    position = Vector2.ZERO
    size = UI_SIZE
    z_index = 93
    clip_contents = true
    mouse_filter = Control.MOUSE_FILTER_STOP
    texture(self, "settings-screen.png", Vector2(2, 2), UI_SIZE - Vector2(4, 4))
    # Interactive rows are placed on the blank approved board (not baked into art).
    # Alpha 13.96: Settings icons, switches and action buttons increased 20%, centered in place.
    # Illustrated icons replace the old text glyphs; each row retains its original action.
    var rows := [
        ["music-icon.png", "Music", 284.0],
        ["sound-icon.png", "Sound Effects", 374.0],
        ["instagram-icon.png", "Follow Us", 464.0],
        ["coin-icon.png", "Earn More Coins", 554.0],
    ]
    for item in rows:
        var y: float = item[2]
        var icon_view := texture(self, item[0], Vector2(345.68, y - 9.32), Vector2(74.64, 74.64))
        icon_view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        label(self, "Title" + str(int(y)), item[1], Vector2(425, y), Vector2(330, 54), 31)
    music_switch = picture_button(self, "switch-off.png", Vector2(779.8, 282.02), Vector2(110.4,57.96), Callable(self,"toggle_music"))
    effects_switch = picture_button(self, "switch-off.png", Vector2(779.8, 372.02), Vector2(110.4,57.96), Callable(self,"toggle_effects"))
    picture_button(self, "go-to-button.png", Vector2(790.632, 457.932), Vector2(92.736,65.136), Callable(self,"follow_us"))
    picture_button(self, "go-to-button.png", Vector2(790.632, 547.932), Vector2(92.736,65.136), Callable(self,"earn_coins"))
    status_label = label(self, "Feedback", "", Vector2(333, 615), Vector2(600, 34), 15)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.visible = false # No button feedback text
    # Visible, clickable close icon at the top-right of the settings board.
    var close_area := picture_button(self, "close.png", Vector2(1060, 192), Vector2(70, 70), Callable(self, "close_settings"))
    # Tooltip disabled: close_area.tooltip_text = "Back to Main Menu"
    refresh()
    hide()

func refresh() -> void:
    var music_on: bool = not bool(game.get("music_muted"))
    var effects_on: bool = bool(game.get("sfx_enabled"))
    music_switch.texture_normal = load(ASSETS + ("switch-on.png" if music_on else "switch-off.png"))
    music_switch.texture_hover = music_switch.texture_normal
    music_switch.texture_pressed = music_switch.texture_normal
    effects_switch.texture_normal = load(ASSETS + ("switch-on.png" if effects_on else "switch-off.png"))
    effects_switch.texture_hover = effects_switch.texture_normal
    effects_switch.texture_pressed = effects_switch.texture_normal

func toggle_music() -> void:
    game.call("save_navigation_preference", bool(game.get("music_muted")), "Music")
    refresh()

func toggle_effects() -> void:
    game.call("save_navigation_preference", not bool(game.get("sfx_enabled")), "Sound Effects")
    refresh()

func earn_coins() -> void:
    var bridge: Node = game.get("ads_bridge")
    if bridge != null and bridge.call("request_rewarded"):
        status_label.text = "Complete the video to receive 50 coins."
    else:
        status_label.text = "Rewarded video unavailable right now. Try again later."

func follow_us() -> void:
    if INSTAGRAM_URL.is_empty():
        status_label.text = ""
    else:
        OS.shell_open(INSTAGRAM_URL)

func close_settings() -> void:
    game.call("show_main_menu")
