extends Control

@onready var acceptbutton: Button = $%Accept
@onready var exitbutton: Button = $%Exit
@onready var testaudio: AudioStreamPlayer2D = $Panel/ScrollContainer/VBoxContainer/Sounds/testbeep
@onready var sounds: ReferenceRect = $%Sounds

const configPath: String = "user://settings.cfg"
const BUSSES = ["Master", "SoundEffect", "Music"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Bind 'Accept' and 'Exit' buttons
	acceptbutton.pressed.connect(_on_accept_pressed)
	for sound in sounds.get_children():
		if sound is VolumeHSlider:
			sound.drag_ended.connect(_on_sound_value_changed.bind(sound))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_accept_pressed() -> void:
	$ConfirmationDialog.popup_centered()
	### This will update/create the configuration file to keep changes
	var config: ConfigFile = ConfigFile.new()
	var file: FileAccess = FileAccess.new.call()
	
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
