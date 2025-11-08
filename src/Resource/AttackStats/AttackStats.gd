class_name AttackStats
extends Resource

## Weapon element, should be made into global.
enum Element{NONE, AIR, WATER, EARTH, FIRE}

@export_range(0,99,1) var Attack: int = 5			# Base damage dealt
@export_enum("NONE", "AIR", "WATER", "EARTH", "FIRE") var WeaponElement: int
@export_range(0,99,1) var ElementalAttack: int = 0:	# Base elemental damage dealt
	# Cannot have elemtal attack if there is no element
	set(value):
		if WeaponElement == Element.NONE:
			ElementalAttack = 0
		else:
			ElementalAttack = value
@export_range(0,1,0.01) var CritChance: float = 0.02	# Chance for for crit
@export_range(1,3,0.5) var CritMultiplier: float = 1.5	# Amount of additional crit damage
@export_range(0,10) var Cooldown: float = 0.5		# Time before 
@export_range(0,3) var AttackDuration: float = 0.5	# How long attack takes
@export_range(0,3) var Knockback: float = 0.0		# Knockback force
