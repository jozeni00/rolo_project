extends HBoxContainer

@export var attribute_name: String

@onready var name_label: Label = $Name
@onready var value_label: Label = $Value
@onready var add_button: Button = $AddButton

var player: Player

func setup(p: Player):
	player = p
	name_label.text = attribute_name.capitalize()
	update_ui()

func update_ui():
	if not player:
		return

	value_label.text = str(player.get(attribute_name))
	add_button.disabled = player.skill_points <= 0

func _on_AddButton_pressed():
	if player.spend_point(attribute_name):
		update_ui()

func _on_add_button_pressed() -> void:
	if player and player.spend_point(attribute_name):
		update_ui()
