extends Skill

@onready var area := $Area2D
@onready var collision := $Area2D/CollisionShape2D

var skill_owner: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown = 0.5
	collision.disabled = true
	
	area.area_entered.connect(_area_entered)
	
	_duration_timer.connect("timeout", Callable(self, "_duration_timeout"))


func execute(master: Player, _direction: Vector2 = Vector2.ZERO):
	if ready():
		print("Parry active.")
		skill_owner = master
		area.global_position = skill_owner.global_position
		skill_owner.collision.disabled = true
		collision.disabled = false
		_duration_timer.start()
	
func _duration_timeout() -> void:
	print("Parry inactive.")
	skill_owner.collision.disabled = false
	collision.disabled = true
	cooldown_start()

func _area_entered(_area: Area2D) -> void:
	if _area is Hitbox:
		print("Parry success!")
		skill_owner.collision.disabled = false
		collision.disabled = true
		# Put code that resolves parry here.
