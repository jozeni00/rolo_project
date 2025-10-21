extends Node2D

@export var speed = 100
@onready var sprite := $BowSprites

const LASTFRAME = 5
const FULLYDRAWN = 2
const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)

var arrow = preload("res://character/arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")
	sprite.set_frame(0)
	sprite.pause()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_node: Area2D
	var cursor_position = get_global_mouse_position()
	var rotation_angle = global_position.angle_to_point(cursor_position)
	#### Animation Controls ####
	## Bow Attack ##
	if Input.is_action_just_pressed("BasicAttack"):
		sprite.play("idle")
		self.get_parent().speed = 100
	elif Input.is_action_just_released("BasicAttack"):
		sprite.set_frame(FULLYDRAWN+1)
		sprite.play()
		new_node = arrow.instantiate()
		new_node.global_position = global_position
		get_tree().get_root().add_child(new_node)
		self.get_parent().speed = 200
		
	if Input.is_action_pressed("BasicAttack"):
		if sprite.frame == FULLYDRAWN:
			sprite.pause()
			
	if sprite.frame == LASTFRAME:
		sprite.set_frame(0)
		sprite.pause()
	
	## Bow Direction ##
	
	#if (cursor_position.x > self.get_parent().position.x) and (self.get_parent().scale == LEFT):
		#self.scale = LEFT
		#print("They're facing LEFT")
		#self.get_parent().get_child(0).scale = RIGHT
	#elif (cursor_position.x < self.get_parent().position.x) and (self.get_parent().scale == RIGHT):
		#self.scale = RIGHT
		#print("They're facing RIGHT")
		#self.get_parent().get_child(0).scale = LEFT
		
	#print(self.get_parent().scale)
	#if self.scale.x == -1:
		#cursor_direction = global_position.angle_to_point(cursor_position) + PI
	self.rotation = rotation_angle
	if(self.get_parent().scale == LEFT):
			#rotation_angle = rotation_angle * -1
		self.scale = LEFT
		self.rotation = -self.rotation
	else: #if(self.get_parent().scale == RIGHT):
		self.scale = RIGHT
	
	
		
	#### Cursor Controls ####
