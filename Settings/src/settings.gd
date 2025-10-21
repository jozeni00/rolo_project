extends Control

var busy = false
var waiting = false		# indicates whether we are waiting/accepting user input
var placeholder = ""
var currentbutton

# --- Display & Sound Nodes ---
@onready var music_slider = $Sound/SoundSliders/Music
@onready var sfx_slider = $Sound/SoundSliders/SoundEffects
@onready var brightness_slider = $Display/DisplayControls/Brightness
@onready var resolution_option = $Display/DisplayControls/OptionButton
@onready var brightness_overlay = get_node("BrightnessOverlay")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set timer time
	#for str in InputMap.get_actions():
		#print(str)
	$Timer.wait_time = 3.0
	$Timer.one_shot = false
	# Iterate through buttons and connect the 'pressed' signal to a function
	for button in $Controls/KeyBindButtons.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed(button):
	# A keybind button has been pressed.
	# Give indication like removing current string
	waiting = true
	placeholder = button.text
	button.text = " "
	#$KeyBindButtons/Timer.start()
	currentbutton = button		# keeping track of button pressed
	print(button.name)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
	
func _input(event):	# an input was recieved
	if waiting:	# accepting user input
		var key_event = InputEventKey.new()
		if event is InputEventKey:
			currentbutton.text = event.as_text_keycode()
			key_event.keycode = event.keycode
			waiting = false
		elif event is InputEventMouseButton:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					currentbutton.text = "Left-Click"
				MOUSE_BUTTON_RIGHT:
					currentbutton.text = "Right-Click"
			#currentbutton.text = event.to_string()
			waiting = false
			
# Saves the current keybinds into a save slot
func save_keybinds(slot: int = 1):
	var keybind_data = {}

	for button in $Controls/KeyBindButtons.get_children():
		keybind_data[button.name] = button.text  # store button name and assigned key

	var player_data = {}  # placeholder if you want to add player progress later
	SaveManager.save_game(slot, player_data, keybind_data)
	print("Keybinds saved to slot %d" % slot)


# Loads keybinds from a save slot and updates the buttons
func load_keybinds(slot: int = 1):
	var data = SaveManager.load_game(slot)
	if data.has("keybinds"):
		for button in $Controls/KeyBindButtons.get_children():
			if data["keybinds"].has(button.name):
				button.text = data["keybinds"][button.name]
	print("Keybinds loaded from slot %d" % slot)	
		


# Music Volume
func _on_music_value_changed(value: float) -> void:
	# 0–100 → convert to decibels
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / 100.0))
	print("Music volume set to:", value)

# Sound Effects Volume
func _on_sound_effects_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value / 100.0))
	print("SFX volume set to:", value)

# Brightness Control
func _on_brightness_value_changed(value: float) -> void:
	if brightness_overlay:
		# 0 = darkest (black opaque), 100 = brightest (fully transparent)
		brightness_overlay.modulate = Color(0, 0, 0, (100.0 - value) / 100.0)
	print("Brightness set to:", value)


# Resolution Options
func _on_option_button_item_selected(index: int) -> void:
	var resolutions = [
		Vector2i(640, 360),
		Vector2i(1280, 720),
		Vector2i(1920, 1080)
	]
	DisplayServer.window_set_size(resolutions[index])
	print("Resolution changed to:", resolutions[index])
