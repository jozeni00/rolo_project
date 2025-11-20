extends Node2D

@export var speed = 100
@onready var sprite := $WeaponSprite
@onready var Hitbox = $Hitbox

const LASTFRAME = 5
const FULLYDRAWN = 2
const FLIP = Vector2(1,-1)
const RIGHT = Vector2(1,1)
var state;

var weapon_timer: Timer = Timer.new()

#var arrow = preload("res://character/arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = 0;
	$Hitbox/Hitbox2.disabled = true
	global_position = get_parent().get_position()
	
	weapon_timer.one_shot = true
	weapon_timer.wait_time = .4
	add_child(weapon_timer)
	weapon_timer.connect("timeout", Callable(self,"_on_weapon_timeout"))
#	sprite.play("default")
	#sprite.set_frame(0)
	#sprite.pause()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var new_node: Area2D
	if(get_tree().get_first_node_in_group("Engine").returnPause() == 0):
		var cursor_position = get_global_mouse_position()
		var rotation_angle = get_parent().global_position.angle_to_point(cursor_position)
		#### Animation Controls ####
		## Bow Attack ##
		if (Input.is_action_just_pressed("BasicAttack") and state == 0):
			state = 1
			print("BasicAttack")
			weapon_timer.start()
			sprite.play("default")
		
			

		
		## Direction ##
		
		self.rotation = rotation_angle + (PI/2)
		if(rotation_angle < -(PI/2) or rotation_angle > (PI/2)):
			sprite.scale = Vector2(-1,1)
		else:
			sprite.scale = Vector2(1, 1)
	
	#print(self.rotation)
	#self.scale = FLIP
	#print("\n")
	#if(self.get_parent().scale == LEFT):
			#rotation_angle = rotation_angle * -1
		#self.scale = LEFT
		
		#self.rotation = -self.rotation
	#else: #if(self.get_parent().scale == RIGHT):
		#self.scale = RIGHT
	
func _on_weapon_timeout() -> void:
	if(state == 1):
		$Hitbox/Hitbox2.disabled = false
		state = 2
		weapon_timer.wait_time = .5
		weapon_timer.start()
	elif(state == 2):
		$Hitbox/Hitbox2.disabled = true
		sprite.play("default")
		weapon_timer.wait_time = .4
		sprite.stop()
		
		state = 0
	#pass # Replace with function body.
	
		
	#### Cursor Controls ####
