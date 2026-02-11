extends Node

# Player Data
## Player inventory.
var inventory: Inventory = Inventory.new(9, [])

var _money: int = 0:		# money/currency to exhcange for goods
	set(value):
		_money = value
		print("Money: ", _money)

const _MAX_LEVEL: int = 20

var level: int = 1				# player's current level
var xp: int = 0				# player's current experience points
var _max_exp: int = level * 14 # max exp before next level-up
var skill_points: int = 0
var strength: int = 10
var element: int = 0
var fortitude: int = 0
var agility: int = 0
var tenacity: int = 0
var intellect: int = 0

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
func add_exp(value: int) -> void:
	if value < 0 or level >= _MAX_LEVEL:
		return
	xp += value
	while xp >= _max_exp and level < _MAX_LEVEL:
		level += 1
		skill_points += 1
		_max_exp = 14 * level
