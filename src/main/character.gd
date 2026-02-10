class_name Player
extends Node2D

@export var weapon: Hitbox
@export var myInventory : Inventory
const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)
@onready var weaponNode = $Weapon

@onready var reticle = $Reticle

signal stats_changed


''' Character Attributes/Level '''
var level: int
var xp: int
var skill_points: int

var strength: int :
	set(value):
		strength = value
		weapon.stats.attack += strength
var element: int:
	set(value):
		element = value
		weapon.stats.elemental_attack += element
var fortitude: int
var agility: int:
	set(value):
		agility = value
		speed *= 1 + (agility * 0.02)
var tenacity: int:
	set(value):
		tenacity = value
		weapon.stats.attack_duration *= 1 + (tenacity * 0.05)
var intellect: int:
	set(value):
		intellect = value
		weapon.stats.cooldown *= 1 + (intellect * 0.02)

''' Attribute System '''
func spend_point(attribute: String) -> bool:
	if skill_points <= 0:
		return false

	match attribute:
		"strength":
			strength += 1
		"element":
			element += 1
		"fortitude":
			fortitude += 1
		"agility":
			agility += 1
		"tenacity":
			tenacity += 1
		"intellect":
			intellect += 1

	skill_points -= 1
	stats_changed.emit()
	return true



@export var speed = 200
var velocity
var canDash
var dshd
var colliding
var justLoaded

var reqDirection

var dash_timer: Timer = Timer.new()

var char_skill_path: String = "res://src/Skills/"
var dodge: Skill
var parry: Skill

@onready var skillCheck = false

#@onready var state := $StateMachine
@onready var sprite:= $charaSprite
@onready var hurtbox:= $Hurtbox
@onready var collision: CollisionShape2D = hurtbox.get_child(0)

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
	
	dodge = load_skill("dodge")
	parry = load_skill("parry")
	call_deferred("load_playerdata")
	
	sprite.animation_finished.connect(_on_animation_finished)
	hurtbox.got_hit.connect(_on_hurt)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(global_position)
	velocity = Input.get_vector("Left", "Right", "Up", "Down")
	if(Input.is_action_just_pressed("SkillTree")):
		skillCheck = not(skillCheck)
		$AttributeMenu.visible = skillCheck
		if (skillCheck == true):
			$AttributeMenu.refresh()
		if(skillCheck == true):
			sprite.pause()
		else:
			sprite.play()
		if skillCheck:
			return
	if(!skillCheck):
		if(Input.is_action_just_pressed("Dodge") and canDash):
			#speed *= 4
			#dash_timer.start()
			#dshd = true
			dodge.execute(self, velocity)
		if(!check_move()):
			position += velocity * speed * delta
			
		
		if(Input.is_action_just_released("Dodge") and dshd):
			#speed /= 4
			#canDash = false
			#dshd = false
			pass
		
		if Input.is_action_just_pressed("OffHandAction"):
			parry.execute(self)
		
		if(!get_parent().returnPause()):
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
		print((velocity[reqDirection[0]] / reqDirection[1]))
		
		if ( ((abs(velocity[reqDirection[0]])) >= abs(reqDirection[1])) and ((velocity[reqDirection[0]] / reqDirection[1]) > 0)):
			print("Good")
			reqDirection = Vector2(0, 0)
			colliding = false
		else:
			velocity[reqDirection[0]] = 0
	return false

func load_skill(skill_name: String) -> Skill:
	var scene = load(str(char_skill_path + skill_name + ".tscn"))
	print(scene)
	var loaded_skill: Node = scene.instantiate()
	call_deferred("add_child", loaded_skill)
	if loaded_skill is Skill:
		return loaded_skill
	
	return null

func addEXP(gain: int) -> void:
	xp += gain
	while(xp >= 20):
		xp -= 20
		level += 1
		print("LEVEL UP: ", level)
		fortitude += 1
		strength += 1
		skill_points += level
		agility += 1
		tenacity += 1
		intellect += 1
	

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

func _on_hurt() -> void:
	print("Player Health: ", hurtbox.stats.Health)

func _on_dash_timeout() -> void:
	canDash = true;

func _on_animation_finished() -> void:
	if sprite.get_animation() == "dodge":
		sprite.animation = "idle"
		sprite.play()


func _on_hurtbox_dead() -> void:
	if(get_tree().get_first_node_in_group("Engine").world == "Dark"):
		get_tree().quit()
	else:
		get_tree().get_first_node_in_group("Engine").get_child(0).add_sibling(load("res://src/Scenes that are Very Very Temporary/farmRoom.tscn").instantiate())
		get_tree().get_first_node_in_group("Engine").get_child(0).queue_free()
	#pass # Replace with function body.
