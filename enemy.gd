extends Area2D

const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)

@export var speed = 180
var velocity
var player
@export var rad = 40

@onready var sprite := $enemSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pDist = (player.position[0]^2)
	
	chase(player.position, delta)
	#velocity = 0
	position += velocity * delta
	if ((velocity.length() > 0)):
		sprite.play("walk")
	
		if(velocity[0] < 0 and self.scale != LEFT):# and self.get_child(2).cursor_position.x < self.position.x):
			
			self.scale = LEFT
		elif(velocity[0] > 0 and self.scale == LEFT):
			self.scale = RIGHT
		
	else:
		sprite.play("idle")
		#print("Nothin at all")
	pass
	
func chase(player, delta: float):
	var direction = (player - global_position).normalized()
	velocity = direction * speed
	

func check_move() -> bool:
	# Check ahead for collision
	return true
