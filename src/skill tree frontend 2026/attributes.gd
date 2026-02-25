extends Control
var player: Player

signal stats_changed(new_stats: Dictionary)

# Attributes is inside TabContainer -> Panel is 2 levels up
@onready var ui := get_node("../..")

const ADD_BUTTON_NAME := "Add 1"

var ui: Panel

#@onready var player: Player = get_node("/root/Main/Player")


#var stats := {
	#"Strength": 1,
	#"Element": 1,
	#"Fortitude": 1,
	#"Agility": 1,
	#"Tenacity": 1,
	#"Intellect": 1,
#}
func set_dependencies(p: Player, panel: Panel) -> void:
	player = p
	ui = panel
	_refresh_stat_labels()
	
func _ready() -> void:
	_connect_stat_buttons()
	_refresh_all_labels()
	emit_signal("stats_changed", stats.duplicate(true))

func _connect_stat_buttons() -> void:
	for stat_node in get_children():
		if not stats.has(stat_node.name):
			continue

		var btn := stat_node.get_node_or_null(ADD_BUTTON_NAME) as Button
		if btn:
			btn.pressed.connect(func():
				_try_increase(stat_node.name)
			)

func _try_increase(stat_name: String) -> void:
	if not ui.try_spend_points(1):
		ui.show_popup("Not enough attribute points!")
		return
	stats[stat_name] += 1
	_set_label_for(stat_name)
	emit_signal("stats_changed", stats.duplicate(true))

func _refresh_all_labels() -> void:
	for stat_name in stats.keys():
		_set_label_for(stat_name)

func _set_label_for(stat_name: String) -> void:
	var stat_node := get_node_or_null(stat_name)
	if stat_node == null:
		return

	var lbl := stat_node.get_node_or_null("%s level" % stat_name) as Label
	if lbl:
		lbl.text = str(stats[stat_name])
