class_name skillNode
extends Node2D

@export_range(0, 10, 1, "suffix:points") var skillCost
@export var successSprite: Texture2D
@onready var sprite = $icon
@export var elem: String


func _ready() -> void:
	print("Ready")

func swapSprite():
	sprite.texture = successSprite
	
