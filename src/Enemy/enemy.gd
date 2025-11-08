extends Area2D

const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)

@export var speed = 180
var velocity
var direction: Vector2
var player: Node2D
var state
var aggro_timer: Timer = Timer.new()

@onready var sprite := $enemSprite
#@onready var timer := $AggroTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	sprite.play("idle")
	aggro_timer.one_shot = true
	aggro_timer.wait_time = 2
	add_child(aggro_timer)
	aggro_timer.connect("timeout", Callable(self,"_on_aggro_timeout"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Vector2.ZERO
	if(state == "aggro" or state == "chasing"):
		chase(player, delta)
		#velocity = 0
		##position += velocity * delta
		if ((velocity.length() > 0)):
			sprite.play("walk")
		
			if(velocity[0] < 0 and self.scale != LEFT):# and self.get_child(2).cursor_position.x < self.position.x):
				
				self.scale = LEFT
			elif(velocity[0] > 0 and self.scale == LEFT):
				self.scale = RIGHT
			
	elif (state == "idle"):
		speed = 40
		sprite.play("idle")
			#print("Nothin at all")
	elif (state == "violence"):
		if(speed < 180):
			speed += 1
		#print("I wish to demolish you")
		sprite.play("idle")
	#pass
	
func chase(player, delta: float):
	if(speed < 180):
		speed += 1
	direction = global_position.direction_to(player.global_position)
	#direction =direction.normalized()
	"""if(state == "chasing"):
		speed *= 4"""
	#print(direction)
	global_position += direction * speed * delta
	velocity = direction * speed
	"""if(state == "chasing"):
		speed /= 4
		state = "aggro" """


func _on_detection_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		#print("IT BE THE PLAYER")
		state = "aggro"
		aggro_timer.stop()
	#pass # Replace with function body.


func _on_detection_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		#print("YOU CANNOT ESCAPE")
		state = "chasing"
		aggro_timer.start()
	#pass # Replace with function body.




func _on_attack_area_entered(area: Area2D) -> void:
	if ((area.get_parent().is_in_group("Player"))):
		#print("ATTACK")
		state = "violence"
	#pass # Replace with function body.
	
	


func _on_exit_attack_range(area: Area2D) -> void:
	if ((area.get_parent().is_in_group("Player"))):
		#print("GET BACK HERE")
		state = "aggro"
		#timer.stop()
	#pass # Replace with function body.


func _on_aggro_timeout() -> void:
	#print("Must've been the wind...")
	state = "idle"
	#pass # Replace with function body.
