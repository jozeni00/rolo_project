class_name Player
extends Node2D

@export var weapon: Hitbox
@export var myInventory: Inventory

const LEFT = Vector2(-1, 1)
const RIGHT = Vector2(1, 1)

# Character attributes and level
var level: int = 1
var xp: int = 0
var skill_points: int = 0

var strength: int = 1
var element: int = 1
var fortitude: int = 1
var agility: int = 1
var tenacity: int = 1
var intellect: int = 1

# Attribute scaling values
const SPEED_PER_AGILITY := 10.0

# Base stats
@export var base_speed: float = 200.0
var speed: float = 200.0

# Movement and state
var velocity: Vector2 = Vector2.ZERO
var canDash: bool = true
var dshd: bool = false
var colliding: bool = false
var justLoaded

var reqDirection: Vector2 = Vector2.ZERO

var dash_timer: Timer = Timer.new()

var char_skill_path: String = "res://src/Skills/"
var dodge: Skill
var parry: Skill

@onready var skillCheck: bool = false

@onready var sprite := $charaSprite
@onready var hurtbox := $Hurtbox
@onready var collision: CollisionShape2D = hurtbox.get_child(0)


func _ready() -> void:
	sprite.play("idle")

	canDash = true
	dshd = false
	reqDirection = Vector2.ZERO
	colliding = false

	dash_timer.one_shot = true
	dash_timer.wait_time = 2
	add_child(dash_timer)
	dash_timer.connect("timeout", Callable(self, "_on_dash_timeout"))

	dodge = load_skill("dodge")
	parry = load_skill("parry")

	call_deferred("load_playerdata")

	sprite.animation_finished.connect(_on_animation_finished)

	_apply_attribute_effects()


func _process(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down")

	if not skillCheck:
		if Input.is_action_just_pressed("Dodge") and canDash:
			if dodge != null:
				dodge.execute(self, velocity)

		if not check_move():
			position += velocity * speed * delta

		if Input.is_action_just_released("Dodge") and dshd:
			pass

		if Input.is_action_just_pressed("OffHandAction"):
			if parry != null:
				parry.execute(self)

		if not get_parent().returnPause():
			if velocity.length() > 0:
				sprite.play("walk")

				if velocity.x < 0 and sprite.scale != LEFT:
					sprite.scale = LEFT
				elif velocity.x > 0 and sprite.scale == LEFT:
					sprite.scale = RIGHT
			else:
				sprite.play("idle")


func set_skill_tree_open(is_open: bool) -> void:
	skillCheck = is_open

	if skillCheck:
		sprite.pause()
	else:
		sprite.play()


func check_move() -> bool:
	if velocity != Vector2.ZERO and colliding:
		print((velocity[reqDirection[0]] / reqDirection[1]))

		if ((abs(velocity[reqDirection[0]]) >= abs(reqDirection[1])) and ((velocity[reqDirection[0]] / reqDirection[1]) > 0)):
			print("Good")
			reqDirection = Vector2.ZERO
			colliding = false
		else:
			velocity[reqDirection[0]] = 0

	return false


func load_skill(skill_name: String) -> Skill:
	var scene = load(str(char_skill_path + skill_name + ".tscn"))
	print(scene)

	if scene == null:
		push_warning("Could not load skill: " + skill_name)
		return null

	var loaded_skill: Node = scene.instantiate()
	call_deferred("add_child", loaded_skill)

	if loaded_skill is Skill:
		return loaded_skill

	return null


func addEXP(gain: int) -> void:
	xp += gain

	while xp >= 20:
		xp -= 20
		level += 1

		print("LEVEL UP: ", level)

		# Gives points to spend in the skill tree.
		skill_points += level

	print("Current skill points: ", skill_points)


func increase_attribute(stat_name: String, amount: int = 1) -> void:
	match stat_name:
		"Strength":
			strength += amount
		"Element":
			element += amount
		"Fortitude":
			fortitude += amount
		"Agility":
			agility += amount
		"Tenacity":
			tenacity += amount
		"Intellect":
			intellect += amount

	_apply_attribute_effects()
	save_playerdata()


func get_attribute(stat_name: String) -> int:
	match stat_name:
		"Strength":
			return strength
		"Element":
			return element
		"Fortitude":
			return fortitude
		"Agility":
			return agility
		"Tenacity":
			return tenacity
		"Intellect":
			return intellect

	return 0


func get_attribute_stats() -> Dictionary:
	return {
		"Strength": strength,
		"Element": element,
		"Fortitude": fortitude,
		"Agility": agility,
		"Tenacity": tenacity,
		"Intellect": intellect,
	}


func _apply_attribute_effects() -> void:
	# Agility increases movement speed.
	speed = base_speed + float(agility) * SPEED_PER_AGILITY

	# Do not overwrite weapon.stats.attack, cooldown, attack_duration, etc. here.
	# This keeps the existing enemy damage system working.

	print("Applied player attribute effects:")
	print("Agility:", agility, " Speed:", speed)

	if weapon != null and weapon.stats != null:
		print("Weapon attack currently:", weapon.stats.attack)
	else:
		print("Weapon or weapon.stats is null")


func load_playerdata() -> void:
	level = PlayerData.level
	xp = PlayerData.xp
	skill_points = PlayerData.skill_points

	strength = PlayerData.strength
	element = PlayerData.element
	fortitude = PlayerData.fortitude
	agility = PlayerData.agility
	tenacity = PlayerData.tenacity
	intellect = PlayerData.intellect

	if strength < 1:
		strength = 1

	if element < 1:
		element = 1

	if fortitude < 1:
		fortitude = 1

	if agility < 1:
		agility = 1

	if tenacity < 1:
		tenacity = 1

	if intellect < 1:
		intellect = 1

	_apply_attribute_effects()


func save_playerdata() -> void:
	PlayerData.level = level
	PlayerData.xp = xp
	PlayerData.skill_points = skill_points

	PlayerData.strength = strength
	PlayerData.element = element
	PlayerData.fortitude = fortitude
	PlayerData.agility = agility
	PlayerData.tenacity = tenacity
	PlayerData.intellect = intellect


func get_save_data() -> Dictionary:
	return {
		"position": [global_position.x, global_position.y],
		"health": hurtbox.stats.Health,
		"level": level,
		"xp": xp,
		"skill_points": skill_points,
		"strength": strength,
		"element": element,
		"fortitude": fortitude,
		"agility": agility,
		"tenacity": tenacity,
		"intellect": intellect,
	}


func apply_save_data(data: Dictionary) -> void:
	if data.has("position") and data["position"].size() == 2:
		global_position = Vector2(data["position"][0], data["position"][1])

	if data.has("health"):
		hurtbox.stats.Health = data["health"]

	if data.has("level"):
		level = int(data["level"])

	if data.has("xp"):
		xp = int(data["xp"])

	if data.has("skill_points"):
		skill_points = int(data["skill_points"])

	if data.has("strength"):
		strength = int(data["strength"])

	if data.has("element"):
		element = int(data["element"])

	if data.has("fortitude"):
		fortitude = int(data["fortitude"])

	if data.has("agility"):
		agility = int(data["agility"])

	if data.has("tenacity"):
		tenacity = int(data["tenacity"])

	if data.has("intellect"):
		intellect = int(data["intellect"])

	if strength < 1:
		strength = 1

	if element < 1:
		element = 1

	if fortitude < 1:
		fortitude = 1

	if agility < 1:
		agility = 1

	if tenacity < 1:
		tenacity = 1

	if intellect < 1:
		intellect = 1

	_apply_attribute_effects()
	save_playerdata()

	print("Player data applied:", data)


func _on_dash_timeout() -> void:
	canDash = true


func _on_animation_finished() -> void:
	if sprite.get_animation() == "dodge":
		sprite.animation = "idle"
		sprite.play()
