extends Control

var waiting: bool = false		# indicates whether we are waiting/accepting user input
var currentbutton: Button		# current button pressed
var buttonEventName: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for str in InputMap.get_actions():
		#print(str)
	# Iterate through buttons and connect the 'pressed' signal to a function
	for button in $%KeyBindButtons.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed(button) -> void:
	# A keybind button has been pressed.
	# Give indication like removing current string
	waiting = true				# now accepting input
	buttonEventName = button.text
	button.text = " "
	#$KeyBindButtons/Timer.start()
	currentbutton = button		# keeping track of button pressed
	print(button.name)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
	
func _input(event):	# an input was recieved
	if waiting:	# accepting user input
		## Check if event exists
		# checking if event already assigned to custom input
		for action in $%KeyBindButtons.get_children():
			if InputMap.action_has_event(action.name, event):
				# collision; cannot assign event to action
				currentbutton.text = buttonEventName
				waiting = false
				return
				
		## Check if action exists
		# if action exists; need to remove existing event before assigning new
		if InputMap.has_action(currentbutton.name):
			# remove event currently binded
			InputMap.action_erase_event(currentbutton.name, event)
		else:
			# This should not happen!!! Everything should be in InputMap!!
			InputMap.add_action(currentbutton.name)
		var key_event = InputEventKey.new()
		if event is InputEventKey:
			currentbutton.text = event.as_text_keycode()		# indicating key
			key_event.keycode = event.keycode
			#InputMap.action_add_event(currentbutton.name, key_event)
			waiting = false
		elif event is InputEventMouseButton:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					currentbutton.text = "Left-Click"
				MOUSE_BUTTON_RIGHT:
					currentbutton.text = "Right-Click"
				MOUSE_BUTTON_MIDDLE:
					currentbutton.text = "Scroll-Button"
			key_event.keycode = event.button_index
			waiting = false
			
		# add the event to the action
		InputMap.action_add_event(currentbutton.name, key_event)
		
		## Release focus on button
		currentbutton.release_focus()
