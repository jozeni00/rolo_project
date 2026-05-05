extends Panel

@onready var points_label: Label = $"Attribute points"
@onready var popup: AcceptDialog = $"Skill unlocked"
@onready var tab_container: TabContainer = $"Skill tree container"
@onready var attributes_node: Node = $"Skill tree container/Attributes"

var player: Player = null

# Local fallback only. Main source should be player.skill_points.
var attribute_points := 0

var attributes: Dictionary = {
	"Strength": 0,
	"Element": 0,
	"Fortitude": 0,
	"Agility": 0,
	"Tenacity": 0,
	"Intellect": 0,
}

var skill_req := {
	# Fire
	"Fireball": {"Intellect": 2},
	"Flaming edge": {"Strength": 3, "Agility": 2},
	"Fire resistance": {"Fortitude": 4},

	# Water
	"Hydrobeam": {"Intellect": 2},
	"Splash": {"Intellect": 1},
	"Water resistance": {"Fortitude": 4},

	# Earth
	"Earthbound gate": {"Strength": 2, "Fortitude": 2},
	"Sandtorm slash": {"Agility": 3},
	"Stone armor": {"Fortitude": 5},

	# Air
	"Spearwind dash": {"Agility": 3},
	"Windward stun": {"Agility": 2, "Intellect": 1},
	"Air resistance": {"Fortitude": 4},

	# Acid
	"Trail of corrosion": {"Intellect": 2},
	"Corrode": {"Intellect": 3},
	"Acid resistance": {"Fortitude": 4},

	# Lightning
	"Shocking teleportation": {"Agility": 2, "Intellect": 2},
	"Striking stun": {"Agility": 3},
	"Lightning resistance": {"Fortitude": 4},
}

var unlocked := {}


func _ready() -> void:
	_refresh_points()
	_connect_all_skill_buttons()
	call_deferred("_setup_attributes")


func set_player(new_player: Player) -> void:
	player = new_player

	if player != null:
		var current_points = player.get("skill_points")
		if current_points != null:
			attribute_points = int(current_points)

	_refresh_points()


func set_attribute_points(points: int) -> void:
	attribute_points = points

	if player != null:
		player.set("skill_points", points)

	_refresh_points()
	print("PANEL ATTRIBUTE POINTS SET TO: ", attribute_points)


func _setup_attributes() -> void:
	if player == null:
		player = get_node_or_null("/root/Main/Chara")

	if attributes_node == null:
		push_warning("Panel: Could not find Skill tree container/Attributes.")
		return

	if player != null and attributes_node.has_method("set_dependencies"):
		attributes_node.set_dependencies(player, self)

	if attributes_node.has_signal("stats_changed"):
		if not attributes_node.stats_changed.is_connected(_on_stats_changed):
			attributes_node.stats_changed.connect(_on_stats_changed)
	else:
		push_warning("Panel: Attributes node does not have stats_changed signal.")

	var current_stats = attributes_node.get("stats")

	if current_stats is Dictionary:
		attributes = current_stats.duplicate(true)

	_update_skill_buttons()
	_refresh_points()


func get_current_points() -> int:
	if player != null:
		var current_points = player.get("skill_points")

		if current_points != null:
			attribute_points = int(current_points)

	return attribute_points


func add_points(n: int) -> void:
	var current_points := get_current_points()
	current_points += n

	attribute_points = current_points

	if player != null:
		player.set("skill_points", current_points)

	_refresh_points()


func try_spend_points(cost: int) -> bool:
	var current_points := get_current_points()

	print("try_spend_points called. Current points: ", current_points, " Cost: ", cost)

	if current_points < cost:
		show_popup("Not enough attribute points!")
		return false

	current_points -= cost

	attribute_points = current_points

	if player != null:
		player.set("skill_points", current_points)

	_refresh_points()

	print("Spend worked. Remaining points: ", current_points)

	return true


func _refresh_points() -> void:
	points_label.text = "Attribute points: %d" % get_current_points()


func _on_stats_changed(new_stats: Dictionary) -> void:
	attributes = new_stats.duplicate(true)
	print("PANEL RECEIVED UPDATED ATTRIBUTES: ", attributes)
	_update_skill_buttons()


func _connect_all_skill_buttons() -> void:
	var buttons := _find_buttons_recursive(tab_container)
	print("Found buttons under skill tree: ", buttons.size())

	for btn in buttons:
		if skill_req.has(btn.name):
			if not btn.pressed.is_connected(_on_skill_button_pressed.bind(btn.name)):
				btn.pressed.connect(_on_skill_button_pressed.bind(btn.name))


func _on_skill_button_pressed(skill_name: String) -> void:
	_try_unlock(skill_name)


func _find_buttons_recursive(root: Node) -> Array[Button]:
	var out: Array[Button] = []

	for child in root.get_children():
		if child is Button:
			out.append(child)

		out.append_array(_find_buttons_recursive(child))

	return out


func _try_unlock(skill_name: String) -> void:
	if unlocked.has(skill_name):
		show_popup("Already unlocked!")
		return

	if not skill_req.has(skill_name):
		show_popup("No data for: %s" % skill_name)
		return

	var missing := _missing_requirements(skill_name)

	if missing.size() > 0:
		show_popup("Requirements not met:\n" + "\n".join(missing))
		return

	unlocked[skill_name] = true
	show_popup("%s unlocked!" % skill_name)
	_update_skill_buttons()


func _missing_requirements(skill_name: String) -> Array[String]:
	var req: Dictionary = skill_req[skill_name]
	var missing: Array[String] = []

	for stat_name in req.keys():
		var need := int(req[stat_name])
		var have := int(attributes.get(stat_name, 0))

		if have < need:
			missing.append("%s: %d/%d" % [stat_name, have, need])

	return missing


func _update_skill_buttons() -> void:
	var buttons := _find_buttons_recursive(tab_container)

	for btn in buttons:
		if not skill_req.has(btn.name):
			continue

		var skill_name := btn.name
		var is_unlocked := unlocked.has(skill_name)
		var missing := _missing_requirements(skill_name)

		btn.disabled = is_unlocked

		if is_unlocked:
			btn.text = "%s\nUnlocked" % skill_name
		elif missing.size() == 0:
			btn.text = "%s\nReady" % skill_name
		else:
			btn.text = "%s\n%s" % [skill_name, _requirements_text(skill_name)]


func _requirements_text(skill_name: String) -> String:
	var req: Dictionary = skill_req[skill_name]
	var parts: Array[String] = []

	for stat_name in req.keys():
		var need := int(req[stat_name])
		var have := int(attributes.get(stat_name, 0))

		parts.append("%s %d/%d" % [stat_name, have, need])

	return ", ".join(parts)


func show_popup(msg: String) -> void:
	popup.dialog_text = msg
	popup.popup_centered()
