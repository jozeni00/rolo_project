extends Node2D

@onready var player = $Player

func _on_SaveButton_pressed():
	print("Save button clicked!")           # ← for debugging
	var player_data = player.get_save_data()
	var keybinds = {}
	SaveManager.save_game(1, player_data, keybinds)

func _on_LoadButton_pressed():
	print("Load button clicked!")            # ← for debugging
	var data = SaveManager.load_game(1)
	print("Loaded data:", data)
	if data.has("progress"):
		player.apply_save_data(data["progress"])
