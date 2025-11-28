class_name AttackStats
extends Resource

const NONE := GameData.Element.NONE
const AIR := GameData.Element.AIR
const WATER := GameData.Element.WATER
const EARTH := GameData.Element.EARTH
const FIRE := GameData.Element.FIRE

const ATTACK := GameData.Stats.ATTACK
const ELEMENTAL_ATTACK := GameData.Stats.ELEMENTAL_ATTACK
const CRIT_CHANCE := GameData.Stats.CRIT_CHANCE
const CRIT_MULTIPLIER := GameData.Stats.CRIT_MULTIPLIER
const COOLDOWN := GameData.Stats.COOLDOWN
const ATTACK_DURATION := GameData.Stats.ATTACK_DURATION
const KNOCKBACK := GameData.Stats.KNOCKBACK

# Base stats
@export_range(0,99,1) var _Base_Attack: int = 5			# Base damage dealt
@export var WeaponElement: GameData.Element
@export_range(0,99,1) var _Base_ElementalAttack: int = 0:	# Base elemental damage dealt
	# Cannot have elemtal attack if there is no element
	set(value):
		if WeaponElement == NONE:
			_Base_ElementalAttack = 0
		else:
			_Base_ElementalAttack = value
@export_range(0,1,0.01) var _Base_CritChance: float = 0.02	# Chance for for crit
@export_range(1,3,0.5) var _Base_CritMultiplier: float = 1.5	# Amount of additional crit damage
@export_range(0,10) var _Base_Cooldown: float = 0.5		# Time before 
@export_range(0,3) var _Base_AttackDuration: float = 0.5	# How long attack takes
@export_range(0,3) var _Base_Knockback: float = 0.0		# Knockback force

var attack: int
var elemental_attack: int
var crit_chance: float
var crit_multiplier: float
var cooldown: float
var attack_duration: float
var knockback: float

# Called when the AttackStats resource is initialized.
func _init() -> void:
	call_deferred("reset_stats")

## Update the stat to the given value: stat = value.
func modify_stat(stat: GameData.Stats, value: Variant) -> void:
	if typeof(value) != TYPE_INT or typeof(value) != TYPE_FLOAT:
		print("Invalid type argument for value with type of ", typeof(value))
		return
	
	match stat:
		ATTACK:
			attack = value
		ELEMENTAL_ATTACK:
			elemental_attack = value
		CRIT_CHANCE:
			crit_chance = value
		CRIT_MULTIPLIER:
			crit_multiplier = value
		COOLDOWN:
			cooldown = value
		ATTACK_DURATION:
			attack_duration = value
		KNOCKBACK:
			knockback = value

## Modify a current stat with a percentage modifier: (stat * value) * 100%.
## The value given should be in the form of .1 for 10%.
## The example will be a 90% debuff.
func modify_stat_percentage(stat: GameData.Stats, value: float) -> void:
	if value < 0:
		print("Invalid value. Cannot pass negative values; must pass values greater than 0.")
		return
	
	match stat:
		ATTACK:
			attack = roundi(attack * value)
		ELEMENTAL_ATTACK:
			elemental_attack = roundi(elemental_attack * value)
		CRIT_CHANCE:
			crit_chance *= value
		CRIT_MULTIPLIER:
			crit_multiplier *= value
		COOLDOWN:
			cooldown *= value
		ATTACK_DURATION:
			attack_duration *= value
		KNOCKBACK:
			knockback *= value

## This sets/resets the current stats to the base stats
func reset_stats() -> void:
	attack = _Base_Attack
	elemental_attack = _Base_ElementalAttack
	crit_chance = _Base_CritChance
	crit_multiplier = _Base_CritMultiplier
	cooldown = _Base_Cooldown
	attack_duration = _Base_AttackDuration
	knockback = _Base_Knockback
