extends Node

@onready var paused = 0

@onready var pauseMenu = $Pause_Menu
@onready var chara = $Chara

var skill_tree_scene := preload("res://src/skill tree frontend 2026/skill tree.tscn")
var skill_tree_instance: Node = null

var hud_scene := preload("res://src/Player UI HUD for health and level/Player stat UI HEL HUD.tscn")
var hud_instance = null

func _ready() -> void:
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)

	hud_instance.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud_instance.position = Vector2.ZERO
	hud_instance.z_index = 100

	hud_instance.get_node("Control").hurtbox = $Chara/Hurtbox

	print("HUD instantiated: ", hud_instance)
	print("Assigned HUD hurtbox: ", hud_instance.get_node("Control").hurtbox)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pauseGame()

	if Input.is_action_just_pressed("SkillTree"):
		if skill_tree_instance == null:
			skill_tree_instance = skill_tree_scene.instantiate()
			add_child(skill_tree_instance)
			skill_tree_instance.player = $Chara
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			skill_tree_instance.queue_free()
			skill_tree_instance = null

	if Input.is_action_just_pressed("OffHandAction"):
		get_tree().get_first_node_in_group("Player").skill_points = 9999

func returnPause() -> int:
	return paused

func pauseGame():
	if paused:
		Engine.time_scale = 1
		pauseMenu.hide()
		paused = false
	else:
		Engine.time_scale = 0
		pauseMenu.show()
		$Pause_Menu/GraphFrame/MarginContainer/VBoxContainer/Resume.grab_focus()
		paused = true
