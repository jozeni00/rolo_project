extends Node

const SAVE_PATH = "user://PlayerSave/data/"
signal loadComplete
const NUM_SLOTS = 5

func save_game(slot: int, player_data: Dictionary, keybinds: Dictionary):
	if slot < 1 or slot > NUM_SLOTS:
		push_error("Invalid save slot.")
		return
		
	DirAccess.make_dir_recursive_absolute(SAVE_PATH)

	var file_path = SAVE_PATH + "slot%d.save" % slot
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var save_data = {
			"progress": player_data,
			"keybinds": keybinds,
			"timestamp": Time.get_datetime_string_from_system()
		}
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("Game saved to slot %d" % slot)
		print("Saving to path: ", file_path)

func load_game(slot: int) -> Dictionary:
	
	var file_path = SAVE_PATH + "slot%d.save" % slot
	if not FileAccess.file_exists(file_path):
		return {}
	var file = FileAccess.open(file_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) == TYPE_DICTIONARY:
		print("DATA FOUND")
		return data
	return {}
	
