extends Node2D

const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)

@export var speed = 200
var velocity
var canDash
var dshd

var dash_timer: Timer = Timer.new()

@onready var sprite := $charaSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	sprite.play("idle")
	canDash = true
	dshd = false
	dash_timer.one_shot = true
	dash_timer.wait_time = 2
	add_child(dash_timer)
	dash_timer.connect("timeout", Callable(self,"_on_dash_timeout"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down")
	if(Input.is_action_just_pressed("Dodge") and canDash):
		speed *= 4
		dash_timer.start()
		dshd = true
	
	position += velocity * speed * delta
	
	if(Input.is_action_just_released("Dodge") and dshd):
		speed /= 4
		canDash = false
		dshd = false
	
	if(get_parent().returnPause() == 0):
		if ((velocity.length() > 0)):
			sprite.play("walk")
		
			if(velocity[0] < 0 and sprite.scale != LEFT):# and self.get_child(2).cursor_position.x < self.position.x):
				
				sprite.scale = LEFT
			elif(velocity[0] > 0 and sprite.scale == LEFT):
				sprite.scale = RIGHT
			
		else:
			sprite.play("idle")
			#print("Nothin at all")

func check_move() -> bool:
	# Check ahead for collision
	return true
	

func _on_dash_timeout() -> void:
	canDash = true;
