extends Node
## Alpha 12.87 — centered 15% shrink on press for every BaseButton.
## Covers Button, TextureButton, CheckButton and dynamically created game buttons.
## Existing pressed/changed signals, purchase checks, and input behaviour are untouched.

const PRESS_DURATION := 0.10
const RELEASE_DURATION := 0.12
const PRESS_SQUASH := Vector2(0.85, 0.85)
const PRESS_SHADE := Color(1.0, 1.0, 1.0, 1.0)

var watched: Dictionary = {}

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    # Autoload watches every scene, including buttons created after _ready().
    get_tree().node_added.connect(_on_node_added)
    call_deferred("_scan_existing")

func _scan_existing() -> void:
    _scan(get_tree().root)

func _scan(node: Node) -> void:
    if node is BaseButton:
        _watch(node as BaseButton)
    for child in node.get_children():
        _scan(child)

func _on_node_added(node: Node) -> void:
    if node is BaseButton:
        _watch(node as BaseButton)

func _watch(button: BaseButton) -> void:
    if button.has_meta("no_press_shrink") and bool(button.get_meta("no_press_shrink")):
        return
    var id: int = button.get_instance_id()
    if watched.has(id):
        return
    watched[id] = {
        "node": weakref(button),
        "pressed": false,
        "original_scale": button.scale,
        "original_pivot": button.pivot_offset,
        "original_tint": button.self_modulate,
        "tween": null
    }
    button.button_down.connect(_button_down.bind(id))
    button.button_up.connect(_button_up.bind(id))
    button.focus_exited.connect(_button_up.bind(id))
    button.tree_exiting.connect(_button_removed.bind(id))

func _get_button(id: int) -> BaseButton:
    if not watched.has(id):
        return null
    var ref: WeakRef = watched[id]["node"]
    var candidate: Object = ref.get_ref()
    if candidate is BaseButton and is_instance_valid(candidate):
        return candidate as BaseButton
    watched.erase(id)
    return null

func _stop_tween(data: Dictionary) -> void:
    var previous: Variant = data.get("tween", null)
    if previous is Tween and previous.is_valid():
        previous.kill()

func _button_down(id: int) -> void:
    var button: BaseButton = _get_button(id)
    if button == null or button.disabled or not button.is_visible_in_tree():
        return
    if button.has_meta("no_press_shrink") and bool(button.get_meta("no_press_shrink")):
        return
    var data: Dictionary = watched[id]
    var previous: Variant = data.get("tween", null)
    var still_animating: bool = previous is Tween and previous.is_running()
    _stop_tween(data)
    # Repeated fast taps must reuse the true baseline, not an in-between scale.
    if not bool(data["pressed"]) and not still_animating:
        data["original_scale"] = button.scale
        data["original_pivot"] = button.pivot_offset
        data["original_tint"] = button.self_modulate
    data["pressed"] = true
    # Keep the artwork visually centered while shrinking uniformly.
    button.pivot_offset = button.size * 0.5
    var base_scale: Vector2 = data["original_scale"]
    var original_tint: Color = data["original_tint"]
    var tween: Tween = create_tween().set_parallel(true)
    tween.tween_property(button, "scale", base_scale * PRESS_SQUASH, PRESS_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.tween_property(button, "self_modulate", original_tint * PRESS_SHADE, PRESS_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    data["tween"] = tween

func _button_up(id: int) -> void:
    var button: BaseButton = _get_button(id)
    if button == null:
        return
    var data: Dictionary = watched[id]
    if not bool(data["pressed"]):
        return
    data["pressed"] = false
    _stop_tween(data)
    var tween: Tween = create_tween().set_parallel(true)
    tween.tween_property(button, "scale", data["original_scale"], RELEASE_DURATION).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    tween.tween_property(button, "self_modulate", data["original_tint"], RELEASE_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    # Restore the button's own pivot after its visual animation completes.
    tween.chain().tween_callback(_restore_pivot.bind(id))
    data["tween"] = tween

func _restore_pivot(id: int) -> void:
    var button: BaseButton = _get_button(id)
    if button != null and not bool(watched[id]["pressed"]):
        button.pivot_offset = watched[id]["original_pivot"]

func _button_removed(id: int) -> void:
    if not watched.has(id):
        return
    _stop_tween(watched[id])
    watched.erase(id)
