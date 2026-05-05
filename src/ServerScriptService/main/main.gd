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
	Engine.time_scale = 1
	paused = false

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
		if skill_tree_instance != null:
			close_skill_tree()
		else:
			pauseGame()

	if Input.is_action_just_pressed("SkillTree"):
		if skill_tree_instance == null:
			open_skill_tree()
		else:
			close_skill_tree()


func open_skill_tree() -> void:
	Engine.time_scale = 1
	paused = false
	pauseMenu.hide()

	if $Chara.has_method("set_skill_tree_open"):
		$Chara.set_skill_tree_open(true)

	skill_tree_instance = skill_tree_scene.instantiate()
	add_child(skill_tree_instance)

	skill_tree_instance.player = $Chara

	if hud_control != null:
		if hud_control.has_signal("attribute_points_changed"):
			if skill_tree_instance.has_method("refresh_attribute_points"):
				if not hud_control.attribute_points_changed.is_connected(skill_tree_instance.refresh_attribute_points):
					hud_control.attribute_points_changed.connect(skill_tree_instance.refresh_attribute_points)

		hud_control.hide()

	if skill_tree_instance.has_method("refresh_attribute_points"):
		skill_tree_instance.refresh_attribute_points()

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func close_skill_tree() -> void:
	if skill_tree_instance != null:
		if skill_tree_instance.has_method("save_before_close"):
			skill_tree_instance.save_before_close()

		if hud_control != null:
			if hud_control.has_signal("attribute_points_changed"):
				if skill_tree_instance.has_method("refresh_attribute_points"):
					if hud_control.attribute_points_changed.is_connected(skill_tree_instance.refresh_attribute_points):
						hud_control.attribute_points_changed.disconnect(skill_tree_instance.refresh_attribute_points)

		skill_tree_instance.queue_free()
		skill_tree_instance = null

	if $Chara.has_method("set_skill_tree_open"):
		$Chara.set_skill_tree_open(false)

	if hud_control != null:
		hud_control.show()

	pauseMenu.hide()
	paused = false
	Engine.time_scale = 1
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func close_pause_menu() -> void:
	Engine.time_scale = 1
	pauseMenu.hide()
	paused = false

	if hud_control != null and skill_tree_instance == null:
		hud_control.show()

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func returnPause() -> int:
	return int(paused)


func pauseGame() -> void:
	if paused:
		close_pause_menu()
	else:
		if skill_tree_instance != null:
			close_skill_tree()

		Engine.time_scale = 0
		pauseMenu.show()
		paused = true

		if hud_control != null:
			hud_control.hide()

		move_child(pauseMenu, get_child_count() - 1)

		if pauseMenu is CanvasItem:
			pauseMenu.z_index = 1000

		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		$Pause_Menu/GraphFrame/MarginContainer/VBoxContainer/Resume.grab_focus()
