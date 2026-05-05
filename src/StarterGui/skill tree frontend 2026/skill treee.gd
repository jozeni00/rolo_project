extends Control

var _player: Player

@onready var panel: Panel = $Panel
@onready var attribute_points_label: Label = $"Panel/Attribute points"

var player: Player:
	get:
		return _player
	set(value):
		_player = value
		_refresh_all()


func _ready() -> void:
	_refresh_all()


func _refresh_all() -> void:
	if _player == null:
		return

	if panel != null and panel.has_method("set_player"):
		panel.set_player(_player)

	var attributes_node = panel.get_node_or_null("Skill tree container/Attributes")

	if attributes_node != null and attributes_node.has_method("set_dependencies"):
		attributes_node.set_dependencies(_player, panel)

	refresh_attribute_points()


func refresh_attribute_points(points: int = -1) -> void:
	if _player == null:
		return

	var current_points := int(_player.skill_points)

	attribute_points_label.text = "Attribute points: %d" % current_points

	if panel != null and panel.has_method("set_attribute_points"):
		panel.set_attribute_points(current_points)


func save_before_close() -> void:
	var attributes_node = panel.get_node_or_null("Skill tree container/Attributes")

	if attributes_node != null and attributes_node.has_method("save_stats_to_player"):
		attributes_node.save_stats_to_player()
