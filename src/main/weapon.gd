class_name Weapon
extends Node2D

enum State{SHEATH, DRAWN, ATTACK}

@export var speed = 100
@onready var sprite := $WeaponSprite
@onready var Hitbox = $Hitbox
@onready var specEnd = false
@onready var player = get_tree().get_first_node_in_group("Player")

var beam
var char_skill_path: String = "res://src/Skills/"

const SHEATH := State.SHEATH
const DRAWN := State.DRAWN
const ATTACK := State.ATTACK
const LASTFRAME = 5
const FULLYDRAWN = 2
var specSkill: Skill
const FLIP = Vector2(1,-1)
const RIGHT = Vector2(1,1)
var state: State = SHEATH:
	set(value):
		state_exits[state].call()
		state = value
		state_entries[state].call()
		#sprite.play()
var spec

## The function table that holds each state's "_init"/entry function.
var state_entries: Dictionary[State, Callable] = {}

## The function table that holds each state's "_process" function.
var state_inputs: Dictionary[State, Callable] = {}			

## The function table that holds each state's exit function.
var state_exits: Dictionary[State, Callable] = {}

var weapon_timer: Timer = Timer.new()

#var arrow = preload("res://character/arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_entries[SHEATH] = Callable(_sheath_entry)
	state_entries[DRAWN] = Callable(_drawn_entry)
	state_entries[ATTACK] = Callable(_attack_entry)
	
	state_inputs[SHEATH] = Callable(_sheath_input)
	state_inputs[DRAWN] = Callable(_drawn_input)
	state_inputs[ATTACK] = Callable(_attack_input)
	
	state_exits[SHEATH] = Callable(_sheath_exit)
	state_exits[DRAWN] = Callable(_drawn_exit)
	state_exits[ATTACK] = Callable(_attack_exit)
	
	state = 0
	spec = false
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

''' State Entry Functions'''
# To run once when state is entered.
func _sheath_entry() -> void:
	sprite.pause()
	$AnimationPlayer.stop()
	#sprite.visible = false
	pass
func _drawn_entry() -> void:
	pass
func _attack_entry() -> void:
	pass

''' State Process Functions'''
# To run every frame while in state.
func _sheath_input(_event: InputEvent = null) -> void:
	pass
func _drawn_input(_event: InputEvent = null) -> void:
	pass
func _attack_input(_event: InputEvent = null) -> void:
	pass

''' State Exit Functions'''
# To run once when the state is exited.
func _sheath_exit() -> void:
	
	$AnimationPlayer.play("attack")
	#sprite.visible = true
	pass
func _drawn_exit() -> void:
	pass
func _attack_exit() -> void:
	pass


func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
		var dis = Vector2.ZERO.distance_to(_event.relative)
		if (dis > 2 and !(get_tree().get_first_node_in_group("Engine").returnPause() or get_tree().get_first_node_in_group("Player").skillCheck)):
			var rotation_angle = Vector2.ZERO.angle_to_point(_event.relative)
			self.rotation = lerp_angle(self.rotation, rotation_angle + (PI/2),.1)
			if(rotation_angle < -(PI/2) or rotation_angle > (PI/2)):
				scale = Vector2(-1,1)

			else:
				scale = Vector2(1, 1)
	state_inputs[state].call(_event)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var new_node: Area2D
	if(get_tree().get_first_node_in_group("Engine").returnPause() == 0):
		var cursor_position = get_global_mouse_position()
		var rotation_angle = get_parent().global_position.angle_to_point(cursor_position)
		#### Animation Controls ####
		## Bow Attack ##
		if ((Input.is_action_just_pressed("BasicAttack") or Input.is_action_just_pressed("SpecialAttack")) and state == 0):
			if(Input.is_action_just_pressed("SpecialAttack")):
				spec = true
			state = 2
			print("BasicAttack")
			weapon_timer.start()
			#sprite.play("default")
		
func load_specSkill(skill_name: String) -> void:
	var scene = load(str(char_skill_path + skill_name + ".tscn"))
	print(scene)
	var loaded_skill: Node = scene.instantiate()
	call_deferred("add_child", loaded_skill)
	specSkill =  loaded_skill
	
func _on_weapon_timeout() -> void:
	if(state == 2):
		$Hitbox/Hitbox2.disabled = false
		state = 1
		weapon_timer.wait_time = .5
		weapon_timer.start()
		
		if(specEnd):
			if((specSkill != null )):
				specSkill.execute(player)
			specEnd = false
	elif(state == 1):
		$Hitbox/Hitbox2.disabled = true
		#sprite.play("default")
		weapon_timer.wait_time = .4
		sprite.stop()
		if(!spec):
			state = 0
			
		else:
			print("SpecialAttack")
			weapon_timer.start()
			#sprite.play("default")
			$AnimationPlayer.stop()
			$AnimationPlayer.play("attack")
			state = 1
			
			spec = false
			specEnd = true
	#pass # Replace with function body.
	
		
	#### Cursor Controls ####
