extends Control

@export var settings_menu_scene: PackedScene   # assign settings_menu.tscn in Inspector

# ===================== #
#        TESTING        #
# ===================== #
const TEST_MODE := false
# Pretend these slots already have saves when in TEST_MODE:
var _mock_used: Dictionary = {2: true, 4: true}  # change as you like

# ===================== #
#      REAL SAVES       #
# ===================== #
# const SAVE_DIR := "C:\\Users\\Arman\\Documents\\GitHub\\rolo_project\\src\\PlayerSave\\data\\"
const SAVE_DIR := "user://PlayerSave/data/"
const SAVE_FMT := "slot%d.save"

func _slot_path(idx:int) -> String:
	return "%s/%s" % [SAVE_DIR, SAVE_FMT % idx]

func _ensure_save_dir() -> void:
	if TEST_MODE:
		return
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_recursive_absolute(SAVE_DIR)

func _slot_exists(idx:int) -> bool:
	#if TEST_MODE:
	#	return _mock_used.get(idx, false)
	return FileAccess.file_exists(_slot_path(idx))

func _write_new_game(idx:int) -> void:
	if TEST_MODE:
		_mock_used[idx] = true
		return
	var data := {
		"version": 1,
		"created_at": Time.get_unix_time_from_system(),
		"player": {"name":"Hero","level":1,"hp":100},
		"progress": {"chapter":1,"checkpoint":"intro"}
	}
	var f := FileAccess.open(_slot_path(idx), FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))
		f.flush()
		f.close()

func _read_save(idx:int) -> Dictionary:
	if TEST_MODE:
		return {} if not _mock_used.get(idx, false) else {"created_at": Time.get_unix_time_from_system()}
	if not _slot_exists(idx):
		return {}
	var f := FileAccess.open(_slot_path(idx), FileAccess.READ)
	if not f:
		return {}
	var txt := f.get_as_text()
	f.close()
	var res = JSON.parse_string(txt)
	return res if typeof(res) == TYPE_DICTIONARY else {}

func _delete_save(idx:int) -> bool:
	if TEST_MODE:
		if _mock_used.get(idx, false):
			_mock_used[idx] = false
			return true
		return false
	var p := _slot_path(idx)
	if FileAccess.file_exists(p):
		return DirAccess.remove_absolute(p) == OK
	return false

# ===================== #
#        UI NODES       #
# ===================== #
@onready var main_menu: Control        = $"main menu"
@onready var start_menu: Control       = $"start menu"
@onready var options_holder: Control   = $"options_holder"   # container for settings menu
@onready var settings_menu: Control    = $"Settings"

@onready var start_button: Button      = $"main menu/StartButton"
@onready var options_button: Button    = $"main menu/OptionsButton"
@onready var quit_button: Button       = $"main menu/QuitButton"
@onready var quit_confirm: ConfirmationDialog = $"main menu/QuitConfirm"

@onready var new_btn: Button           = $"start menu/NewGameButton"
@onready var load_btn: Button          = $"start menu/LoadGameButton"
@onready var delete_btn: Button        = $"start menu/DeleteSlotButton"
@onready var back_btn: Button          = ($"start menu/BackButton" if has_node("start menu/BackButton") else null)

@onready var slot1_btn: Button         = $"start menu/Slot 1 button"
@onready var slot2_btn: Button         = $"start menu/Slot 2 button"
@onready var slot3_btn: Button         = $"start menu/Slot 3 button"
@onready var slot4_btn: Button         = $"start menu/Slot 4 button"
@onready var slot5_btn: Button         = $"start menu/Slot 5 button"

@onready var slot_confirm: ConfirmationDialog   = $"start menu/SlotConfirm"    # NEW/LOAD
@onready var delete_confirm: ConfirmationDialog = $"start menu/DeleteConfirm"  # DELETE
@onready var status_label: Label       = $"start menu/StatusLabel"
@onready var saveManage := $SaveManager

# ===================== #
#     STATE / ARRAYS    #
# ===================== #
var slot_btns: Array[Button] = []
var selected_slot: int = -1   # slot the user clicked (1..5)
var options_instance: Control = null   # instance of settings_menu.tscn

# ===================== #
#         READY         #
# ===================== #
func _ready() -> void:
	print("control.gd _ready: starting main menu")

	slot_btns = [slot1_btn, slot2_btn, slot3_btn, slot4_btn, slot5_btn]
	_ensure_save_dir()

	# popups clearly visible/on-top
	for d in [slot_confirm, delete_confirm, quit_confirm]:
		if d:
			d.exclusive = true
			d.transient = true
			d.unresizable = true
			d.min_size = Vector2(380, 180)

	# main menu wiring
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	$Settings/ConfirmationDialog.confirmed.connect(_on_accept_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	quit_confirm.confirmed.connect(func(): get_tree().quit())

	# start menu wiring
	new_btn.pressed.connect(_on_new_game_pressed)    # acts on selected slot
	load_btn.pressed.connect(_on_load_game_pressed)  # acts on selected slot
	delete_btn.pressed.connect(_on_delete_pressed)   # acts on selected slot

	if back_btn:
		back_btn.pressed.connect(_on_back_pressed)
	else:
		push_warning("BackButton node not found under 'start menu' (optional).")

	for i in range(slot_btns.size()):
		var idx := i + 1
		slot_btns[i].pressed.connect(func(): _on_slot_selected(idx))

	slot_confirm.confirmed.connect(_on_slot_confirmed)
	delete_confirm.confirmed.connect(_on_delete_confirmed)

	# initial visibility – ONLY main menu visible
	main_menu.visible = true
	start_menu.visible = false
	#options_holder.visible = false
	settings_menu.visible = false

	_refresh_slot_labels()
	_update_buttons_enabled()
	_set_status("TEST MODE: No files written. (Slots 2 & 4 start as USED.)" if TEST_MODE else "")

# ===================== #
#     MAIN MENU FLOW    #
# ===================== #
func _on_start_pressed() -> void:
	main_menu.visible = false
	start_menu.visible = true
	#options_holder.visible = false
	_set_status("Select a slot, then press New / Load / Delete.")

func _on_quit_pressed() -> void:
	quit_confirm.title = "Quit Game?"
	quit_confirm.dialog_text = "Are you sure you want to quit?"
	quit_confirm.popup_centered_ratio(0.35)

func _on_options_pressed() -> void:
	print("_on_options_pressed – opening settings")

	# hide other menus, show options_holder
	main_menu.visible = false
	start_menu.visible = false
#	options_holder.visible = true
	settings_menu.visible = true
	# Instance options menu once
	#if options_instance == null:
		#if settings_menu_scene == null:
			#push_error("settings_menu_scene is not assigned in Inspector!")
		#else:
			#options_instance = settings_menu_scene.instantiate()
			#options_holder.add_child(options_instance)

	# wire Accept button inside settings menu as our Back button
	#_wire_settings_menu()
#
	#_set_status("Options")

func _on_accept_pressed() -> void:
	settings_menu.visible = false
	main_menu.visible = true


func _on_options_back_pressed() -> void:
	print("_on_options_back_pressed – back to main menu")

	options_holder.visible = false
	start_menu.visible = false
	main_menu.visible = true
	_set_status("")

# ===================== #
#     BACK -> MAIN      #
# ===================== #
func _on_back_pressed() -> void:
	# Close any dialogs (if they were open)
	if slot_confirm.visible:
		slot_confirm.hide()
	if delete_confirm.visible:
		delete_confirm.hide()

	# Clear selection and return to main
	selected_slot = -1
	_highlight_selected_slot(-1)
	_update_buttons_enabled()

	start_menu.visible = false
	main_menu.visible = true
#	options_holder.visible = false
	_set_status("")

# ===================== #
#     SLOT SELECTION    #
# ===================== #
func _on_slot_selected(idx:int) -> void:
	selected_slot = idx
	_highlight_selected_slot(idx)
	_update_buttons_enabled()
	var used := _slot_exists(idx)
	var used_text := "USED" if used else "Empty"
	_set_status("Selected Slot %d (%s)" % [idx, used_text])

# ===================== #
#   BUTTON -> POPUPS    #
#   (uses selected_slot)
# ===================== #
func _on_new_game_pressed() -> void:
	if selected_slot <= 0:
		_set_status("Select a slot first, then press New Game.")
		return
	var warn := "\nThis will OVERWRITE any existing save." if _slot_exists(selected_slot) else ""
	slot_confirm.title = "Confirm New Game"
	slot_confirm.dialog_text = "Start a NEW game in Slot %d?%s" % [selected_slot, warn]
	slot_confirm.set_meta("mode", "new")
	slot_confirm.popup_centered_ratio(0.35)

func _on_load_game_pressed() -> void:
	if selected_slot <= 0:
		_set_status("Select a slot first, then press Load Game.")
		return
	slot_confirm.title = "Confirm Load Game"
	if _slot_exists(selected_slot):
		slot_confirm.dialog_text = "Load game from Slot %d?" % selected_slot
		slot_confirm.set_meta("mode", "load")
	else:
		slot_confirm.dialog_text = "Slot %d is empty.\nStart a NEW game here instead?" % selected_slot
		slot_confirm.set_meta("mode", "new")
	slot_confirm.popup_centered_ratio(0.35)

func _on_delete_pressed() -> void:
	if selected_slot <= 0:
		_set_status("Select a slot first, then press Delete.")
		return
	if not _slot_exists(selected_slot):
		_set_status("Slot %d is already empty." % selected_slot)
		return
	delete_confirm.title = "Delete Slot %d?" % selected_slot
	delete_confirm.dialog_text = "Are you sure you want to DELETE Slot %d?\nThis cannot be undone." % selected_slot
	delete_confirm.popup_centered_ratio(0.35)

# ===================== #
#     CONFIRM RESULTS   #
# ===================== #
func _on_slot_confirmed() -> void:
	if selected_slot <= 0:
		return
	var mode := String(slot_confirm.get_meta("mode", ""))
	match mode:
		"new":
			_write_new_game(selected_slot)
			if TEST_MODE:
				_set_status("TEST: Marked Slot %d as USED." % selected_slot)
			else:
				_set_status("New game saved to Slot %d" % selected_slot)
		"load":
			var save := _read_save(selected_slot)
			if save.is_empty():
				_set_status("Slot %d was empty — starting NEW game." % selected_slot)
				_write_new_game(selected_slot)
			else:
				_set_status("TEST: Loaded Slot %d (mock)." % selected_slot if TEST_MODE else "Loaded Slot %d" % selected_slot)
				saveManage.load_game(selected_slot)
				get_tree().change_scene_to_file("res://src/main/main.tscn")
	_refresh_slot_labels()
	_update_buttons_enabled()

func _on_delete_confirmed() -> void:
	if selected_slot <= 0:
		return
	if _delete_save(selected_slot):
		if TEST_MODE:
			_set_status("TEST: Marked Slot %d as EMPTY." % selected_slot)
		else:
			_set_status("Deleted Slot %d." % selected_slot)
	else:
		_set_status("Failed to delete Slot %d." % selected_slot)
	_refresh_slot_labels()
	_update_buttons_enabled()

# ===================== #
#   SETTINGS WIRES      #
# ===================== #

func _wire_settings_menu() -> void:
	if options_instance == null:
		return

	# 1) Try to get node named "Accept" directly
	var accept_node: Node = null
	if settings_menu.has_node("Accept"):
		accept_node = settings_menu.get_node("Accept")
	else:
		# 2) Fallback: search recursively for a node named "Accept"
		accept_node = settings_menu.find_child("Accept", true, false)

	if accept_node == null:
		push_warning("settings_menu.tscn has no node named 'Accept'")
		return

	if not (accept_node is BaseButton):
		push_warning("'Accept' node exists but is not a BaseButton")
		return

	var accept_btn: BaseButton = accept_node as BaseButton

	# Disconnect any existing _on_accept_pressed connections to avoid crashes
	var conns: Array = accept_btn.pressed.get_connections()
	for conn in conns:
		var callable: Callable = conn["callable"]
		if callable.get_method() == "_on_accept_pressed":
			accept_btn.pressed.disconnect(callable)

	# Connect Accept button as our Back button
	if not accept_btn.pressed.is_connected(_on_options_back_pressed):
		accept_btn.pressed.connect(_on_options_back_pressed)

	print("Settings: wired Accept button as Back at path:", accept_btn.get_path())

# ===================== #
#        HELPERS        #
# ===================== #
func _refresh_slot_labels() -> void:
	for i in range(slot_btns.size()):
		var idx := i + 1
		var b := slot_btns[i]
		if not b:
			continue
		if _slot_exists(idx):
			b.text = "Slot %d  (USED)" % idx
		else:
			b.text = "Slot %d  (Empty)" % idx

func _update_buttons_enabled() -> void:
	var has_sel := selected_slot > 0
	var sel_used := has_sel and _slot_exists(selected_slot)
	new_btn.disabled = not has_sel
	load_btn.disabled = not has_sel
	delete_btn.disabled = not (has_sel and sel_used)

func _highlight_selected_slot(idx:int) -> void:
	for i in range(slot_btns.size()):
		var b := slot_btns[i]
		if not b:
			continue
		b.self_modulate = Color(1.0, 0.95, 0.8, 1.0) if (i + 1) == idx else Color(1, 1, 1, 1)

func _set_status(msg: String) -> void:
	if status_label:
		status_label.text = msg
	print(msg)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if options_holder.visible:
			_on_options_back_pressed()
		elif start_menu.visible and not slot_confirm.visible and not delete_confirm.visible:
			_on_back_pressed()
