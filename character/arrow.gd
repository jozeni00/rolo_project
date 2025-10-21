extends Area2D

@export var speed = 200
@export var acceleration = 800
@export var radius = 200
@onready var sprite := $ArrowSprite

var direction
var initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")
	sprite.pause()
	
	var cursor_pos = get_global_mouse_position()
	var center = global_position
	var angle = center.angle_to_point(cursor_pos)
	var degree = fposmod(angle, TAU)*(180/PI)
	var degree_index = round(degree/22.5)
	
	#sprite.set_frame(degree_index)
	self.rotation_degrees = degree
	direction = (cursor_pos - center).normalized()
	initial_position = global_position
	$Timer.wait_time = 1
	$Timer.one_shot = true
	$Timer.start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance = initial_position.distance_to(global_position)
	
	#if (distance > radius):
		##$Timer.start(1)
	#else:
	speed += delta * acceleration
	self.position += direction * speed * delta
		

func _on_timer_timeout():
	queue_free()

func get_angle(angle: float) -> int:
	return 1
