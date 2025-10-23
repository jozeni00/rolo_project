extends Control

# --- Node references (quotes needed because of the space in "main menu")
@onready var main_menu: Control        = $'main menu'
@onready var start_button: Button      = $'main menu/StartButton'
@onready var options_button: Button    = $'main menu/OptionsButton'
@onready var quit_button: Button       = $'main menu/QuitButton'

@onready var start_menu: Control       = $'main menu/start menu'
@onready var new_btn: Button           = $'main menu/start menu/NewGameButton'
@onready var load_btn: Button          = $'main menu/start menu/LoadGameButton'

func _ready() -> void:
	# Sanity checks (helps you debug node path mismatches)
	assert(start_button, "Missing node: main menu/StartButton")
	assert(options_button, "Missing node: main menu/OptionsButton")
	assert(quit_button, "Missing node: main menu/QuitButton")
	assert(start_menu, "Missing node: main menu/start menu")
	assert(new_btn, "Missing node: main menu/start menu/NewGameButton")
	assert(load_btn, "Missing node: main menu/start menu/LoadGameButton")

	# Connect button signals
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	new_btn.pressed.connect(_on_new_game_pressed)
	load_btn.pressed.connect(_on_load_game_pressed)

	# Start menu starts hidden and on top
	start_menu.visible = false
	start_menu.z_index = 100
	start_menu.z_as_relative = false

# -----------------------------
# Button Handlers
# -----------------------------

func _on_start_pressed() -> void:
	# Show the overlay (start menu) on top of main menu
	start_menu.visible = true
	main_menu.move_child(start_menu, main_menu.get_child_count() - 1)
	_set_main_menu_enabled(false)

func _on_new_game_pressed() -> void:
	start_menu.visible = false
	_set_main_menu_enabled(true)
	_start_new_game()

func _on_load_game_pressed() -> void:
	start_menu.visible = false
	_set_main_menu_enabled(true)
	_load_game()

func _on_options_pressed() -> void:
	print("Options pressed")
	# TODO: implement options screen

func _on_quit_pressed() -> void:
	get_tree().quit()

# -----------------------------
# Core Logic
# -----------------------------

func _start_new_game() -> void:
	print("Start New Game selected")
	# TODO: change_scene_to_file("res://path/to/first_level.tscn")

func _load_game() -> void:
	print("Load Game selected")
	# TODO: open file dialog / load save slot etc.

func _set_main_menu_enabled(on: bool) -> void:
	start_button.disabled = not on
	options_button.disabled = not on
	quit_button.disabled = not on

# -----------------------------
# Extra: ESC closes the start menu
# -----------------------------
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and start_menu.visible:
		start_menu.visible = false
		_set_main_menu_enabled(true)
