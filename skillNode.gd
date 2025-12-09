class_name skillNode
extends Node2D

@export_range(0, 10, 1, "suffix:points") var skillCost
@export var successSprite: Texture2D
@onready var sprite = $icon
@export var elem: String
var active
@export var skillName: String
@export var description: String
@export var prevNode: skillNode


func _ready() -> void:
	active = false
	print("Ready")

func loadSkill() -> void:
	pass

func swapSprite() -> void:
	loadSkill()
	sprite.texture = successSprite
	
