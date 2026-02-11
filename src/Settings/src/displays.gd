extends Control

@onready var resolution_option = $Display/DisplayControls/OptionButton
@onready var brightness_overlay = get_node("BrightnessOverlay")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Brightness Control
func _on_brightness_value_changed(value: float) -> void:
	if brightness_overlay:
		# 0 = darkest (black opaque), 100 = brightest (fully transparent)
		brightness_overlay.modulate = Color(0, 0, 0, (100.0 - value) / 100.0)
	print("Brightness set to:", value)


func _on_resolution_item_selected(index: int) -> void:
	print("here")
	var resolutions = [
		Vector2i(640, 360),
		Vector2i(1280, 720),
		Vector2i(1920, 1080)
	]
	DisplayServer.window_set_size(resolutions[index])
	print("Resolution changed to:", resolutions[index])
