extends Control

# ----- main menu (sibling under Control)
@onready var main_menu: Control        = $'main menu'
@onready var start_button: Button      = $'main menu/StartButton'
@onready var options_button: Button    = $'main menu/OptionsButton'
@onready var quit_button: Button       = $'main menu/QuitButton'

# ----- start menu (sibling under Control)
@onready var start_menu: Control       = $'start menu'
@onready var new_btn: Button           = $'start menu/NewGameButton'
@onready var load_btn: Button          = $'start menu/LoadGameButton'
@onready var slot1_btn: Button         = $'start menu/Slot 1 button'
@onready var slot2_btn: Button         = $'start menu/Slot 2 button'
@onready var slot3_btn: Button         = $'start menu/Slot 3 button'
@onready var slot4_btn: Button         = $'start menu/Slot 4 button'
@onready var slot5_btn: Button         = $'start menu/Slot 5 button'

var slot_btns: Array[Button] = []

func _ready() -> void:
	# --- Sanity checks (will tell you exactly which path is wrong)
	assert(main_menu, "Missing: main menu")
	assert(start_button, "Missing: main menu/StartButton")
	assert(options_button, "Missing: main menu/OptionsButton")
	assert(quit_button, "Missing: main menu/QuitButton")

	assert(start_menu, "Missing: start menu")
	assert(new_btn, "Missing: start menu/NewGameButton")
	assert(load_btn, "Missing: start menu/LoadGameButton")
	assert(slot1_btn, "Missing: start menu/Slot 1 button")
	assert(slot2_btn, "Missing: start menu/Slot 2 button")
	assert(slot3_btn, "Missing: start menu/Slot 3 button")
	assert(slot4_btn, "Missing: start menu/Slot 4 button")
	assert(slot5_btn, "Missing: start menu/Slot 5 button")

	# Collect slots in order (1..5)
	slot_btns = [slot1_btn, slot2_btn, slot3_btn, slot4_btn, slot5_btn]

	# Initial state
	main_menu.visible = true
	start_menu.visible = false
	_set_start_choices_visible(true)
	_set_slots_visible(false)

	# Keep start_menu on top if both show
	start_menu.z_index = 100

	# Hook up signals
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	new_btn.pressed.connect(_on_new_game_pressed)
	load_btn.pressed.connect(_on_load_game_pressed)

	for i in slot_btns.size():
		var idx := i + 1
		slot_btns[i].pressed.connect(func(): _on_slot_pressed(idx))

# ===== Handlers =====

func _on_start_pressed() -> void:
	main_menu.visible = false
	start_menu.z_index = 100
	start_menu.visible = true
	_set_start_choices_visible(true)
	_set_slots_visible(false)

func _on_new_game_pressed() -> void:
	start_menu.visible = false
	main_menu.visible = true
	print("Start New Game selected")
	# TODO: change_scene_to_file("res://path/to/first_level.tscn")

func _on_load_game_pressed() -> void:
	_set_start_choices_visible(false)
	_set_slots_visible(true)
	print("Load Game: choose a slot")

func _on_slot_pressed(idx: int) -> void:
	print("Loading slot %d..." % idx)
	_set_slots_visible(false)
	_set_start_choices_visible(true)
	start_menu.visible = false
	main_menu.visible = true
	# TODO: actually load the selected slot

func _on_options_pressed() -> void:
	print("Options pressed")
	# TODO

func _on_quit_pressed() -> void:
	get_tree().quit()

# ===== Helpers =====

func _set_slots_visible(v: bool) -> void:
	for b in slot_btns:
		b.visible = v

func _set_start_choices_visible(v: bool) -> void:
	new_btn.visible = v
	load_btn.visible = v

func _any_slots_visible() -> bool:
	for b in slot_btns:
		if b.visible:
			return true
	return false

# ESC to back out
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if start_menu.visible and _any_slots_visible():
			_set_slots_visible(false)
			_set_start_choices_visible(true)
		elif start_menu.visible:
			start_menu.visible = false
			main_menu.visible = true
