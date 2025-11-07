extends Area2D

const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)

@export var speed = 180
var velocity
var player
var state

@onready var sprite := $Area2D/enemSprite
@onready var timer := get_parent().get_child(1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(state == "aggro"):
		chase(player.position, delta)
		#velocity = 0
		position += velocity * delta
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
		print("I wish to demolish you")
		sprite.play("idle")
	pass
	
func chase(player, delta: float):
	if(speed < 180):
		speed += 1
	var direction = (player - global_position).normalized()
	velocity = direction * speed
	

func check_move() -> bool:
	# Check ahead for collision
	return true


func _on_detection_area_entered(area: Area2D) -> void:
	if area == player:
		print("IT BE THE PLAYER")
		state = "aggro"
	pass # Replace with function body.


func _on_detection_area_exited(area: Area2D) -> void:
	if area == player:
		print("Similarly edgy dialogue")
		#state = "idle"
		timer.start(2)
	pass # Replace with function body.




func _on_attack_area_entered(area: Area2D) -> void:
	if ((area == player)):
		print("ATTACK")
		state = "violence"
	pass # Replace with function body.
	
	


func _on_exit_attack_range(area: Area2D) -> void:
	if ((area == player)):
		print("GET BACK HERE")
		state = "aggro"
	pass # Replace with function body.


func _on_aggro_timer_timeout() -> void:
	print("Must've been the wind...")
	state = "idle"
	pass # Replace with function body.
