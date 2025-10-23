extends Control

@onready var acceptbutton: Button = $%Accept
@onready var exitbutton: Button = $%Exit

const configPath: String = "user://settings.cfg"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Bind 'Accept' and 'Exit' buttons
	acceptbutton.pressed.connect(_on_accept_pressed.bind())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_accept_pressed() -> void:
	### This will update/create the configuration file to keep changes
	var config: ConfigFile = ConfigFile.new()
	
	## Iterate through each settings section and write/update current values.
	for sound in $ScrollContainer/VBoxContainer/Sounds.get_children():
		if sound is HSlider:
			config.set_value("Sounds", sound.name, sound.value)
	
	for display in $ScrollContainer/VBoxContainer/Displays.get_children():
		if display is HSlider:
			config.set_value("Displays", display.name, display.value)
		elif display is OptionButton:
			config.set_value("Displays", display.name, display.selected)
	
	for keybind in $ScrollContainer/VBoxContainer/Keybinds/KeyBindButtons.get_children():
		if keybind is KeybindButton:	# to make sure we cannot get non-buttons
			config.set_value("KeyBindButtons", keybind.action, InputMap.action_get_events(keybind.action)[0])
	
	config.save(configPath)
