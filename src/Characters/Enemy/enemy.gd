extends Node2D

const LEFT = Vector2(-1, 1)
const RIGHT = Vector2(1, 1)

@export var speed = 180
@export var loot_table: Array[DropRate]

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2
var player: Node2D
var state
var aggro_timer: Timer = Timer.new()
var hurt_timer: Timer = Timer.new()
var vulnerable

signal attack

@onready var sprite := $enemSprite
@onready var HurtB := $Hurtbox


func _ready() -> void:
	print("Enemy.gd is running.")

	player = get_tree().get_first_node_in_group("Player")
	sprite.play("idle")

	aggro_timer.one_shot = true
	aggro_timer.wait_time = 2
	add_child(aggro_timer)
	aggro_timer.timeout.connect(_on_aggro_timeout)

	hurt_timer.one_shot = true
	hurt_timer.wait_time = 0.5
	add_child(hurt_timer)
	hurt_timer.timeout.connect(_on_hurt_timeout)
	hurt_timer.start()

	state = "idle"
	vulnerable = false


func _process(delta: float) -> void:
	direction = Vector2.ZERO

	if state == "aggro" or state == "chasing":
		chase(delta)

		if velocity.length() > 0:
			sprite.play("walk")

			if velocity.x < 0 and self.scale != LEFT:
				self.scale = LEFT
			elif velocity.x > 0 and self.scale == LEFT:
				self.scale = RIGHT

	elif state == "idle":
		speed = 40
		sprite.play("idle")

	elif state == "violence":
		if speed < 180:
			speed += 1
			velocity = Vector2.ZERO
			sprite.play("attack")
			emit_signal("attack")

		sprite.play("idle")


func chase(delta: float):
	if speed < 180:
		speed += 1

	direction = global_position.direction_to(player.global_position)
	global_position += direction * speed * delta
	velocity = direction * speed


func _on_detection_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player") and state != "death" and state != "hurt":
		print("IT BE THE PLAYER")
		state = "aggro"
		aggro_timer.stop()


func _on_detection_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player") and state != "death" and state != "hurt":
		print("YOU CANNOT ESCAPE")
		state = "chasing"
		aggro_timer.start()


func _on_attack_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player") and state != "death" and state != "hurt":
		print("ENEMY ATTACK")
		state = "violence"
		emit_signal("attack")


func _on_exit_attack_range(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player") and state != "death" and state != "hurt":
		print("GET BACK HERE")
		state = "aggro"


func _on_aggro_timeout() -> void:
	state = "idle"


func _on_hurtbox_got_hit() -> void:
	if vulnerable:
		print("This should play the hurt animation...")
		sprite.play("hurt")
		state = "hurt"
		hurt_timer.start()


func _on_hurt_timeout() -> void:
	if state == "death":
		self.queue_free()

		for loot in loot_table:
			var amount = loot.get_drop_amount()
			if amount:
				for i in amount:
					var drop: Loot = loot.instantiate()
					drop.item = loot.item
					drop.global_position = global_position
					var main = get_parent().get_parent()
					if main:
						main.call_deferred("add_child", drop)
	else:
		speed = 40
		state = "idle"
		vulnerable = true


func _on_hurtbox_dead() -> void:
	state = "death"
	print("DEAD")
	hurt_timer.wait_time = 1
	sprite.play("death")
	hurt_timer.start()
