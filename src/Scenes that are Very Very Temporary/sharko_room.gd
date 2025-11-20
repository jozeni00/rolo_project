extends Node2D

@onready var p = get_tree().get_first_node_in_group("Player")
@onready var bottomZone = load("res://src/Scenes that are Very Very Temporary/midRoom.tscn")
func _ready() -> void:
	pass
	


func _on_loading_zone_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		p.position[1] = 40
		#p.justLoaded = true
		add_sibling(bottomZone.instantiate())
		self.queue_free()
	pass # Replace with function body.


func _on_wall_1_area_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		p.colliding = true;
		p.reqDirection = Vector2(0, 1)
	#pass # Replace with function body.


func _on_wall_2_area_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		p.colliding = true;
		p.reqDirection = Vector2(0, -1)
	#pass # Replace with function body.


func _on_wall_3_area_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		p.colliding = true;
		p.reqDirection = Vector2(1, -1)
	#pass # Replace with function body.


func _on_wall_5_area_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		p.colliding = true;
		p.reqDirection = Vector2(1, -1)
	#pass # Replace with function body.


func _on_wall_4_area_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		p.colliding = true;
		print("Hfnhsnfekf")
		p.reqDirection = Vector2(1, 1)
	#pass # Replace with function body.


func _on_loading_zone_exited(area: Area2D) -> void:
	#p.justLoaded = false
	pass # Replace with function body.
