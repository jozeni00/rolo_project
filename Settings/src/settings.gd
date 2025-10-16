extends Control

var busy = false
var waiting = false		# indicates whether we are waiting/accepting user input
var placeholder = ""
var currentbutton

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
		
		
