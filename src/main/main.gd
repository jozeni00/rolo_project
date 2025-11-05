extends Node

@onready var paused = 0

@export var screensize = Vector2i(720,480)

@onready var pauseMenu = $Pause_Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().size = screensize
	self.get_child(2).get_child(0).player = self.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		#print("This should be pausing rn")
		pauseGame()
	#pass
	
func returnPause() -> int:	
	return paused
func pauseGame():
	if(paused):
		Engine.time_scale = 1
		pauseMenu.hide()
		#print("Unpaused")
		paused = false
	else:
		Engine.time_scale = 0
		#print("Paused")	
		pauseMenu.show()
		$Pause_Menu/GraphFrame/MarginContainer/VBoxContainer/Resume.grab_focus()
		paused = true
