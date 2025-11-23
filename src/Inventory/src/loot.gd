class_name Loot
extends Node2D

@export var item: Item
@onready var sprite := $Sprite2D
@onready var animation := $AnimationPlayer
@onready var collect_range: Area2D = $Area2D

const MAX_DROP_RANGE = 45
const SPEED = 100
var direction: Vector2 = Vector2.ZERO
var player: Node2D = null

signal collected


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("dropped")
	global_position += Vector2(randf_range(-MAX_DROP_RANGE,MAX_DROP_RANGE), randf_range(-MAX_DROP_RANGE,MAX_DROP_RANGE))
	collect_range.area_entered.connect(_on_area_entered)
	animation.animation_finished.connect(_on_animation_finished)
	sprite.texture = item.sprite

func _process(delta: float) -> void:
	if player:
		direction = get_player_direction()
		position += direction * SPEED * delta
		var distance = global_position.distance_to(player.global_position)
		if distance < 30 and distance > 10:
			if scale > Vector2(.25, .25):
				scale *= .95
		if distance < 10:
			add_to_inventory(item)
			queue_free()
	

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		player = area.get_parent()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name != "dropped":
		return
	
	animation.play("default")

func add_to_inventory(new_item: Item) -> void:
	if new_item.item_type == item.Type.MONEY:
		PlayerData.increment_money()
	else:
		PlayerData.inventory.add(new_item)
	collected.emit()
	PlayerData.inventory.print_items()

func get_player_direction() -> Vector2:
	assert(player)
	return global_position.direction_to(player.global_position)
	
func get_item_type() -> int:
	return item.item_type
