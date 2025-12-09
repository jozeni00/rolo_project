extends Node2D

@export var radius: float = 30
@onready var sprite: Sprite2D = $Sprite2D

var timer: Timer = Timer.new()

var direction: Vector2:
	set(value):
		direction = value
		visible = true
		timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
	timer.one_shot = true
	timer.wait_time = 1
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timeout"))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var dis = Vector2.ZERO.distance_to(event.relative)
		if (dis > 2 and !(get_tree().get_first_node_in_group("Engine").returnPause() or get_tree().get_first_node_in_group("Player").skillCheck)):
			direction = event.relative.normalized()
			var center: Vector2 = get_parent().global_position
			var new_position = center + direction * radius
			global_position.x = lerpf(global_position.x, new_position.x,.1)
			global_position.y = lerpf(global_position.y, new_position.y,.1)

func _on_timeout() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#var center: Vector2 = get_parent().global_position
	#var cursor_position: Vector2 = get_global_mouse_position()
	#var distance_to_center: float = center.distance_to(cursor_position)
	#
	#global_position = cursor_position
	#
	#if distance_to_center > radius:
		#var direction: Vector2 = center.direction_to(cursor_position)
		#global_position = center + direction * radius
