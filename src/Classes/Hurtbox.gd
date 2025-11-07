class_name Hurtbox
extends Area2D

@export var stats: CharacterStats

## Emitted when Hitbox area enters Hurtbox area.
signal got_hit
## Emitted when Health reaches 0.
signal dead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		#print("HIT!! YOU GOT HIT!!")
		get_parent().sprite.play("hurt")
		var damage = calculate_damage(area.stats)
		stats.Health -= damage
		stats.Health = max(0, stats.Health)			# make sure health is > 0
		print(stats.Health)
		got_hit.emit()
		if stats.Health <= 0:
			dead.emit()

## Takes Hitbox stats and use them to calculate damage with some chance of crit.
func calculate_damage(hit_stats: AttackStats) -> int:
	var crit: bool = randf() < hit_stats.CritChance
	var damage = hit_stats.Attack
	if hit_stats.WeaponElement != hit_stats.Element.NONE:
		if hit_stats.WeaponElement == stats.ElementWeakness:
			damage += int(hit_stats.ElementalAttack * 2)
		elif hit_stats.WeaponElement == stats.ElementResistance:
			damage += round(hit_stats.ElementalAttack / 2)
	
	if crit:
		damage *= hit_stats.CritMultiplier

	return damage
