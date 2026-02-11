class_name CharacterStats
extends Resource

enum Element{NONE, AIR, WATER, EARTH, FIRE}

@export var MaxHealth: int = 100
@export var Health: int = 100
@export_range(0,3,0.1) var DodgeCooldown: float = 1.0
@export_range(0,2,0.1) var InvicibleTime: float = 0.5
@export_range(0,0.5,0.1) var ParryWindow: float = 0.5

@export_enum("NONE", "AIR", "WATER", "EARTH", "FIRE") var ElementWeakness: int
@export_enum("NONE", "AIR", "WATER", "EARTH", "FIRE") var ElementResistance: int
