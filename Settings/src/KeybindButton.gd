"""
This button is used to remap keybinds. When the button is pressed it will
change the button text to "..." to indicate it is waiting for input.
When an input is recieved, it will update the text, erease current event
attached to action and add the new event.
"""

extends Button
class_name KeybindButton

@export var action: String

func _init() -> void:
	toggle_mode = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _toggled(toggled_on: bool) -> void:
	# allow node to process input if on
	set_process_input(toggled_on)
	if button_pressed:
		text = "..."
		disable_nonactive_buttons(self)

func _input(event) -> void:
	# ignore mouse motions
	if event is InputEventMouseMotion:
		return
	
	## Keybind buttons can accept keys or mouse buttons as new inputs
	# only take action if the button has been pressed (ignore all other inputs)
	if button_pressed:
		# checking if event already assigned to custom input
		for buttons in $%KeyBindButtons.get_children(): 
			if InputMap.action_has_event(buttons.action, event):
				# collision; cannot assign event to action
				# put previous text on button
				var current_event = InputMap.action_get_events(action)[0]
				if current_event is InputEventKey:
					text = current_event.as_text_physical_keycode()
				elif current_event is InputEventMouseButton:
					var index: int = current_event.button_index
					set_text_mouse_events(index)
				
				release()
				return
		
		# update text, remove current event from action and then update
		if event is InputEventKey:
			var key_event: InputEventKey = event
			
			text = event.as_text_physical_keycode()
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, key_event)
		elif event is InputEventMouseButton:
			var mouse_event: InputEventMouseButton = event
			
			set_text_mouse_events(event.button_index)
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, mouse_event)
			
		release()

func enable_buttons() -> void:
	## Enable all buttons.
	for button in get_parent().get_children():
		button.disabled = false

func disable_nonactive_buttons(activebutton: KeybindButton) -> void:
	## Disable all non-active buttons.
	for button in get_parent().get_children():
		if button != activebutton:
			button.disabled = true

func release() -> void:
	# toggle off button then stop input propagation
	button_pressed = false
	release_focus()
	enable_buttons()
	get_viewport().set_input_as_handled()

func set_text_mouse_events(index: int) -> void:
	match index:
		MOUSE_BUTTON_LEFT:
			text = "Left-Click"
		MOUSE_BUTTON_RIGHT:
			text = "Right-Click"
		MOUSE_BUTTON_MIDDLE:
			text = "Mouse-Scroll-Click"
