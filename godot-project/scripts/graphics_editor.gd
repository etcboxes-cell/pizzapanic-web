extends Control
## Alpha 12.56 graphics mapping / placement workbench.
## Editor data lives in user://graphics_layout.json. No campaign save is modified.
const CATALOG_PATH := "res://data/graphics_catalog.json"
const SAVE_PATH := "user://graphics_layout.json"
const VIEW_W := 1280.0
const VIEW_H := 720.0
var items: Array = []
var selected: int = -1
var dragging := false
var drag_offset := Vector2.ZERO
var stage: Control
var sidebar: PanelContainer
var item_list: ItemList
var path_field: LineEdit
var x_field: SpinBox
var y_field: SpinBox
var size_field: SpinBox
var visibility: CheckBox
var status: Label
var show_all := false
var background_view: TextureRect
var background_picker: OptionButton
var background_field: LineEdit
var background_paths := {
    "Gameplay": "res://assets/replacements/backgrounds/game-play-screen.png",
    "Initial": "res://assets/replacements/backgrounds/initial-screen.png",
    "Main Menu": "res://assets/replacements/backgrounds/initial-screen.png",
    "Level Select": "res://assets/replacements/backgrounds/selec-level-screen.png",
    "Pre-Level": "res://assets/replacements/backgrounds/pre-level.png",
    "Completed": "res://assets/replacements/backgrounds/complete-level.png",
    "Failed": "res://assets/replacements/backgrounds/fail-level-screen.png",
    "Shop": "res://assets/replacements/backgrounds/shop-screen-v2.png",
    "How to Play": "res://assets/replacements/backgrounds/how-to-screen-v2.png",
    "Settings": "res://assets/replacements/backgrounds/settings-screen.png",
    "Story 1": "res://assets/replacements/backgrounds/story1.png",
    "Story 2": "res://assets/replacements/backgrounds/story2.png"
}
var visual_nodes: Dictionary = {}

func _ready() -> void:
    var raw := FileAccess.get_file_as_string(CATALOG_PATH)
    var parsed = JSON.parse_string(raw)
    if parsed is Array:
        items = parsed
    if FileAccess.file_exists(SAVE_PATH):
        var saved = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
        if saved is Array:
            var overrides := {}
            for entry in saved:
                if entry is Dictionary and entry.has("id"):
                    overrides[str(entry["id"])] = entry
            for i in range(items.size()):
                var id := str(items[i].get("id", ""))
                if overrides.has(id):
                    items[i].merge(overrides[id], true)
    _build_ui()
    _refresh_list()
    _select(0)

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.color = Color("172333")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)
    stage = Control.new()
    stage.position = Vector2(8, 55)
    stage.custom_minimum_size = Vector2(960, 540)
    stage.size = Vector2(960, 540)
    stage.clip_contents = true
    add_child(stage)
    var stage_bg := ColorRect.new()
    stage_bg.color = Color("d7b78d")
    stage_bg.size = stage.size
    stage_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
    stage.add_child(stage_bg)
    background_view = TextureRect.new()
    background_view.size = stage.size
    background_view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background_view.stretch_mode = TextureRect.STRETCH_SCALE
    background_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
    stage.add_child(background_view)
    _set_background(background_paths["Gameplay"])
    var grid := ColorRect.new()
    grid.color = Color(1,1,1,0.08)
    grid.size = stage.size
    grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
    stage.add_child(grid)
    var title := Label.new()
    title.text = "PIZZA PANIC  |  GRAPHICS EDIT MODE  |  drag sprites to reposition"
    title.position = Vector2(16,12)
    title.add_theme_font_size_override("font_size",20)
    add_child(title)
    sidebar = PanelContainer.new()
    sidebar.position = Vector2(980,55)
    sidebar.size = Vector2(290,640)
    add_child(sidebar)
    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation",6)
    sidebar.add_child(column)
    var hint := Label.new()
    hint.text = "BACKGROUND / SCENE"
    column.add_child(hint)
    background_picker = OptionButton.new()
    for scene_name in background_paths.keys():
        background_picker.add_item(scene_name)
    background_picker.item_selected.connect(_background_selected)
    column.add_child(background_picker)
    background_field = LineEdit.new()
    background_field.text = background_paths["Gameplay"]
    column.add_child(background_field)
    _add_button(column,"LOAD BACKGROUND",_load_background_from_field)
    var objects_heading := Label.new()
    objects_heading.text = "SELECT OBJECT / MAP YOUR PNG"
    column.add_child(objects_heading)
    item_list = ItemList.new()
    item_list.custom_minimum_size = Vector2(275,150)
    item_list.item_selected.connect(_select)
    column.add_child(item_list)
    path_field = LineEdit.new()
    path_field.placeholder_text = "res://assets/replacements/table.png"
    column.add_child(path_field)
    _add_button(column,"APPLY IMAGE",_apply_image)
    x_field = _add_spin(column,"X position",0,1280,1)
    y_field = _add_spin(column,"Y position",0,720,1)
    size_field = _add_spin(column,"Size %",10,400,5)
    _add_button(column,"APPLY POSITION / SIZE",_apply_fields)
    visibility = CheckBox.new()
    visibility.text = "Visible"
    visibility.button_pressed = true
    visibility.toggled.connect(_set_visible)
    column.add_child(visibility)
    _add_button(column,"SAVE LAYOUT",_save)
    _add_button(column,"RESET SELECTED",_reset_selected)
    _add_button(column,"OPEN GAME (F6 from Main scene)",_return_to_game)
    status = Label.new()
    status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    status.custom_minimum_size = Vector2(275,50)
    column.add_child(status)
    var tip := Label.new()
    tip.text = "Choose Gameplay to align the tables.\nBackground is an alignment guide only.\nSAVE LAYOUT preserves your sprite assignments."
    tip.position = Vector2(15,612)
    tip.add_theme_color_override("font_color",Color("f5e8c9"))
    add_child(tip)

func _add_button(parent: Node, label: String, callback: Callable) -> void:
    var b := Button.new()
    b.text = label
    b.pressed.connect(callback)
    parent.add_child(b)

func _add_spin(parent: Node, label: String, low: float, high: float, step: float) -> SpinBox:
    var line := HBoxContainer.new()
    parent.add_child(line)
    var caption := Label.new()
    caption.text = label
    caption.custom_minimum_size.x = 115
    line.add_child(caption)
    var spin := SpinBox.new()
    spin.min_value = low
    spin.max_value = high
    spin.step = step
    spin.custom_minimum_size.x = 130
    line.add_child(spin)
    return spin

func _refresh_list() -> void:
    item_list.clear()
    for item in items:
        var prefix := "✓ " if str(item.get("image", "")) != "" else "· "
        item_list.add_item(prefix + str(item.get("id", "")) + " — " + str(item.get("label", "")))

func _select(index: int) -> void:
    if index < 0 or index >= items.size():
        return
    selected = index
    item_list.select(index)
    var item: Dictionary = items[index]
    path_field.text = str(item.get("image", ""))
    x_field.value = float(item.get("x",0))
    y_field.value = float(item.get("y",0))
    size_field.value = float(item.get("scale",1)) * 100.0
    visibility.set_pressed_no_signal(bool(item.get("visible",true)))
    _render_stage()
    status.text = str(item.get("id","")) + " selected. Drag the image, or edit coordinates."

func _render_stage() -> void:
    for child in stage.get_children():
        if child is ColorRect or child == background_view:
            continue
        child.queue_free()
    visual_nodes.clear()
    if selected < 0:
        return
    var indices: Array = range(items.size()) if show_all else [selected]
    for idx in indices:
        var item: Dictionary = items[idx]
        if not bool(item.get("visible",true)):
            continue
        var scale_val := float(item.get("scale",1.0))
        var size_px := Vector2(float(item.get("width",120)),float(item.get("height",95))) * scale_val * 0.75
        var center := Vector2(float(item.get("x",0)),float(item.get("y",0))) * 0.75
        var holder := Control.new()
        holder.position = center - size_px / 2.0
        holder.size = size_px
        holder.mouse_filter = Control.MOUSE_FILTER_STOP
        holder.set_meta("item_index",idx)
        stage.add_child(holder)
        var path := str(item.get("image", ""))
        var texture: Texture2D = null
        if path.begins_with("res://") and ResourceLoader.exists(path):
            texture = load(path) as Texture2D
        if texture != null:
            var pic := TextureRect.new()
            pic.texture = texture
            pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
            pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
            pic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
            pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
            holder.add_child(pic)
        else:
            var box := ColorRect.new()
            box.color = Color(0.12,0.5,0.8,0.22)
            box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
            box.mouse_filter = Control.MOUSE_FILTER_IGNORE
            holder.add_child(box)
        var border := ReferenceRect.new()
        border.border_color = Color("fce065")
        border.border_width = 2
        border.editor_only = false
        border.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
        border.mouse_filter = Control.MOUSE_FILTER_IGNORE
        holder.add_child(border)
        var caption := Label.new()
        caption.text = str(item.get("id",""))
        caption.position = Vector2(2,2)
        caption.add_theme_color_override("font_color",Color("172333"))
        caption.add_theme_font_size_override("font_size",12)
        caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
        holder.add_child(caption)
        holder.gui_input.connect(_on_sprite_input.bind(idx))
        visual_nodes[idx] = holder

func _on_sprite_input(event: InputEvent, idx: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            if idx != selected:
                _select(idx)
            dragging = true
            drag_offset = stage.get_local_mouse_position() - Vector2(float(items[idx]["x"]),float(items[idx]["y"])) * 0.75
        else:
            dragging = false
    elif event is InputEventScreenTouch:
        dragging = event.pressed
        if dragging:
            drag_offset = stage.get_local_mouse_position() - Vector2(float(items[idx]["x"]),float(items[idx]["y"])) * 0.75

func _process(_delta: float) -> void:
    if dragging and selected >= 0 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        var p := (stage.get_local_mouse_position() - drag_offset) / 0.75
        items[selected]["x"] = clampf(p.x,0,VIEW_W)
        items[selected]["y"] = clampf(p.y,0,VIEW_H)
        x_field.value = float(items[selected]["x"])
        y_field.value = float(items[selected]["y"])
        if visual_nodes.has(selected):
            var holder: Control = visual_nodes[selected]
            holder.position = p * 0.75 - holder.size / 2.0
    elif dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        dragging = false

func _apply_image() -> void:
    if selected < 0:
        return
    var path := path_field.text.strip_edges()
    if path != "" and (not path.begins_with("res://") or not ResourceLoader.exists(path)):
        status.text = "IMAGE NOT FOUND. Copy the PNG into assets/replacements and enter its res:// path."
        return
    items[selected]["image"] = path
    _refresh_list()
    item_list.select(selected)
    _render_stage()
    status.text = "Image assigned. SAVE LAYOUT to keep it."

func _apply_fields() -> void:
    if selected < 0:
        return
    items[selected]["x"] = x_field.value
    items[selected]["y"] = y_field.value
    items[selected]["scale"] = size_field.value / 100.0
    _render_stage()

func _set_visible(on: bool) -> void:
    if selected < 0:
        return
    items[selected]["visible"] = on
    _render_stage()

func _save() -> void:
    var file := FileAccess.open(SAVE_PATH,FileAccess.WRITE)
    if file == null:
        status.text = "Could not save layout."
        return
    file.store_string(JSON.stringify(items,"  "))
    file.close()
    status.text = "SAVED: " + ProjectSettings.globalize_path(SAVE_PATH)

func _reset_selected() -> void:
    if selected < 0:
        return
    var base = JSON.parse_string(FileAccess.get_file_as_string(CATALOG_PATH))
    if base is Array and selected < base.size():
        items[selected] = base[selected].duplicate(true)
        _select(selected)

func _return_to_game() -> void:
    get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _background_selected(index: int) -> void:
    var label := background_picker.get_item_text(index)
    background_field.text = str(background_paths.get(label, ""))
    _load_background_from_field()

func _load_background_from_field() -> void:
    _set_background(background_field.text.strip_edges())

func _set_background(path: String) -> void:
    if not is_instance_valid(background_view):
        return
    if path.begins_with("res://") and ResourceLoader.exists(path):
        background_view.texture = load(path) as Texture2D
        if is_instance_valid(status):
            status.text = "Background loaded: " + path.get_file()
    else:
        background_view.texture = null
        if is_instance_valid(status):
            status.text = "Background missing: " + path
