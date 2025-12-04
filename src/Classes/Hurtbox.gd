class_name Hurtbox
extends Area2D

@export var stats: CharacterStats
var timer: Timer = Timer.new()
var success: bool = false
var target: Hitbox

## Emitted when Hitbox area enters Hurtbox area.
signal got_hit
## Emitted when the Hitpoints have changed.
signal hp_changed
## Emit when parry successful.
signal parry(opposition: Area2D) # signal could be used to stagger opponent
## Emitted when Health reaches 0.
signal dead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = stats.ParryWindow
	add_child(timer)
	timer.connect("timeout", Callable(self,"_on_timeout"))
	area_entered.connect(_on_area_entered)

'''
func _process(_delta: float) -> void:
	if (!timer.is_stopped() and 
	Input.is_action_just_pressed("OffHandAction") and get_parent() is Player):
		print("Parry!")
		timer.stop()
		parry.emit(target)
'''

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		target = area
		#print("HIT!! YOU GOT HIT!!")
		#timer.start()
		update_health(target.stats)

## Update Health when hit.
func update_health(op_stats: AttackStats) -> void:
	var damage = calculate_damage(op_stats)
	stats.Health -= damage
	stats.Health = max(0, stats.Health)			# make sure health is > 0
	got_hit.emit()
	if damage and damage < stats.Health:
		hp_changed.emit()
	if stats.Health <= 0:
		monitoring = false
		timer.stop()
		dead.emit()

## Takes Hitbox stats and use them to calculate damage with some chance of crit.
func calculate_damage(hit_stats: AttackStats) -> int:
	var crit: bool = randf() < hit_stats.crit_chance
	var damage = hit_stats.attack
	if hit_stats.WeaponElement != hit_stats.NONE:
		if hit_stats.WeaponElement == stats.ElementWeakness:
			damage += int(hit_stats.elemental_attack * 2)
		elif hit_stats.WeaponElement == stats.ElementResistance:
			damage += roundi(hit_stats.elemental_attack / 2.0)
	
	if crit:
		damage *= hit_stats.crit_multiplier

	return damage

func _on_timeout() -> void:
	update_health(target.stats)
