extends Node2D

const configPath: String = "user://settings.cfg"

@onready var soundsection := $Settings/Panel/ScrollContainer/VBoxContainer/Sounds
@onready var displaysection := $Settings/Panel/ScrollContainer/VBoxContainer/Displays
@onready var keybindsection := $Settings/Panel/ScrollContainer/VBoxContainer/Keybinds/KeyBindButtons

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	### Load current settings configuration
	load_config()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("BasicAttack"):
		print("BasicAttack")
	if Input.is_action_pressed("Dodge"):
		print("Dodge")
	if Input.is_action_pressed("Down"):
		print("Down")
	if Input.is_action_pressed("Interact"):
		print("Interact")
	if Input.is_action_pressed("Inventory"):
		print("Inventory")
	if Input.is_action_pressed("Left"):
		print("left")
	if Input.is_action_pressed("OffHandAction"):
		print("OffHandAction")
	if Input.is_action_pressed("Pause"):
		print("Pause")
	if Input.is_action_pressed("Right"):
		print("Right")
	if Input.is_action_pressed("SkillTree"):
		print("SkillTree")
	if Input.is_action_pressed("Up"):
		print("Up")

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
