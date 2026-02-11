extends Node

enum Bus{MASTER, SOUNDEFFECT, MUSIC}
enum Element{NONE, AIR, WATER, EARTH, FIRE}
enum Stats{ATTACK, ELEMENTAL_ATTACK, CRIT_CHANCE, CRIT_MULTIPLIER, COOLDOWN, ATTACK_DURATION, KNOCKBACK}

const configPath: String = "user://settings.cfg"
const settings_menu: PackedScene = preload("uid://dy6aot16krxbq")
const BUS: Array[String] = ["Master", "SoundEffect", "Music"]
const RESOLUTIONS = [
		Vector2i(640, 360),
		Vector2i(1280, 720),
		Vector2i(1920, 1080)
	]

var bus: Array[String] = ["Master", "SoundEffect", "Music"]
var busIndex: Dictionary[String, int] = {
	"Master": 0, "SoundEffect": 1, "Music": 2
}

var master_volume: float
var soundeffect_volume: float
var music_volume: float
var brightness: float
var resolution: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load current settings configuration
	load_config()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_config() -> void:	
	var config: ConfigFile = ConfigFile.new()
	var err = config.load(configPath)
	
	if err != OK:
		return		# cannot load config file, NOP (ignore)
	
	# Get the sections in config and update current settings
	# updating sound settings
	master_volume = config.get_value("Sounds", "Master")
	AudioServer.set_bus_volume_db(Bus.MASTER, linear_to_db(master_volume))
	soundeffect_volume = config.get_value("Sounds", "SoundEffect")
	AudioServer.set_bus_volume_db(Bus.SOUNDEFFECT, linear_to_db(soundeffect_volume))
	music_volume = config.get_value("Sounds", "Music")
	AudioServer.set_bus_volume_db(Bus.MUSIC, linear_to_db(music_volume))
	

	## updating display settings
	brightness = config.get_value("Displays", "Brightness")
	resolution = config.get_value("Displays", "Resolution")
	DisplayServer.window_set_size(RESOLUTIONS[resolution])
	
	#for display in displaysection.get_children():
		#if display is HSlider:
			#display.value = config.get_value(displaysection.name, display.name)
		#elif display is OptionButton:
			#display.selected = config.get_value(displaysection.name, display.name)
			#
	## updating keybinds
	#for keybind in keybindsection.get_children():
		#if keybind is KeybindButton:
			#var event = config.get_value(keybindsection.name,keybind.action)
			#var action: String = keybind.action
			#
			#if event is InputEventKey:
				#keybind.text = event.as_text_physical_keycode()
				#
			#elif event is InputEventMouseButton:
				#match event.button_index:
					#MOUSE_BUTTON_LEFT:
						#keybind.text = "Left-Click"
					#MOUSE_BUTTON_RIGHT:
						#keybind.text = "Right-Click"
					#MOUSE_BUTTON_MIDDLE:
						#keybind.text = "Scroll-Button"
			#
			#InputMap.action_erase_events(action)
			#InputMap.action_add_event(action, event)
