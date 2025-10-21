extends Node2D

@export var radius = 100
@onready var sprite := $ReticleSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var center = get_parent().global_position
	var cursor_position = get_global_mouse_position()
	var distance_to_center = center.distance_to(cursor_position)
	
	self.global_position = cursor_position
	
	if distance_to_center > radius:
		var direction = (cursor_position - center).normalized()
		self.global_position = center + direction * radius
		
