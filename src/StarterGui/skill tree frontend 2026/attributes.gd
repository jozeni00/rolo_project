extends Control

signal stats_changed(new_stats: Dictionary)

var player: Player
var skill_tree_panel: Node = null

var stats: Dictionary = {
	"Strength": 0,
	"Element": 0,
	"Fortitude": 0,
	"Agility": 0,
	"Tenacity": 0,
	"Intellect": 0,
}

# These point to the number/level labels inside each attribute node.
# Example:
# Strength
# ├── Add 1
# └── Strength level
@onready var strength_label: Label = $"Strength/Strength level"
@onready var element_label: Label = $"Element/Element level"
@onready var fortitude_label: Label = $"Fortitude/Fortitude level"
@onready var agility_label: Label = $"Agility/Agility level"
@onready var tenacity_label: Label = $"Tenacity/Tenacity level"
@onready var intellect_label: Label = $"Intellect/Intellect level"

# Add 1 buttons inside each attribute node
@onready var strength_btn: Button = $"Strength/Add 1"
@onready var element_btn: Button = $"Element/Add 1"
@onready var fortitude_btn: Button = $"Fortitude/Add 1"
@onready var agility_btn: Button = $"Agility/Add 1"
@onready var tenacity_btn: Button = $"Tenacity/Add 1"
@onready var intellect_btn: Button = $"Intellect/Add 1"


func _ready() -> void:
	call_deferred("_late_ready")


func _late_ready() -> void:
	_find_skill_tree_panel()
	_connect_buttons()
	update_labels()
	stats_changed.emit(stats)


func set_dependencies(new_player: Player, new_skill_tree_panel: Node) -> void:
	player = new_player
	skill_tree_panel = new_skill_tree_panel

	print("Attributes.gd received skill_tree_panel: ", skill_tree_panel)

	if skill_tree_panel == null:
		_find_skill_tree_panel()

	update_labels()
	stats_changed.emit(stats)


func _find_skill_tree_panel() -> void:
	# Expected structure:
	# Panel
	# └── Skill tree container
	#     └── Attributes
	var possible_panel := get_parent().get_parent()

	print("Attributes.gd possible_panel found: ", possible_panel)

	if possible_panel != null and possible_panel.has_method("try_spend_points"):
		skill_tree_panel = possible_panel
		print("Attributes.gd linked to Panel successfully.")
	else:
		push_warning("Attributes.gd could not find the skill tree Panel with try_spend_points().")


func _connect_buttons() -> void:
	_connect_button(strength_btn, "Strength")
	_connect_button(element_btn, "Element")
	_connect_button(fortitude_btn, "Fortitude")
	_connect_button(agility_btn, "Agility")
	_connect_button(tenacity_btn, "Tenacity")
	_connect_button(intellect_btn, "Intellect")


func _connect_button(button: Button, stat_name: String) -> void:
	if button == null:
		push_warning("Missing Add 1 button for: " + stat_name)
		return

	if not button.pressed.is_connected(add_stat.bind(stat_name)):
		button.pressed.connect(add_stat.bind(stat_name))

	print("Connected button for: ", stat_name)


func add_stat(stat_name: String) -> void:
	if skill_tree_panel == null:
		_find_skill_tree_panel()

	if skill_tree_panel == null:
		push_warning("Cannot add " + stat_name + ": skill_tree_panel is null.")
		return

	if not skill_tree_panel.has_method("try_spend_points"):
		push_warning("Cannot add " + stat_name + ": skill_tree_panel has no try_spend_points().")
		return

	print("Trying to add stat: ", stat_name)

	if skill_tree_panel.has_method("get_current_points"):
		print("Panel attribute_points before spend: ", skill_tree_panel.get_current_points())
	else:
		print("Panel attribute_points before spend: ", skill_tree_panel.attribute_points)

	if not skill_tree_panel.try_spend_points(1):
		if skill_tree_panel.has_method("get_current_points"):
			print("Spend failed. Panel attribute_points is: ", skill_tree_panel.get_current_points())
		else:
			print("Spend failed. Panel attribute_points is: ", skill_tree_panel.attribute_points)
		return

	stats[stat_name] += 1

	print("Spend worked. New stats: ", stats)

	if skill_tree_panel.has_method("get_current_points"):
		print("Panel attribute_points after spend: ", skill_tree_panel.get_current_points())
	else:
		print("Panel attribute_points after spend: ", skill_tree_panel.attribute_points)

	update_labels()
	stats_changed.emit(stats)


func update_labels() -> void:
	strength_label.text = "%d" % stats["Strength"]
	element_label.text = "%d" % stats["Element"]
	fortitude_label.text = "%d" % stats["Fortitude"]
	agility_label.text = "%d" % stats["Agility"]
	tenacity_label.text = "%d" % stats["Tenacity"]
	intellect_label.text = "%d" % stats["Intellect"]
