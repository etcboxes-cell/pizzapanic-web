extends Control
## Drawn animation; no checkerboard or flat background, no gameplay interaction.
var elapsed: float = 0.0
func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
func _process(delta: float) -> void:
    elapsed += delta
    queue_redraw()
func _draw() -> void:
    var xs := [0.22, 0.38, 0.63, 0.82]
    for i in range(xs.size()):
        var cycle: float = fposmod(elapsed * (0.52 + float(i) * 0.07) + float(i) * 0.24, 1.0)
        var length: float = 4.0 + 12.0 * cycle
        var x: float = size.x * float(xs[i])
        var top: float = size.y - 2.0
        var sauce := Color("ffad32") if i % 2 == 0 else Color("f46c27")
        draw_line(Vector2(x, top), Vector2(x, top + length), sauce, 5.0, true)
        draw_circle(Vector2(x, top + length), 3.8, sauce)
