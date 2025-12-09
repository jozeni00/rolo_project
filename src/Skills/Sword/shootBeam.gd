extends Skill


var beam


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func execute(master: Node2D, _direction: Vector2 = Vector2.ZERO):
	beam = load("res://beam.tscn").instantiate()
	beam.global_position = get_tree().get_first_node_in_group("Player").global_position
	get_tree().get_root().add_child(beam)
