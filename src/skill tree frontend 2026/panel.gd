extends Panel

@onready var points_label: Label = $"Attribute points"
@onready var add_points_btn: Button = $"Attribute points/Add 1 test for attribute points"
@onready var popup: AcceptDialog = $"Skill unlocked"
@onready var tab_container: TabContainer = $"Skill tree container"

var attribute_points := 0

# ALL skill buttons (cost in attribute points, test case)
var skill_cost := {
	# Fire
	"Fireball": 1,
	"Flaming edge": 1,
	"Fire resistance": 1,

	# Water
	"Hydrobeam": 1,
	"Splash": 1,
	"Water resistance": 1,

	# Earth
	"Earthbound gate": 1,
	"Sandtorm slash": 1,
	"Stone armor": 1,

	# Air
	"Spearwind dash": 1,
	"Windward stun": 1,
	"Air resistance": 1,

	# Acid
	"Trail of corrosion": 1,
	"Corrode": 1,
	"Acid resistance": 1,

	# Lightning
	"Shocking teleportati": 1,
	"Striking stun": 1,
	"Lightning resistance": 1,
}

var unlocked := {}

func _ready() -> void:
	add_points_btn.pressed.connect(func():
		add_points(1)
	)

	_refresh_points()
	_connect_all_skill_buttons()

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

func _connect_all_skill_buttons() -> void:
	var buttons := _find_buttons_recursive(tab_container)
	print("Found buttons under skill tree:", buttons.size())

	for btn in buttons:
		# Only connect buttons that match our skill list
		if skill_cost.has(btn.name):
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

	if not skill_cost.has(skill_name):
		show_popup("No data for: %s" % skill_name)
		return

	var cost := int(skill_cost[skill_name])

	if not try_spend_points(cost):
		show_popup("Not enough attribute points!")
		return

	unlocked[skill_name] = true
	show_popup("Skill unlocked!")
