extends Node2D

@export var speed = 100
@onready var sprite := $WeaponSprite2
@onready var Hitbox = $Hitbox

const LASTFRAME = 5
const FULLYDRAWN = 2
const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)

#var arrow = preload("res://character/arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = get_parent().get_position()
#	sprite.play("default")
	#sprite.set_frame(0)
	#sprite.pause()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var new_node: Area2D
	var cursor_position = get_global_mouse_position()
	var rotation_angle = global_position.angle_to_point(cursor_position)
	#### Animation Controls ####
	## Bow Attack ##
	if Input.is_action_just_pressed("BasicAttack"):
		print("BasicAttack")
		$Hitbox/Hitbox2.disabled = false
	
		

	
	## Bow Direction ##
	
	
	self.rotation = rotation_angle
	if(self.get_parent().scale == LEFT):
			#rotation_angle = rotation_angle * -1
		self.scale = LEFT
		
		self.rotation = -self.rotation
	else: #if(self.get_parent().scale == RIGHT):
		self.scale = RIGHT
	
	
		
	#### Cursor Controls ####
