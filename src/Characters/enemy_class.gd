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

const EXP_REWARD := 50   # fixed EXP amount

@export var sprite: AnimatedSprite2D
@export var hurtbox: Hurtbox
@export var hitbox: Hitbox
@export var detect_area: Area2D
@export var detect_radius: float
@export var loot_table: Array[DropRate]

## The current state of the enemy. Whenever the state changes,
## the state's transition function will be called.
var state: State:
	set(value):
		state_exits[state].call()
		state = value
		state_entries[state].call()
		sprite.play()

## The function table that holds each state's "_init"/entry function.
var state_entries: Dictionary = {}

## The function table that holds each state's "_process" function.
var state_updates: Dictionary = {}			

## The function table that holds each state's exit function.
var state_exits: Dictionary = {}

var _spawn_location: Vector2 = global_position
var _walk_location: Vector2 = global_position
var _idle_timer: Timer = Timer.new()
var _aggro_timer: Timer = Timer.new()
var _hurt_timer: Timer = Timer.new()
var target: Player
var knockback_velocity: Vector2
var offset_amp: float = 100
var offset: Vector2 = Vector2(randf_range(-offset_amp,offset_amp), randf_range(-offset_amp,offset_amp))
var direction: Vector2:
	set(value):
		if sign(direction.x) != sign(value.x):
			offset = Vector2(randf_range(-offset_amp,offset_amp), randf_range(-offset_amp,offset_amp))
			if offset_amp > 20:
				offset_amp -= 20
		direction = value
		if direction.x < 0:
			sprite.scale = Vector2(-1,1)
		elif direction.x > 0:
			sprite.scale = Vector2(1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("enemy_class.gd is running.")
	assert(hurtbox, "No hurtbox assigned.")
	assert(hitbox, "No hitbox assigned.")
	assert(detect_area, "No detection area assigned.")
	assert(detect_radius, "No detection radius assigned.")
	
	var detect_shape: Shape2D = detect_area.get_child(0).shape
	detect_shape.radius = detect_radius
	
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
	
	_aggro_timer.one_shot = true
	_aggro_timer.wait_time = 2
	add_child(_aggro_timer)
	_aggro_timer.connect("timeout", Callable(self,"_on_aggro_timeout"))
	
	hurtbox.connect("got_hit", Callable(self, "_on_hurtbox_got_hit"))
	hurtbox.connect("dead", Callable(self, "_on_death"))
	
	_hurt_timer.one_shot = true
	_hurt_timer.wait_time = .5
	add_child(_hurt_timer)
	_hurt_timer.connect("timeout", Callable(self,"_on_hurt_timeout"))
	
	sprite.connect("animation_finished", Callable(self,"_on_animation_finished"))
	
	detect_area.area_entered.connect(_on_area_entered)
	
	state = IDLE
	sprite.play("idle")

# Called every frame.
func _process(delta: float) -> void:
	state_updates[state].call(delta)

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
	var distance: float = global_position.distance_to(target.global_position)
	if distance >= 15:
		sprite.animation = "walk"
		direction = global_position.direction_to(target.global_position + offset)
		global_position += direction * SPEED * _delta
	else:
		sprite.animation = "idle"

func _attack(_delta: float = 0.0167) -> void:
	if target:
		direction = global_position.direction_to(target.global_position)

func _hurt(_delta: float = 0.0167) -> void:
	var dir: Vector2 = -global_position.direction_to(target.global_position)
	dir *= target.weapon.stats.knockback + 1
	global_position += dir * SPEED/2 * _delta

func _death(_delta: float = 0.0167) -> void:
	pass

func _idle_entry() -> void:
	sprite.animation = "idle"
	_idle_timer.start(randf_range(1,3))
	
func _walk_entry() -> void:
	sprite.animation = "walk"
	_walk_location = Vector2(
		randf_range(-_WANDER_DISTANCE, _WANDER_DISTANCE) + _spawn_location.x,
		randf_range(-_WANDER_DISTANCE, _WANDER_DISTANCE) + _spawn_location.y)

func _chase_entry() -> void:
	sprite.animation = "walk"

func _attack_entry() -> void:
	print("Enemy is attacking!")

func _hurt_entry() -> void:
	print("OUCH")
	print(name, " Health: ", hurtbox.stats.Health)
	sprite.animation = "hurt"
	var collision: CollisionShape2D = hurtbox.get_child(0)
	collision.disabled = true

func _death_entry() -> void:
	# fixed EXP reward
	var hud = get_tree().get_first_node_in_group("hud")

	if hud != null and hud.has_method("add_exp"):
		print("EnemyClass giving EXP:", EXP_REWARD)
		hud.add_exp(EXP_REWARD)
	else:
		print("HUD not found")

	var collision: CollisionShape2D = hurtbox.get_child(0)
	collision.disabled = true
	sprite.animation = "death"
	sprite.play()

func _death_exit() -> void:
	queue_free()

func _idle_exit() -> void:
	_idle_timer.stop()

func _walk_exit() -> void:
	pass

func _chase_exit() -> void:
	pass

func _attack_exit() -> void:
	pass

func _hurt_exit() -> void:
	var collision: CollisionShape2D = hurtbox.get_child(0)
	collision.disabled = false

func _idle_timeout() -> void:
	state = WALK

func _on_area_entered(area: Area2D) -> void:
	if(area == get_tree().get_first_node_in_group("Player").hurtbox):
		target = area.get_parent()
		state = CHASE

func _on_hurt_timeout() -> void:
	if(state == DEATH):
		queue_free()
	else:
		state = IDLE

func _on_hurtbox_got_hit() -> void:
	state = HURT

func _on_death() -> void:
	state = DEATH
	_hurt_timer.start()

func _on_animation_finished() -> void:
	if sprite.get_animation() == "hurt":
		state = CHASE

	if sprite.get_animation() == "death":
		_death_exit()
