extends Control

signal close_requested

@onready var panels: Dictionary = {
	"Basics": $BasicContent,
	"Kitchen": $KitchenContent,
	"Customers": $CustomersContent,
	"Tips": $TipsContent,
	"Reputation": $ReputationContent
}

func _ready() -> void:
	for tab_name in panels.keys():
		var button: BaseButton = get_node(tab_name) as BaseButton
		button.pressed.connect(show_tab.bind(tab_name))
	$Close.pressed.connect(func() -> void: close_requested.emit())
	show_tab("Basics")

func show_tab(tab_name: String) -> void:
	for name in panels.keys():
		var selected: bool = name == tab_name
		panels[name].visible = selected
		# Keep every tab clickable while showing the blue artwork only on
		# the selected tab. The wooden tabs are part of the background.
		var button: BaseButton = get_node(name) as BaseButton
		button.modulate.a = 1.0 if selected else 0.0
