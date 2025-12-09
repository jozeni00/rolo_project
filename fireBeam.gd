extends Node2D

@export var speed = 200
@export var acceleration = 400
@export var radius = 200
@onready var sprite := $beamSprite

var direction
var initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var angle = get_tree().get_first_node_in_group("Player").weaponNode.rotation

	var degree = fposmod(angle, TAU)*(180/PI)
	self.rotation_degrees = (degree - 90)
	print(self.rotation_degrees)
	#direction = Vector2(-cos(self.rotation_degrees), sin(cos(self.rotation_degrees))).normalized()#(get_tree().get_first_node_in_group("Player").reticlePos - global_position).normalized()
	#direction = Vector2(1,1)
	direction = Vector2(get_tree().get_first_node_in_group("Player").reticle.global_position - global_position).normalized()
	initial_position = global_position
	$Timer.wait_time = 1
	$Timer.one_shot = true
	$Timer.start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var distance = initial_position.distance_to(global_position)
	
	#if (distance > radius):
		##$Timer.start(1)
	#else:
	speed += delta * acceleration
	self.position += direction * speed * delta
		

func _on_timer_timeout():
	queue_free()

func get_angle(angle: float) -> int:
	return 1


func _on_hitbox_hit() -> void:
	print("KAZAM")
	pass # Replace with function body.
