extends Area2D

const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)

@export var speed = 200
var velocity

@onready var sprite := $charaSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down")
	
	position += velocity * speed * delta
	if(get_parent().returnPause() == 0):
		if ((velocity.length() > 0)):
			sprite.play("walk")
		
			if(velocity[0] < 0 and self.scale != LEFT):# and self.get_child(2).cursor_position.x < self.position.x):
				
				self.scale = LEFT
			elif(velocity[0] > 0 and self.scale == LEFT):
				self.scale = RIGHT
			
		else:
			sprite.play("idle")
			#print("Nothin at all")

func check_move() -> bool:
	# Check ahead for collision
	return true
