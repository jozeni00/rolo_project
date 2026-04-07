extends HSlider
class_name VolumeHSlider

enum BusIndex {Master, SoundEffect, Music}

@export var bus: BusIndex = BusIndex.Master

func _init() -> void:
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Set default values
	min_value = 0
	max_value = 1
	step = 0.001
	value = 100
	
	# Connecting value changes to handle function
	value_changed.connect(_on_value_changed)
	# update value to be current 
	value = db_to_linear(bus)


func _on_value_changed(value: float) -> void:
	## Update whenever slider updates
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
