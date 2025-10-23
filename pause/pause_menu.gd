extends Control

@onready var cbox = $ConfirmBox

var confirming = false

func _on_resume_pressed() -> void:
	get_parent().pauseGame()
	#pass # Replace with function body.


func _on_save_pressed() -> void:
	
	print("Game (will be) Saved") # Replace with PSS.


func _on_quit_pressed() -> void:
	print("'Ya sure?")
	confirming = true
	get_child(2).ask()
	print(get_child(2).get_answer())
	cbox.show()
	if(get_child(2).get_answer() == 1):
		get_tree().quit()
	elif(get_child(2).get_answer() == -1):
		confirming = false
		cbox.hide()
	"""
	while(confirming):
		if(get_child(2).get_answer() == 1):
			get_tree().quit()
		elif(get_child(2).get_answer() == -1):
			confirming = false
			cbox.hide()
			"""


func _on_options_pressed() -> void:
	print("Display the Settings Menu Here") # Replace with function body.
