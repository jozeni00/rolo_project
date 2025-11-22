extends Control


func _ready() -> void:
	$Settings.visible = false
	$Settings/ConfirmationDialog.confirmed.connect(_on_accept_pressed)

func _on_resume_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_parent().pauseGame()
	#pass # Replace with function body.


func _on_save_pressed() -> void:
	$SaveManager.save_game(1, get_tree().get_first_node_in_group("Player").get_save_data(), {})
	print("Game (will be) Saved") # Replace with PSS.


func _on_quit_pressed() -> void:
	#$ConfirmationDialog.popup_center()
	$GraphFrame/MarginContainer/VBoxContainer/quitConfirm.popup_centered()

		


func _on_options_pressed() -> void:
	print("Display the Settings Menu Here") # Replace with function body.
	$GraphFrame.visible = false
	$Settings.visible = true

func _on_accept_pressed() -> void:
	$Settings.visible = false
	$GraphFrame.visible = true

func _on_main_menu_pressed() -> void:
	$GraphFrame/MarginContainer/VBoxContainer/mainConfirm.popup_centered()
	#print("Really return to the Main Menu?") # Replace with function body.




func _on_quit_confirm_confirmed() -> void:
	get_tree().quit()
	#pass # Replace with function body.


func _on_main_confirm_confirmed() -> void:
	get_tree().change_scene_to_file("res://src/main menu/control.tscn")
	#print("Really return to the Main Menu?") # Replace with function body.
	#pass # Replace with function body.
