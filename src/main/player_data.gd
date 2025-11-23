extends Node

# Player Data
## Player inventory.
var inventory: Inventory = Inventory.new(9, [])

var _money: int = 0:		# money/currency to exhcange for goods
	set(value):
		_money = value
		print("Money: ", _money)

const _MAX_LEVEL: int = 20

var _level: int = 1				# player's current level
var _exp: int = 0				# player's current experience points
var _max_exp: int = _level * 14 # max exp before next level-up
var _skill_points: int = 0
var attack_attribute: AttackStats = AttackStats.new()
var character_attributes: CharacterStats = CharacterStats.new()

## Increment the player's money by 1.
func increment_money() -> void:
	set_money(_money + 1)

## Set the player's money by the amount given.
func set_money(amount: int) -> void:
	_money = amount

## Get the amount of money the player currently have.
func get_money() -> int:
	return _money

## Add the player's experience point by the given amount and update level
## as neccessary.
func add_exp(exp: int) -> void:
	if exp < 0 or _level >= _MAX_LEVEL:
		return
	_exp += exp
	while _exp >= _max_exp and _level < _MAX_LEVEL:
		_level += 1
		_skill_points += 1
		_max_exp = 14 * _level
