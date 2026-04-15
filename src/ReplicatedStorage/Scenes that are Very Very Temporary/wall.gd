extends Area2D

@onready var p = get_tree().get_first_node_in_group("Player")
var noSpeed

func _ready() -> void:
	noSpeed = Vector2 (0,0)
	pass

func _on_area_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		print("WALL")
		p.colliding = true
	pass # Replace with function body.
