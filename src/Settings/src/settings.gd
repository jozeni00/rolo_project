extends Control

@onready var acceptbutton: Button = $%Accept
@onready var confirmdialog: ConfirmationDialog = $ConfirmationDialog
@onready var exitbutton: Button = $%Exit
@onready var testaudio: AudioStreamPlayer2D = $Panel/ScrollContainer/VBoxContainer/Sounds/testbeep
@onready var sounds: ReferenceRect = $%Sounds

@onready var soundsection := $%Sounds
@onready var displaysection := $%Displays
@onready var keybindsection := $%KeyBindButtons


const configPath: String = "user://settings.cfg"
const BUSSES = ["Master", "SoundEffect", "Music"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_config()
	## Bind 'Accept' and 'Exit' buttons
	acceptbutton.pressed.connect(_on_accept_pressed)
	confirmdialog.confirmed.connect(_on_confirmed)
	for sound in sounds.get_children():
		if sound is VolumeHSlider:
			sound.drag_ended.connect(_on_sound_value_changed.bind(sound))

func load_config() -> void:
	var config: ConfigFile = ConfigFile.new()
	var err = config.load(configPath)
	
	if err != OK:
		return		# cannot load config file, NOP (ignore)
	
	## Get the sections in config and update current settings
	# updating sound settings
	for sound in soundsection.get_children():
		if sound is HSlider:
			sound.value = config.get_value(soundsection.name, sound.name)
		
	# updating display settings
	for display in displaysection.get_children():
		if display is HSlider:
			display.value = config.get_value(displaysection.name, display.name)
		elif display is OptionButton:
			display.selected = config.get_value(displaysection.name, display.name)
			
	# updating keybinds
	for keybind in keybindsection.get_children():
		if keybind is KeybindButton:
			var event = config.get_value(keybindsection.name,keybind.action)
			var action: String = keybind.action
			
			if event is InputEventKey:
				keybind.text = event.as_text_physical_keycode()
				
			elif event is InputEventMouseButton:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						keybind.text = "Left-Click"
					MOUSE_BUTTON_RIGHT:
						keybind.text = "Right-Click"
					MOUSE_BUTTON_MIDDLE:
						keybind.text = "Scroll-Button"
			
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)

func _on_accept_pressed() -> void:
	$ConfirmationDialog.popup_centered()

func _on_confirmed() -> void:
	### This will update/create the configuration file to keep changes
	var config: ConfigFile = ConfigFile.new()
	
	## Iterate through each settings section and write/update current values.
	for sound in $%Sounds.get_children():
		if sound is HSlider:
			config.set_value("Sounds", sound.name, sound.value)
	
	for display in $%Displays.get_children():
		if display is HSlider:
			config.set_value("Displays", display.name, display.value)
		elif display is OptionButton:
			config.set_value("Displays", display.name, display.selected)
	
	for keybind in $%KeyBindButtons.get_children():
		if keybind is Button:	# to make sure we cannot get non-buttons
			config.set_value("KeyBindButtons", keybind.name, InputMap.action_get_events(keybind.name)[0])
	
	config.save(configPath)

func _on_sound_value_changed(value: float, slider: VolumeHSlider) -> void:
	# play test sound
	testaudio.bus = BUSSES[slider.bus]
	testaudio.play()
	print("here")
