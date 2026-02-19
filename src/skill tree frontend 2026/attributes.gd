extends Control
var player: Player

@onready var ui := get_node("../..")  # Attributes -> TabContainer -> Panel
#@onready var player: Player = get_node("/root/Main/Player")


#var stats := {
	#"Strength": 1,
	#"Element": 1,
	#"Fortitude": 1,
	#"Agility": 1,
	#"Tenacity": 1,
	#"Intellect": 1,
#}

func _ready() -> void:
	_connect_stat_buttons()
	_refresh_stat_labels()

func _connect_stat_buttons() -> void:
	for stat_node in get_children():
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
	_refresh_stat_labels()

func _refresh_stat_labels() -> void:
	for stat_node in get_children():
		var lbl := stat_node.get_node_or_null(stat_node.name + " level") as Label
		if not lbl:
			continue

		match stat_node.name:
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
