extends Node2D

@onready var p = get_tree().get_first_node_in_group("Player")
@onready var topZone = load("res://src/Scenes that are Very Very Temporary/midRoom.tscn")

func _ready() -> void:
	pass
	



func _on_top_loading_zone_entered(area: Area2D) -> void:
	if(area == p.hurtbox and !p.justLoaded):
		p.position[1] = 330
		#p.justLoaded = true
		add_sibling(topZone.instantiate())
		
		self.queue_free()
	pass # Replace with function body.


func _on_top_loading_zone_area_exited(area: Area2D) -> void:
	#p.justLoaded = false
	pass # Replace with function body.
