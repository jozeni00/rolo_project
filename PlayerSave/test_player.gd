extends CharacterBody2D

var speed := 200
var health := 100
var xp := 0

func _physics_process(delta):
	var dir := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1

	if dir != Vector2.ZERO:
		dir = dir.normalized()
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func get_save_data() -> Dictionary:
	return {
		"position": [global_position.x, global_position.y],
		"health": health,
		"xp": xp
	}

func apply_save_data(data: Dictionary) -> void:
	if data.has("position") and data["position"].size() == 2:
		global_position = Vector2(data["position"][0], data["position"][1])
	if data.has("health"):
		health = data["health"]
	if data.has("xp"):
		xp = data["xp"]
	print("✅ Player data applied:", data)
