class_name Sword
extends Node2D

@export var hitbox: Hitbox
var cooldown_timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(hitbox, "No Hitbox assigned.")
	cooldown_timer.wait_time = hitbox.stats.AttackDuration
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
