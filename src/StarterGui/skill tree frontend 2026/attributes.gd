extends Control

signal stats_changed(new_stats: Dictionary)

var player: Player = null
var skill_tree_panel: Node = null

var stats: Dictionary = {
	"Strength": 0,
	"Element": 0,
	"Fortitude": 0,
	"Agility": 0,
	"Tenacity": 0,
	"Intellect": 0,
}

@onready var strength_label: Label = $"Strength/Strength level"
@onready var element_label: Label = $"Element/Element level"
@onready var fortitude_label: Label = $"Fortitude/Fortitude level"
@onready var agility_label: Label = $"Agility/Agility level"
@onready var tenacity_label: Label = $"Tenacity/Tenacity level"
@onready var intellect_label: Label = $"Intellect/Intellect level"

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
	load_stats_from_player()
	update_labels()
	stats_changed.emit(stats)


func set_dependencies(new_player: Player, new_skill_tree_panel: Node) -> void:
	player = new_player
	skill_tree_panel = new_skill_tree_panel

	if skill_tree_panel == null:
		_find_skill_tree_panel()

	load_stats_from_player()
	update_labels()
	stats_changed.emit(stats)


func _find_skill_tree_panel() -> void:
	var possible_panel := get_parent().get_parent()

	if possible_panel != null and possible_panel.has_method("try_spend_points"):
		skill_tree_panel = possible_panel
	else:
		push_warning("Attributes.gd could not find the skill tree Panel with try_spend_points().")


func load_stats_from_player() -> void:
	if player == null:
		push_warning("Cannot load stats because player is null.")
		return

	stats["Strength"] = int(player.strength)
	stats["Element"] = int(player.element)
	stats["Fortitude"] = int(player.fortitude)
	stats["Agility"] = int(player.agility)
	stats["Tenacity"] = int(player.tenacity)
	stats["Intellect"] = int(player.intellect)


func save_stats_to_player() -> void:
	if player == null:
		push_warning("Cannot save stats because player is null.")
		return

	player.strength = int(stats["Strength"])
	player.element = int(stats["Element"])
	player.fortitude = int(stats["Fortitude"])
	player.agility = int(stats["Agility"])
	player.tenacity = int(stats["Tenacity"])
	player.intellect = int(stats["Intellect"])

	if player.has_method("_apply_attribute_effects"):
		player._apply_attribute_effects()

	if player.has_method("save_playerdata"):
		player.save_playerdata()


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


func add_stat(stat_name: String) -> void:
	if skill_tree_panel == null:
		_find_skill_tree_panel()

	if skill_tree_panel == null:
		push_warning("Cannot add " + stat_name + ": skill_tree_panel is null.")
		return

	if not skill_tree_panel.has_method("try_spend_points"):
		push_warning("Cannot add " + stat_name + ": skill_tree_panel has no try_spend_points().")
		return

	if not skill_tree_panel.try_spend_points(1):
		return

	stats[stat_name] += 1

	save_stats_to_player()
	update_labels()
	stats_changed.emit(stats)


func update_labels() -> void:
	strength_label.text = "%d" % int(stats["Strength"])
	element_label.text = "%d" % int(stats["Element"])
	fortitude_label.text = "%d" % int(stats["Fortitude"])
	agility_label.text = "%d" % int(stats["Agility"])
	tenacity_label.text = "%d" % int(stats["Tenacity"])
	intellect_label.text = "%d" % int(stats["Intellect"])
