extends Control

	#pass



func _on_resume_pressed() -> void:
	get_parent().pauseGame()
	#pass # Replace with function body.


func _on_save_pressed() -> void:
	
	print("Game (will be) Saved") # Replace with PSS.


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	print("Display the Settings Menu Here") # Replace with function body.


func _on_main_menu_pressed() -> void:
	print("Really return to the Main Menu?") # Replace with function body.
