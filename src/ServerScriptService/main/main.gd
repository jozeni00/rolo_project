extends Node

var paused: bool = false

@onready var pauseMenu = $Pause_Menu
@onready var chara = $Chara

var skill_tree_scene := preload("res://src/StarterGui/skill tree frontend 2026/skill treee.tscn")
var skill_tree_instance: Node = null

var hud_scene := preload("res://src/StarterGui/Player UI HUD for health and level/Player stat UI HEL HUD.tscn")
var hud_instance: Node = null
var hud_control: Control = null


func _ready() -> void:
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)

	hud_control = hud_instance.get_node("Control")

	hud_control.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud_control.position = Vector2.ZERO
	hud_control.z_index = 10
	hud_control.mouse_filter = Control.MOUSE_FILTER_IGNORE

	hud_control.hurtbox = $Chara/Hurtbox
	hud_control.add_to_group("hud")

	move_child(pauseMenu, get_child_count() - 1)

	if pauseMenu is CanvasItem:
		pauseMenu.z_index = 1000

	pauseMenu.hide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pauseGame()

	if Input.is_action_just_pressed("SkillTree"):
		toggle_skill_tree()


func toggle_skill_tree() -> void:
	if skill_tree_instance == null:
		skill_tree_instance = skill_tree_scene.instantiate()
		add_child(skill_tree_instance)

		skill_tree_instance.player = $Chara

		if hud_control != null and hud_control.has_signal("attribute_points_changed"):
			if not hud_control.attribute_points_changed.is_connected(skill_tree_instance.refresh_attribute_points):
				hud_control.attribute_points_changed.connect(skill_tree_instance.refresh_attribute_points)

		# Force refresh when skill tree opens
		if skill_tree_instance.has_method("refresh_attribute_points"):
			skill_tree_instance.refresh_attribute_points()

		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		if hud_control != null:
			hud_control.hide()

		pauseMenu.hide()
		paused = false
		Engine.time_scale = 1

	else:
		skill_tree_instance.queue_free()
		skill_tree_instance = null

		if hud_control != null:
			hud_control.show()


func returnPause() -> int:
	return int(paused)


func pauseGame() -> void:
	if paused:
		Engine.time_scale = 1
		pauseMenu.hide()
		paused = false

		if hud_control != null and skill_tree_instance == null:
			hud_control.show()

	else:
		Engine.time_scale = 0
		pauseMenu.show()

		if hud_control != null:
			hud_control.hide()

		move_child(pauseMenu, get_child_count() - 1)

		if pauseMenu is CanvasItem:
			pauseMenu.z_index = 1000

		$Pause_Menu/GraphFrame/MarginContainer/VBoxContainer/Resume.grab_focus()
		paused = true
