class_name Weapon
extends Node2D

@export var speed = 100
@onready var sprite := $WeaponSprite
@onready var Hitbox = $Hitbox

const LASTFRAME = 5
const FULLYDRAWN = 2
const FLIP = Vector2(1,-1)
const RIGHT = Vector2(1,1)
var state

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
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#	sprite.play("default")
	#sprite.set_frame(0)
	#sprite.pause()
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var dis = Vector2.ZERO.distance_to(event.relative)
		if dis > 2:
			var rotation_angle = Vector2.ZERO.angle_to_point(event.relative)
			self.rotation = lerp_angle(rotation, rotation_angle + (PI/2),.1)
			if(rotation_angle < -(PI/2) or rotation_angle > (PI/2)):
				scale = Vector2(-1,1)

			else:
				scale = Vector2(1, 1)


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
			#sprite.play("default")
			$AnimationPlayer.play("attack")
		
	
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
