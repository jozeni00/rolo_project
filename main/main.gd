extends Node

@onready var paused = 0

@export var screensize = Vector2i(720,480)

#@onready var pause_Menu = $pauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().size = screensize


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
		#pause_Menu.hide()
		print("Unpaused")
		paused = false
	else:
		Engine.time_scale = 0
		print("Paused")	
		#pause_Menu.show()
		paused = true
