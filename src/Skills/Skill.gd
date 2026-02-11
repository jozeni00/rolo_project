class_name Skill
extends Node

## The amount of time in seconds the skill is active.
var duration: float = 0.3:
	set(value):
		duration = value
		_duration_timer.wait_time = duration
var _duration_timer: Timer = Timer.new()
## Time in-between successive skill activation
var cooldown: float = 1:
	set(value):
		cooldown = value
		_cooldown_timer.wait_time = cooldown
var _cooldown_timer: Timer = Timer.new()

func _init() -> void:
	_duration_timer.one_shot = true
	_duration_timer.wait_time = duration
	add_child(_duration_timer)
	
	_cooldown_timer.one_shot = true
	_cooldown_timer.wait_time = cooldown
	add_child(_cooldown_timer)

## This is the method that is executed at activation.
func execute(master: Player, direction: Vector2 = Vector2.ZERO):
	pass

func ready() -> bool:
	return _cooldown_timer.is_stopped() and _duration_timer.is_stopped()

func cooldown_start() -> void:
	_cooldown_timer.start()

## Returns true if the skill is active.
func started() -> bool:
	return not _duration_timer.is_stopped()
