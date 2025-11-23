class_name Enemy
extends Node2D

enum State{
	## State when enemy is standing still.
	IDLE,
	## State when the enemy is randomly walking around.
	WALK,
	## State when the enemy is pursuing the player.
	CHASE,
	## State when the enemy is currently performing an attack.
	ATTACK,
	## State when the enemy is attacked.
	HURT,
	## State when the enemy's health reaches 0.
	DEATH
	}

const LOOT = preload("res://src/Inventory/loot.tscn")

const IDLE := State.IDLE
const WALK := State.WALK
const CHASE := State.CHASE
const ATTACK := State.ATTACK
const HURT := State.HURT
const DEATH := State.DEATH

const SPEED: int = 100
const _WANDER_DISTANCE: float = 50

@export var sprite: AnimatedSprite2D
@export var hurtbox: Hurtbox
@export var hitbox: Hitbox
@export var detect_area: Area2D
@export var detect_radius: float
@export var loot_table: Array[DropRate]
@export_range(0,10,1, "suffix:xp") var exp: int = 0

## The current state of the enemy. Whenever the state changes,
## the state's transition function will be called.
var state: State:
	set(value):
		state_exits[state].call()
		state = value
		state_entries[state].call()

## The function table that holds each state's "_init"/entry function.
var state_entries: Dictionary = {}

## The function table that holds each state's "_process" function.
var state_updates: Dictionary = {}			

## The function table that holds each state's exit function.
var state_exits: Dictionary = {}

var _spawn_location: Vector2 = global_position
var _walk_location: Vector2 = global_position
var _idle_timer: Timer = Timer.new()
var target: Node2D
var direction: Vector2:
	set(value):
		direction = value
		if direction.x < 0:
			sprite.scale = Vector2(-1,1)
		elif direction.x > 0:
			sprite.scale = Vector2(1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(hurtbox, "No hurtbox assigned.")
	assert(hitbox, "No hitbox assigned.")
	assert(detect_area, "No detection area assigned.")
	assert(detect_radius, "No detection radius assigned.")
	
	state_entries[IDLE] = Callable(self, "_idle_entry")
	state_entries[WALK] = Callable(self, "_walk_entry")
	state_entries[CHASE] = Callable(self, "_chase_entry")
	state_entries[ATTACK] = Callable(self, "_attack_entry")
	state_entries[HURT] = Callable(self, "_hurt_entry")
	state_entries[DEATH] = Callable(self, "_death_entry")
	
	state_updates[IDLE] = Callable(self, "_idle")
	state_updates[WALK] = Callable(self, "_walk")
	state_updates[CHASE] = Callable(self, "_chase")
	state_updates[ATTACK] = Callable(self, "_attack")
	state_updates[HURT] = Callable(self, "_hurt")
	state_updates[DEATH] = Callable(self, "_death")
	
	state_exits[IDLE] = Callable(self, "_idle_exit")
	state_exits[WALK] = Callable(self, "_walk_exit")
	state_exits[CHASE] = Callable(self, "_chase_exit")
	state_exits[ATTACK] = Callable(self, "_attack_exit")
	state_exits[HURT] = Callable(self, "_hurt_exit")
	state_exits[DEATH] = Callable(self, "_death_exit")
	
	_idle_timer.one_shot = true
	_idle_timer.wait_time = randf_range(1,3)
	add_child(_idle_timer)
	_idle_timer.connect("timeout", Callable(self, "_idle_timeout"))
	
	hurtbox.area_entered.connect(_on_area_entered)
	
	state = IDLE
	sprite.play("idle")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state_updates[state].call(delta)

# State update function.
func _idle(_delta: float = 0.0167) -> void:
	pass
	
func _walk(_delta: float = 0.0167) -> void:
	var distance: float = global_position.distance_to(_walk_location)
	if distance < 5:
		state = IDLE
	else:
		direction = global_position.direction_to(_walk_location)
		global_position += direction * SPEED * _delta

func _chase(_delta: float = 0.0167) -> void:
	direction = global_position.direction_to(target.global_position)
	global_position+= direction * SPEED * _delta

func _attack(_delta: float = 0.0167) -> void:
	pass

func _hurt(_delta: float = 0.0167) -> void:
	pass

func _death(_delta: float = 0.0167) -> void:
	pass

# State entry function.
func _idle_entry() -> void:
	sprite.animation = "idle"
	_idle_timer.start(randf_range(1,3))
	
func _walk_entry() -> void:
	sprite.animation = "walk"
	_walk_location = Vector2(
		randf_range(-_WANDER_DISTANCE, _WANDER_DISTANCE) + _spawn_location.x,
		randf_range(-_WANDER_DISTANCE, _WANDER_DISTANCE) + _spawn_location.y)
	print("Walk Location: ", _walk_location)

func _chase_entry() -> void:
	sprite.animation = "walk"

func _attack_entry() -> void:
	pass

func _hurt_entry() -> void:
	pass

func _death_entry() -> void:
	pass

# State exit function.
func _idle_exit() -> void:
	_idle_timer.stop()
	
func _walk_exit() -> void:
	pass

func _chase_exit() -> void:
	pass

func _attack_exit() -> void:
	pass

func _hurt_exit() -> void:
	pass

func _death_exit() -> void:
	pass


func _idle_timeout() -> void:
	state = WALK

func _on_area_entered(area: Area2D) -> void:
	target = area.get_parent()
	state = CHASE
