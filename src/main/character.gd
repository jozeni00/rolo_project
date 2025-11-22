class_name Player
extends Node2D

@export var myInventory : Inventory
const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)

@export var speed = 200
var velocity
var canDash
var dshd
var colliding
var justLoaded

var reqDirection

var dash_timer: Timer = Timer.new()

#@onready var state := $StateMachine
@onready var sprite:= $charaSprite
@onready var hurtbox:= $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")
	canDash = true
	dshd = false
	dash_timer.one_shot = true
	dash_timer.wait_time = 2
	add_child(dash_timer)
	dash_timer.connect("timeout", Callable(self,"_on_dash_timeout"))
	reqDirection = Vector2(0,0)
	colliding = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(global_position)
	velocity = Input.get_vector("Left", "Right", "Up", "Down")
	if(Input.is_action_just_pressed("Dodge") and canDash):
		speed *= 4
		dash_timer.start()
		dshd = true
	if(!check_move()):
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
	if(velocity != Vector2(0,0) and colliding):
		print((velocity[reqDirection[0]]) / (velocity[reqDirection[0]]))
		if ( ((velocity[reqDirection[0]])) == reqDirection[1]):
			print("Good")
			reqDirection = Vector2(0, 0)
			colliding = false
		else:
			velocity[reqDirection[0]] = 0
	return false
	
func get_save_data() -> Dictionary:
	return {
		"position": [global_position.x, global_position.y],
		"health": hurtbox.stats.Health
	}

func apply_save_data(data: Dictionary) -> void:
	if data.has("position") and data["position"].size() == 2:
		global_position = Vector2(data["position"][0], data["position"][1])
	if data.has("health"):
		hurtbox.stats.Health = data["health"]
	print("Player data applied:", data)

func _on_dash_timeout() -> void:
	canDash = true;
