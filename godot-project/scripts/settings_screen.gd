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
    view.stretch_mode = TextureRect.STRETCH_SCALE
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
    view.texture_hover = art
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
    texture(self, "settings-screen.png", Vector2.ZERO, UI_SIZE)
    # Labels are part of the approved background artwork; avoid duplicating them.
    # Correct row-to-action mapping. Audio switches are shifted 5 px left.
    music_switch = picture_button(self, "switch-off.png", Vector2(784, 304), Vector2(107,56), Callable(self,"toggle_music"))
    music_switch.set_meta("no_press_shrink", true)
    effects_switch = picture_button(self, "switch-off.png", Vector2(784, 390), Vector2(107,56), Callable(self,"toggle_effects"))
    effects_switch.set_meta("no_press_shrink", true)
    picture_button(self, "go-to-button.png", Vector2(783.5, 470), Vector2(112,79), Callable(self,"follow_us")).tooltip_text = "Open Pizza Panic on Instagram"
    picture_button(self, "go-to-button.png", Vector2(783.5, 563), Vector2(112,79), Callable(self,"earn_coins")).tooltip_text = "Watch an optional rewarded advertisement (+50 coins if completed)"
    status_label = label(self, "Feedback", "", Vector2(313, 627), Vector2(635, 40), 16)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    picture_button(self, "close.png", Vector2(1041, 191), Vector2(81,80), Callable(self,"close_settings")).tooltip_text = "Back to Main Menu"
    var build_label := label(self, "BuildVersion", "ALPHA 13.39", Vector2(1034, 644), Vector2(135, 24), 13)
    build_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
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
