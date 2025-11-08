class_name Character
extends CharacterBody2D

@export var hurtbox: Hurtbox
@export var charactersprite: Sprite2D

## Time to set inbetween successive dodges.
var dodge_timer: Timer = Timer.new()
## Time invulnerable active after valid collision.
var invincible_timer: Timer = Timer.new()

func _ready() -> void:
	assert(hurtbox, "No hurtbox defined.")
	assert(charactersprite, "No sprite defined.")
	assert(hurtbox.stats.ElementResistance!=hurtbox.stats.ElementWeakness or\
		hurtbox.stats.ElementResistance==0,\
		"The same elements were assigned as Weakness and Resistance.")
	dodge_timer.one_shot = true
	invincible_timer.one_shot = true
	dodge_timer.wait_time = hurtbox.stats.DodgeCooldown
	invincible_timer.wait_time = hurtbox.stats.InvicibleTime
	add_child(dodge_timer)
	add_child(invincible_timer)
