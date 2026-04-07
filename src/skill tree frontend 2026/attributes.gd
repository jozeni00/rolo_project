extends Control

var player: Player

signal stats_changed(new_stats: Dictionary)

# Attributes is inside TabContainer -> Panel is 2 levels up
@onready var ui := get_node("../..")

# var ui: Panel

var stats := {}

const ADD_BUTTON_NAME := "Add 1"

func set_dependencies(p: Player, panel: Panel) -> void:
	player = p
	ui = panel
	_refresh_all_labels()
	_emit_stats()

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
	match stat_name:
		"Strength":
			player.strength += 1
		"Element":
			player.element += 1
		"Fortitude":
			player.fortitude += 1
		"Agility":
			player.agility += 1
		"Tenacity":
			player.tenacity += 1
		"Intellect":
			player.intellect += 1

	_set_label_for(stat_name)
	_emit_stats()

func _refresh_all_labels() -> void:
	_set_label_for("Strength")
	_set_label_for("Element")
	_set_label_for("Fortitude")
	_set_label_for("Agility")
	_set_label_for("Tenacity")
	_set_label_for("Intellect")

func _set_label_for(stat_name: String) -> void:
	if player == null:
		return
	var stat_node := get_node_or_null(stat_name)
	if stat_node == null:
		return

	var lbl := stat_node.get_node_or_null("%s level" % stat_name) as Label
	if not lbl:
		return

	match stat_name:
		"Strength":
			lbl.text = str(player.strength)
		"Element":
			lbl.text = str(player.element)
		"Fortitude":
			lbl.text = str(player.fortitude)
		"Agility":
			lbl.text = str(player.agility)
		"Tenacity":
			lbl.text = str(player.tenacity)
		"Intellect":
			lbl.text = str(player.intellect)

func _emit_stats() -> void:
	if not player:
		return

	var stats := {
		"Strength": player.strength,
		"Element": player.element,
		"Fortitude": player.fortitude,
		"Agility": player.agility,
		"Tenacity": player.tenacity,
		"Intellect": player.intellect,
	}

	emit_signal("stats_changed", stats)
