extends Control
# Alpha 12.80 – illustrated, high-resolution upgrade shop.
# Clicks call main.gd purchase confirmation + persistent coin/upgrade logic.
var game
var current_page: int = 0
var feedback: Label
var nav_close: TextureButton
var nav_next: TextureButton
var titles: Array[Label] = []
var details: Array[Label] = []
var prices: Array[Label] = []
var statuses: Array[Label] = []
var pictures: Array[TextureRect] = []
var coin_icons: Array[TextureRect] = []
var buys: Array[TextureButton] = []
var wallet: Label
var page_counter: Label

const CATALOG := [
    "chairs_group", "tray", "cart3", "expand4", "oven", "robot",
    "cart4", "expand5", "expand6", "robot_speed", "robot_capacity",
    "delivery_auto", "restaurant2"
]
const SCREEN_SIZE := Vector2(1280, 720)

func pic(parent: Control, file: String, point: Vector2, dims: Vector2) -> TextureRect:
    var view := TextureRect.new()
    view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    view.stretch_mode = TextureRect.STRETCH_SCALE
    view.texture = load("res://assets/ui/shop/" + file)
    view.position = point
    view.custom_minimum_size = Vector2.ZERO
    view.size = dims
    view.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(view)
    return view

func art_button(parent: Control, file: String, point: Vector2, dims: Vector2, action: Callable) -> TextureButton:
    var btn := TextureButton.new()
    var tex: Texture2D = load("res://assets/ui/shop/" + file)
    btn.texture_normal = tex
    btn.texture_hover = tex
    btn.texture_pressed = tex
    btn.texture_disabled = tex
    btn.ignore_texture_size = true
    btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
    btn.position = point
    btn.size = dims
    btn.mouse_filter = Control.MOUSE_FILTER_STOP
    btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    btn.focus_mode = Control.FOCUS_ALL
    btn.pivot_offset = dims / 2.0
    btn.pressed.connect(action)
    parent.add_child(btn)
    return btn

func text_label(parent: Control, point: Vector2, dims: Vector2, size_font: int, tint: Color, centered: bool = false) -> Label:
    var lbl := Label.new()
    lbl.position = point
    lbl.size = dims
    lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
    lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    lbl.add_theme_color_override("font_color",tint)
    lbl.add_theme_font_size_override("font_size",size_font)
    if game.get("game_display_font") != null:
        lbl.add_theme_font_override("font",game.get("game_display_font"))
    lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(lbl)
    return lbl

func setup(host) -> void:
    game = host
    name = "IllustratedShop"
    size = SCREEN_SIZE
    z_index = 850
    mouse_filter = Control.MOUSE_FILTER_STOP
    clip_contents = true
    var backdrop := ColorRect.new()
    backdrop.color = Color("16100c")
    backdrop.size = SCREEN_SIZE
    backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
    add_child(backdrop)
    pic(self, "shop-screen-v2.png", Vector2.ZERO, SCREEN_SIZE)
    # Match the approved Shop reference at 1280x720.
    # These are the actual interactive TextureButtons, not painted-only icons.
    var close := art_button(self,"close-button(2).png",Vector2(1045, 160),Vector2(81,80),Callable(self,"close_store"))
    close.name = "ShopCloseButton"
    close.tooltip_text = "Close Shop"
    nav_close = close
    var right := art_button(self,"how-to-right(1).png",Vector2(1133,408),Vector2(62,62),Callable(self,"next_page"))
    right.name = "ShopNextButton"
    right.tooltip_text = "Next Shop page"
    nav_next = right
    for idx in range(3):
        var top: float = 249.0 + float(idx) * 128.0
        pictures.append(pic(self,"chair-upgrade.png",Vector2(250,top+8),Vector2(108,96)))
        # Keep title and subtitle together on every upgrade card.
        var upgrade_title := text_label(self, Vector2(380, top + 17), Vector2(270, 29), 21, Color("913807"))
        upgrade_title.add_theme_color_override("font_outline_color", Color("ffe9ac"))
        upgrade_title.add_theme_constant_override("outline_size", 2)
        titles.append(upgrade_title)
        var upgrade_detail := text_label(self, Vector2(380, top + 49), Vector2(290, 25), 15, Color("8e430c"))
        upgrade_detail.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        details.append(upgrade_detail)
        coin_icons.append(pic(self,"coin.png",Vector2(625,top+25),Vector2(49,49)))
        prices.append(text_label(self,Vector2(677,top+22),Vector2(112,56),30,Color("231613"),true))
        var buy := art_button(self,"buy-botton.png",Vector2(803,top+24),Vector2(182,57),Callable(self,"press_buy").bind(idx))
        buy.tooltip_text = "Buy this upgrade"
        buys.append(buy)
        statuses.append(text_label(self,Vector2(795,top+84),Vector2(200,24),11,Color("873509"),true))
    wallet = text_label(self,Vector2(360,624),Vector2(285,29),16,Color("fff4da"))
    page_counter = text_label(self,Vector2(715,624),Vector2(100,29),16,Color("fff4da"),true)
    feedback = text_label(self,Vector2(840,624),Vector2(176,29),12,Color("fff4da"),true)
    for footer in [wallet, page_counter, feedback]:
        footer.add_theme_color_override("font_outline_color", Color("3d210a"))
        footer.add_theme_constant_override("outline_size", 3)
    feedback.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    # Navigation is above all cards, so its hit area is never blocked.
    move_child(nav_close, get_child_count() - 1)
    move_child(nav_next, get_child_count() - 1)
    visible = false

func refresh() -> void:
    if game == null: return
    var pages: int = int(ceil(float(CATALOG.size()) / 3.0))
    current_page = posmod(current_page, pages)
    wallet.text = "YOUR COINS: %d" % int(game.get("wallet_coins"))
    page_counter.text = "%d / %d" % [current_page+1,pages]
    for idx in range(3):
        var ci: int = current_page*3+idx
        var active: bool = ci < CATALOG.size()
        pictures[idx].visible = active
        coin_icons[idx].visible = active
        buys[idx].visible = active
        titles[idx].visible = active
        details[idx].visible = active
        prices[idx].visible = active
        statuses[idx].visible = active
        if not active: continue
        var data: Dictionary = game.call("shop_card_data",CATALOG[ci])
        pictures[idx].texture = load("res://assets/ui/shop/" + str(data.get("icon","chair-upgrade.png")))
        titles[idx].text = str(data.get("name","UPGRADE"))
        details[idx].text = str(data.get("details",""))
        prices[idx].text = str(data.get("cost",""))
        var allowed: bool = bool(data.get("can_buy",false))
        buys[idx].disabled = false
        buys[idx].modulate = Color.WHITE
        buys[idx].tooltip_text = "Buy for %d coins" % int(data.get("cost",0)) if allowed else str(data.get("status","Unavailable"))
        buys[idx].set_meta("upgrade_id",str(data.get("id","")))
        statuses[idx].text = "" if allowed else str(data.get("status", "")).replace("Unlock Level 4", "").replace("Unlock Level 13", "")

func press_buy(row: int) -> void:
    if row < 0 or row >= buys.size(): return
    var btn: TextureButton = buys[row]
    if btn.disabled: return
    var id: String = str(btn.get_meta("upgrade_id",""))
    if id != "":
        var card: Dictionary = game.call("shop_card_data", id)
        if bool(card.get("can_buy", false)):
            game.call("confirm_store_purchase",id)
        else:
            feedback.text = str(card.get("status", "Upgrade not yet available"))

func next_page() -> void:
    current_page = (current_page+1)%int(ceil(float(CATALOG.size())/3.0))
    refresh()

func close_store() -> void:
    game.call("toggle_shop")

# Shop navigation uses the actual visible TextureButtons directly.
# Avoid a second global input handler, which can double-fire or interfere with UI.
