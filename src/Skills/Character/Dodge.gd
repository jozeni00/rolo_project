extends Skill

var _self: Player
var _animation: String
var _direction: Vector2

func _ready() -> void:
	_duration_timer.connect("timeout", Callable(self, "_duration_timeout"))

func _process(delta: float) -> void:
	if started():
		_self.global_position += _self.speed * 1.5 * _direction * delta
		

func execute(master: Player, direction: Vector2 = Vector2.ZERO):
	if ready():
		_self = master
		_direction = direction
		_animation = master.sprite.animation
		
		_self.sprite.animation = "dodge"
		_self.collision.disabled = true
		_duration_timer.start()
	

func _duration_timeout() -> void:
	_self.sprite.animation = _animation
	_self.collision.disabled = false
	cooldown_start()
