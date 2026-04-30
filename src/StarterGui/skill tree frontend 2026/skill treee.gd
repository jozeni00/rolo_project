extends Control

var _player: Player

@onready var attribute_points_label: Label = $"Panel/Attribute points"

var player: Player:
	get:
		return _player
	set(value):
		_player = value
		_refresh_all()

func _refresh_all() -> void:
	if _player == null:
		return

	var panel = $Panel
	var attributes_node = panel.get_node("Skill tree container/Attributes")

	if attributes_node:
		attributes_node.set_dependencies(_player, panel)

	refresh_attribute_points()

func refresh_attribute_points(points: int = -1) -> void:
	if _player == null:
		return

	attribute_points_label.text = "Attribute points: %d" % _player.skill_points
