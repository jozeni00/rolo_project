extends Node2D

signal done
@onready var duration = $Duration
@onready var cooldown = $Cooldown
@onready var collision = $Hitbox/CollisionShape2D
@onready var hitbox = $Hitbox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	duration.one_shot = true
	cooldown.one_shot = true
	duration.wait_time = hitbox.stats.AttackDuration
	cooldown.wait_time = hitbox.stats.Cooldown
	hitbox.hit.connect(_on_hit)
	duration.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hit() -> void:
	cooldown.start()
	collision.disabled = true

func _on_timer_timeout() -> void:
	done.emit()
	collision.disabled = true
	cooldown.stop()


func _on_cooldown_timeout() -> void:
	collision.disabled = false
