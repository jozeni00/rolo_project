extends Control

@onready var ui := get_node("../..")  # Attributes -> TabContainer -> Panel

var stats := {
	"Strength": 1,
	"Element": 1,
	"Fortitude": 1,
	"Agility": 1,
	"Tenacity": 1,
	"Intellect": 1,
}

func _ready() -> void:
	_connect_stat_buttons()
	_refresh_stat_labels()

func _connect_stat_buttons() -> void:
	# expects each stat node (Strength, Element, etc.) to contain:
	# - a Button named "Add 1"
	# - a Label named "<StatName> level"
	for stat_node in get_children():
		if stats.has(stat_node.name):
			var btn := stat_node.get_node_or_null("Add 1") as Button
			if btn:
				btn.pressed.connect(func():
					_try_increase(stat_node.name)
				)

func _try_increase(stat_name: String) -> void:
	# spend 1 shared point from Panel
	if not ui.try_spend_points(1):
		ui.show_popup("Not enough attribute points!")
		return

	stats[stat_name] += 1
	_refresh_stat_labels()

func _refresh_stat_labels() -> void:
	for stat_node in get_children():
		if stats.has(stat_node.name):
			var lbl := stat_node.get_node_or_null(stat_node.name + " level") as Label
			if lbl:
				lbl.text = str(stats[stat_node.name])
