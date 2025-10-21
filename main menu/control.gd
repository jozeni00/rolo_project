extends Control
@onready var my_button = $Panel/Button 

func _ready() -> void:
	my_button.pressed.connect(_on_Button_pressed)
	
@onready var panel_node = $Panel

func _on_Button_pressed():

	panel_node.visible = not panel_node.visible
	
