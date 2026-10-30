extends Control
# Alpha 12.79: isolated visual layer; gameplay and save data stay in main.gd.
var game
var pre: Control
var selector: Control
var cells: Control
var pre_title: Label
var pre_mission: Label
var pre_description: Label
var pre_cash: Label
var pre_parties: Label
var coin_label: Label
var stars_label: Label
var chapter_label: Label
var notice: Label
var back_arrow: TextureButton
var next_arrow: TextureButton

func image(parent: Control, folder: String, filename: String, pos: Vector2, dim: Vector2) -> TextureRect:
    var t := TextureRect.new()
    t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    t.stretch_mode = TextureRect.STRETCH_SCALE
    t.texture = load("res://assets/ui/" + folder + "/" + filename)
    t.position = pos
    t.custom_minimum_size = Vector2.ZERO
    t.size = dim
    t.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(t)
    return t

func button(parent: Control, folder: String, filename: String, pos: Vector2, dim: Vector2, action: Callable) -> TextureButton:
    var t := TextureButton.new()
    var art: Texture2D = load("res://assets/ui/" + folder + "/" + filename)
    t.texture_normal = art
    t.texture_hover = t.texture_normal
    t.texture_pressed = art
    t.ignore_texture_size = true
    t.stretch_mode = TextureButton.STRETCH_SCALE
    t.position = pos
    t.size = dim
    t.pivot_offset = dim / 2.0
    t.mouse_filter = Control.MOUSE_FILTER_STOP
    t.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    t.focus_mode = Control.FOCUS_ALL
    t.pressed.connect(action)
    parent.add_child(t)
    return t

func label(parent: Control, id: String, pos: Vector2, dim: Vector2, fsize: int, color: Color, centered: bool = false) -> Label:
    var t := Label.new()
    t.name = id
    t.position = pos
    t.size = dim
    t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    t.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
    t.add_theme_font_size_override("font_size", fsize)
    t.add_theme_color_override("font_color", color)
    t.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(t)
    return t

func setup(host) -> void:
    game = host
    size = Vector2(1280, 720)
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    pre = Control.new()
    pre.name = "PreLevelScreen"
    pre.size = size
    pre.z_index = 110
    pre.mouse_filter = Control.MOUSE_FILTER_STOP
    pre.clip_contents = true
    add_child(pre)
    image(pre, "pre_level", "pre-level-screen.png", Vector2.ZERO, size)
    image(pre, "pre_level", "challenge-checklist.png", Vector2(277,282), Vector2(126,123))
    pre_title = label(pre, "LevelTitle", Vector2(335,222), Vector2(625,59), 38, Color.WHITE, true)
    pre_title.add_theme_color_override("font_outline_color", Color("612408"))
    pre_title.add_theme_constant_override("outline_size", 8)
    var heading := label(pre, "ChallengeHeading", Vector2(437,275), Vector2(505,42), 28, Color("82370c"))
    heading.text = ""
    pre_mission = label(pre, "LevelChallenge", Vector2(425,290), Vector2(555,78), 29, Color("68310e"))
    pre_description = label(pre, "WhatsNew", Vector2(425,379), Vector2(560,107), 23, Color("79411b"))
    image(pre, "pre_level", "coin.png", Vector2(290,521), Vector2(56.25,56.25))
    pre_cash = label(pre, "RevenueGoal", Vector2(357,517), Vector2(250,66), 28, Color("693415"))
    image(pre, "pre_level", "happy-customers.png", Vector2(681,522), Vector2(48.75,48.75))
    pre_parties = label(pre, "PartySchedule", Vector2(742,517), Vector2(245,66), 28, Color("693415"))
    var display_font: Font = load("res://assets/fonts/LilitaOne-Regular.ttf")
    for item in [pre_title, pre_mission, pre_description, pre_cash, pre_parties]:
        item.add_theme_font_override("font", display_font)
    var start := button(pre, "pre_level", "button-start-level.png", Vector2(443,616), Vector2(394,96), Callable(self,"start_level"))
    # Tooltip disabled: start.tooltip_text = ""
    var close := button(pre, "pre_level", "close-button.png", Vector2(1008, 141), Vector2(81,80), Callable(self,"close_pre"))
    # Tooltip disabled: close.tooltip_text = ""
    pre.hide()

    selector = Control.new()
    selector.name = "IllustratedLevelSelect"
    selector.size = size
    selector.z_index = 105
    selector.mouse_filter = Control.MOUSE_FILTER_STOP
    selector.clip_contents = true
    add_child(selector)
    image(selector,"level_select","selec-level-screen.png",Vector2.ZERO,size)
    image(selector,"level_select","coin-bank.png",Vector2(594,15),Vector2(239,72))
    image(selector,"level_select","star-counter.png",Vector2(860,15),Vector2(234,72))
    # Coin button added last so it receives clicks above counters and labels.
    coin_label = label(selector,"Wallet",Vector2(690,25),Vector2(118,60),43,Color.WHITE,true)
    coin_label.add_theme_color_override("font_outline_color",Color("311b11"))
    coin_label.add_theme_constant_override("outline_size",5)
    stars_label = label(selector,"ChapterStars",Vector2(945,25),Vector2(136,60),42,Color.WHITE,true)
    stars_label.add_theme_color_override("font_outline_color",Color("311b11"))
    stars_label.add_theme_constant_override("outline_size",5)
    button(selector,"level_select","mini-games.png",Vector2(1128,9),Vector2(106,77),Callable(self,"open_mini_games"))
    chapter_label = label(selector,"PageTitle",Vector2(721,551),Vector2(423,29),18,Color("fff4d2"),true)
    cells = Control.new()
    cells.name = "LevelButtons"
    cells.size = size
    selector.add_child(cells)
    back_arrow = button(selector,"level_select","how-to-left.png",Vector2(624,373),Vector2(55,55),Callable(self,"previous_page"))
    next_arrow = button(selector,"level_select","how-to-right.png",Vector2(1207,373),Vector2(57,55),Callable(self,"next_page"))
    notice = label(selector,"SelectionHint",Vector2(700,625),Vector2(470,34),15,Color("fff2c6"),true)
    var home := button(selector,"level_select","main-menu-button.png",Vector2(864,644),Vector2(194,65),Callable(game,"show_main_menu"))
    # Tooltip disabled: home.tooltip_text = ""
    var coin_plus := button(selector,"level_select","add-coins.png",Vector2(796.6,26.6),Vector2(52.8,52.8),Callable(self,"open_coin_preview"))
    coin_plus.name = "EarnCoinsPlus"
    # Keep the supplied coin-bank artwork fully visible; retain the invisible Coin Shop hit area.
    coin_plus.modulate.a = 1.0
    # Tooltip disabled: coin_plus.tooltip_text = ""
    coin_plus.z_index = 20
    coin_plus.mouse_filter = Control.MOUSE_FILTER_STOP
    selector.hide()

func hide_screens() -> void:
    if pre != null: pre.hide()
    if selector != null: selector.hide()

func show_pre() -> void:
    if pre == null: return
    if selector != null: selector.hide()
    pre_title.text = "LEVEL %d  •  %s" % [int(game.get("current_level")) + 1, str(game.call("cfg","name")).to_upper()]
    pre_mission.text = str(game.call("cfg","challenge"))
    var full_brief: String = str(game.call("cfg","brief"))
    var summary: String = full_brief
    if summary.length() > 155:
        summary = summary.substr(0,155)
        var last_space: int = summary.rfind(" ")
        if last_space > 90: summary = summary.substr(0,last_space)
        summary += "…"
    pre_description.text = summary
    # Tooltip disabled: pre_description.tooltip_text = ""
    # party_cap means scheduled PARTIES, not individual people.
    pre_cash.text = "Earn %d coins" % int(game.call("cfg","goal"))
    pre_parties.text = "%d parties arriving" % int(game.call("cfg","party_cap"))
    pre.show()

func close_pre() -> void:
    pre.hide()
    game.call("show_stage_select")

func start_level() -> void:
    pre.hide()
    game.call("try_start_game")

func show_select() -> void:
    if pre != null: pre.hide()
    refresh_select()
    selector.show()

func refresh_select() -> void:
    if selector == null: return
    var page: int = clampi(int(game.get("stage_select_page")),0,4)
    var unlocked_max: int = int(game.get("highest_unlocked"))
    var history: Dictionary = game.get("best_stars")
    var earned: int = 0
    for n in range(page * 20, page * 20 + 20):
        earned += clampi(int(history.get(str(n),0)),0,3)
    coin_label.text = str(game.get("wallet_coins"))
    stars_label.text = "%d/60" % earned
    # Tooltip disabled: stars_label.tooltip_text = ""
    chapter_label.text = "" # Remove text overlapping level tiles 17 and 18
    notice.text = ""
    for old in cells.get_children(): old.queue_free()
    for index in range(20):
        var id: int = page*20 + index
        var stars: int = clampi(int(history.get(str(id),0)),0,3)
        var available: bool = id <= unlocked_max
        var sprite := "level-square-played.png" if stars > 0 or id == unlocked_max else "level-square-not-played.png"
        var col: int = index % 5
        var row: int = int(index / 5)
        # Photoshop 3200 x 1806 exact measured tile positions and dimensions.
        var source_x := [1798.0, 2027.0, 2250.0, 2472.0, 2693.0]
        var source_w := [230.0, 218.0, 218.0, 217.0, 218.0]
        var source_h := [210.0, 204.0, 204.0, 204.0, 204.0]
        var source_y := [630.0, 852.0, 1072.0, 1292.0]
        var px: float = source_x[col] * 0.4
        var py: float = source_y[row] * (720.0 / 1806.0)
        var tw: float = source_w[col] * 0.4
        var th: float = source_h[col] * (720.0 / 1806.0)
        # Keep the established grid cell centers; make every level tile square.
        var square_side: float = minf(tw, th)
        px += (tw - square_side) * 0.5
        py += (th - square_side) * 0.5
        tw = square_side
        th = square_side
        var tile := button(cells,"level_select",sprite,Vector2(px,py),Vector2(tw,th),Callable(self,"choose_level").bind(id))
        tile.disabled = not available
        # Tooltip disabled: tile.tooltip_text = "" # No selection feedback popup
        var num := label(cells,"Level_%d" % (id + 1),Vector2(px,py),Vector2(tw,th),44,Color.WHITE,true)
        num.text = str(id + 1)
        num.add_theme_color_override("font_outline_color",Color("37211f"))
        num.add_theme_constant_override("outline_size",5)
        if stars > 0:
            for star_idx in range(3):
                image(cells,"level_select","yellow-star.png" if star_idx < stars else "gray-star.png",Vector2(px+tw*0.15+star_idx*tw*0.23,py+th*0.73),Vector2(tw*0.23,th*0.20))
    back_arrow.disabled = page == 0
    back_arrow.modulate = Color(0.6,0.6,0.6,0.65) if page == 0 else Color.WHITE
    next_arrow.disabled = page == 4
    next_arrow.modulate = Color(0.6,0.6,0.6,0.65) if page == 4 else Color.WHITE

func choose_level(id: int) -> void:
    if id > int(game.get("highest_unlocked")): return
    selector.hide()
    game.call("choose_replay_level",id)

func previous_page() -> void:
    game.call("select_stage_page",int(game.get("stage_select_page"))-1)

func next_page() -> void:
    game.call("select_stage_page",int(game.get("stage_select_page"))+1)

func earn_coins_from_plus() -> void:
    # Same rewarded-ad flow used by the Settings screen.
    var bridge: Node = game.get("ads_bridge")
    if bridge != null and bridge.call("request_rewarded"):
        notice.text = "Complete the video to receive 50 coins."
    else:
        notice.text = "Rewarded video unavailable right now. Try again later."

func open_coin_preview() -> void:
    selector.hide()
    var legacy: PanelContainer = game.get("stage_panel")
    if legacy != null: legacy.show()
    game.call("open_showcase","coins")

func open_mini_games() -> void:
    var h: Dictionary = game.get("best_stars")
    var done: int = 0
    for day in [100,80,60,40,20]:
        if int(h.get(str(day-1),0)) > 0:
            done=day
            break
    if done == 0:
        notice.text = "Complete Level 20 to unlock mini-games"
        return
    selector.hide()
    var hub = game.get("competition_hub")
    if hub != null: hub.call("open_game",done)
