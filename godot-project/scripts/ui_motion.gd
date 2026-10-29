extends Node
## Reusable UI motion controller. Visual-only: never affects gameplay clocks or hitboxes.
const TWO_PI_F := PI * 2.0
var clock: float = 0.0
var watched: Dictionary = {}
var root: Node
var intro: TextureRect

func setup(ui_root: Node, intro_background: TextureRect) -> void:
    root = ui_root
    intro = intro_background
    _scan(root)

func _scan(node: Node) -> void:
    if node is Button and not watched.has(node.get_instance_id()):
        var button: Button = node as Button
        watched[button.get_instance_id()] = {"node": button, "hover": false}
        button.mouse_entered.connect(_set_hover.bind(button, true))
        button.mouse_exited.connect(_set_hover.bind(button, false))
    for child in node.get_children():
        _scan(child)

func _set_hover(button: Button, active: bool) -> void:
    if not is_instance_valid(button): return
    if watched.has(button.get_instance_id()):
        watched[button.get_instance_id()]["hover"] = active

func _process(delta: float) -> void:
    clock += minf(delta, 0.1)
    # New controls created by store refreshes also receive motion automatically.
    if Engine.get_process_frames() % 45 == 0 and is_instance_valid(root):
        _scan(root)
    var phase := clock * 2.0
    var visible_index := 0
    for id in watched.keys():
        if not watched.has(id):
            continue
        var entry: Dictionary = watched[id]
        var candidate: Variant = entry.get("node", null)
        if not is_instance_valid(candidate) or not (candidate is Button):
            watched.erase(id)
            continue
        var btn: Button = candidate as Button
        if not btn.is_visible_in_tree():
            btn.modulate.a = 1.0
            continue
        # Soft highlighted CTA glow; mouse feedback stays inside original button area.
        var hovered: bool = entry["hover"] and not btn.disabled
        btn.modulate = Color(1.0, 1.0, 1.0, 1.0) if btn.disabled else Color(1.0, 1.0, 1.0, 0.94 + 0.06 * sin(phase + visible_index * 0.8))
        if hovered:
            btn.modulate = Color(1.13, 1.12, 1.03, 1.0)
        visible_index += 1
    # Three independent visible movements per menu: title pulse, button glow, logo drips.
    for name in ["MainMenu", "SettingsPage", "HowToPlayPage", "RestaurantPage"]:
        var page: Node = root.find_child(name, true, false)
        if page is Control and page.is_visible_in_tree():
            var title: Label = _first_label(page)
            if title != null:
                title.modulate = Color(1.0, 0.96 + 0.04 * sin(phase * 0.8), 0.86 + 0.14 * sin(phase * 0.8), 1.0)
    if is_instance_valid(intro) and intro.is_visible_in_tree():
        intro.modulate = Color(1.0, 1.0, 1.0, 0.98 + 0.02 * sin(phase * 0.7))

func _first_label(node: Node) -> Label:
    for child in node.get_children():
        if child is Label: return child as Label
        var nested: Label = _first_label(child)
        if nested != null: return nested
    return null
