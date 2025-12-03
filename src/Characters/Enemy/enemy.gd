extends Node2D

<<<<<<< HEAD:src/Characters/Enemy/enemy.gd
const LOOT = preload("res://src/Inventory/loot.tscn")
const LEFT = Vector2(-1,1)
const RIGHT = Vector2(1,1)
=======
const LEFT = Vector2(-1, 1)
const RIGHT = Vector2(1, 1)
>>>>>>> d7fce3b (icons in sprite sheets/icon_sprites):src/Enemy/enemy.gd

@export var speed = 180
@export var loot_table: Array[DropRate]
var velocity
var direction: Vector2
var player: Node2D
var state
var aggro_timer: Timer = Timer.new()
var hurt_timer: Timer = Timer.new()
var vulnerable
signal attack

@onready var sprite := $enemSprite
@onready var HurtB := $Hurtbox
#@onready var timer := $AggroTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	sprite.play("idle")
<<<<<<< HEAD
	aggro_timer.one_shot = true
	aggro_timer.wait_time = 2
	add_child(aggro_timer)
	aggro_timer.connect("timeout", Callable(self, "_on_aggro_timeout"))
	hurt_timer.one_shot = true
	hurt_timer.wait_time = .5
	add_child(hurt_timer)
<<<<<<< HEAD:src/Characters/Enemy/enemy.gd
	hurt_timer.connect("timeout", Callable(self,"_on_hurt_timeout"))
=======
	
>>>>>>> test2
	#hurt_timer.start()
=======
	hurt_timer.connect("timeout", Callable(self, "_on_hurt_timeout"))
	hurt_timer.start()
>>>>>>> d7fce3b (icons in sprite sheets/icon_sprites):src/Enemy/enemy.gd
	state = "idle"
	vulnerable = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Vector2.ZERO
	if state == "aggro" or state == "chasing":
		chase(player, delta)
		#velocity = 0
		##position += velocity * delta
		if velocity.length() > 0:
			sprite.play("walk")
<<<<<<< HEAD

			if velocity[0] < 0 and self.scale != LEFT:  # and self.get_child(2).cursor_position.x < self.position.x):
				self.scale = LEFT
			elif velocity[0] > 0 and self.scale == LEFT:
				self.scale = RIGHT

	elif state == "idle":
=======
		"""
			if(velocity[0] < 0 and self.scale != LEFT):# and self.get_child(2).cursor_position.x < self.position.x):
				
				self.scale = LEFT
			elif(velocity[0] > 0 and self.scale == LEFT):
				self.scale = RIGHT"""
			
	elif (state == "idle"):
>>>>>>> test2
		speed = 40
		sprite.play("idle")
		#print("Nothin at all")
	elif state == "violence":
		if speed < 180:
			speed += 1
		#print("I wish to demolish you")
		sprite.play("idle")
	#pass


func chase(player, delta: float):
<<<<<<< HEAD:src/Characters/Enemy/enemy.gd
	if(speed < 180 and get_tree().get_first_node_in_group("Engine").returnPause() == 0):
=======
	if speed < 180:
>>>>>>> d7fce3b (icons in sprite sheets/icon_sprites):src/Enemy/enemy.gd
		speed += 1
	direction = global_position.direction_to(player.global_position)
	#direction =direction.normalized()
	"""if(state == "chasing"):
		speed *= 4"""
	#print(direction)
	global_position += direction * speed * delta
	velocity = direction * speed
	"""if(state == "chasing"):
		speed /= 4
		state = "aggro" """


func _on_detection_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player") and state != "death" and state != "hurt":
		#print("IT BE THE PLAYER")
		state = "aggro"
		aggro_timer.stop()
	#pass # Replace with function body.


func _on_detection_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player") and state != "death" and state != "hurt":
		#print("YOU CANNOT ESCAPE")
		state = "chasing"
		aggro_timer.start()
	#pass # Replace with function body.


func _on_attack_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")) and state != "death" and state != "hurt":
		#print("ATTACK")
		state = "violence"
	#pass # Replace with function body.


func _on_exit_attack_range(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")) and state != "death" and state != "hurt":
		#print("GET BACK HERE")
		state = "aggro"
		#timer.stop()
	#pass # Replace with function body.


func _on_aggro_timeout() -> void:
	state = "idle"


func _on_hurtbox_got_hit() -> void:
	if vulnerable:
		print("This should play the hurt animation...")
		sprite.play("hurt")
		state = "hurt"
		hurt_timer.start()
	#state = "mwefnrf"
	#sprite.stop()
	#pass # Replace with function body.
<<<<<<< HEAD


func _on_hurt_timeout() -> void:
	#print("Must've been the wind...")
	if state == "death":
=======
	
func _on_hurt_timeout() -> void:
	if(state == "death"):
>>>>>>> test2
		self.queue_free()
		for loot in loot_table:
			var amount = loot.get_drop_amount()
			if amount:
				for i in amount:
					var drop: Loot = LOOT.instantiate()
					drop.item = loot.item
					drop.global_position = global_position
					var main = get_parent().get_parent()
					if main:
						main.call_deferred("add_child", drop)
		
	else:
		speed = 40
		state = "idle"
		vulnerable = true
	#pass # Replace with function body.


func _on_hurtbox_dead() -> void:
	state = "death"
	print("DEAD")
	hurt_timer.wait_time = 1
	sprite.play("death")
	hurt_timer.start()
	#pass # Replace with function body.
