extends Node

@onready var paused = 0

#@export var screensize = Vector2i(720,480)

@onready var pauseMenu = $Pause_Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#self.get_child(2).get_child(0).player = self.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		#print("This should be pausing rn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pauseGame()
	if(Input.is_action_just_pressed("SkillTree")):
		if($skillTree.visible):
			$skillTree.hide()
		else:
			$skillTree.show()
	if(Input.is_action_just_pressed("OffHandAction")):
		get_tree().get_first_node_in_group("Player").skill_points = 9999
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
