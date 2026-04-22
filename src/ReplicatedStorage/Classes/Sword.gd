class_name Sword
extends Node2D

@export var hitbox: Hitbox
@export var swordsprite: Sprite2D

## Time before successive attacks.
var cooldown_timer: Timer = Timer.new()

func _ready() -> void:
	assert(hitbox, "No Hitbox assigned.")
	assert(swordsprite, "No sprite assigned.")
	cooldown_timer.wait_time = hitbox.stats.AttackDuration
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
