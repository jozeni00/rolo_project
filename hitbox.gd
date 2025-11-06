#class_name Hitbox
extends Area2D

#@export var stats: SwordStats

## Emitted when Hitbox collides with Hurtbox.
signal hit

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	# This allows for potential combo hit after successful hit
	if area is Hurtbox:
		hit.emit()
