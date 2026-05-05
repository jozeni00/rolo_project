extends Panel

@onready var points_label: Label = $"Attribute points"
@onready var popup: AcceptDialog = $"Skill unlocked"
@onready var tab_container: TabContainer = $"Skill tree container"

var player: Player

@onready var attributes_node: Node = $"Skill tree container/Attributes"

# -----------------------------
# ATTRIBUTE POINTS
# -----------------------------
var attribute_points := 0

# -----------------------------
# SKILL REQUIREMENTS
# -----------------------------
var attributes: Dictionary = {}

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

	if attributes_node and attributes_node.has_signal("stats_changed"):
		if not attributes_node.stats_changed.is_connected(_on_stats_changed):
			attributes_node.stats_changed.connect(_on_stats_changed)
	else:
		push_warning("Panel: Could not connect to Attributes.stats_changed. Make sure Attributes.gd is on 'Skill tree container/Attributes' and defines stats_changed.")

	_update_skill_buttons()

func _setup_attributes() -> void:
	player = get_node("/root/Main/Chara")

	if attributes_node and player:
		attributes_node.set_dependencies(player, self)

	if attributes_node and attributes_node.has_signal("stats_changed"):
		if not attributes_node.stats_changed.is_connected(_on_stats_changed):
			attributes_node.stats_changed.connect(_on_stats_changed)
	else:
		push_warning("Panel: Could not connect to Attributes.stats_changed. Make sure Attributes.gd is on 'Skill tree container/Attributes' and defines stats_changed.")

	if attributes_node:
		attributes = attributes_node.stats.duplicate(true)

	_update_skill_buttons()

func add_points(n: int) -> void:
	attribute_points += n
	_refresh_points()

func try_spend_points(cost: int) -> bool:
	if attribute_points < cost:
		return false

	attribute_points -= cost
	_refresh_points()
	return true

func show_popup(msg: String) -> void:
	popup.dialog_text = msg
	popup.popup_centered()

func _refresh_points() -> void:
	points_label.text = "Attribute points: %d" % attribute_points

func _on_stats_changed(new_stats: Dictionary) -> void:
	attributes = new_stats.duplicate(true)
	_update_skill_buttons()

func _connect_all_skill_buttons() -> void:
	var buttons := _find_buttons_recursive(tab_container)
	print("Found buttons under skill tree:", buttons.size())

	for btn in buttons:
		if skill_req.has(btn.name):
			btn.pressed.connect(func():
				_try_unlock(btn.name)
			)

func _find_buttons_recursive(root: Node) -> Array[Button]:
	var out: Array[Button] = []

	for c in root.get_children():
		if c is Button:
			out.append(c)

		out.append_array(_find_buttons_recursive(c))

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
	show_popup("Skill unlocked!")
	_update_skill_buttons()

func _missing_requirements(skill_name: String) -> Array[String]:
	var req: Dictionary = skill_req[skill_name]
	var missing: Array[String] = []

	for stat in req.keys():
		var need := int(req[stat])
		var have := int(attributes.get(stat, 0))

		if have < need:
			missing.append("%s: %d/%d" % [stat, have, need])

	return missing

func _update_skill_buttons() -> void:
	var buttons := _find_buttons_recursive(tab_container)

	for btn in buttons:
		if not skill_req.has(btn.name):
			continue

		var name := btn.name
		var is_unlocked := unlocked.has(name)

		btn.disabled = is_unlocked

		if is_unlocked:
			btn.text = "%s (Unlocked)" % name
		else:
			btn.text = name
