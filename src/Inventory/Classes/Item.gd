class_name Item
extends Resource

enum Type{
	## Any item that is consumed on use.
	CONSUMABLE,
	## Currency, used for to exchange for goods from shops.
	MONEY,
	## No real use, but for quests.
	QUEST,
	## Weapon items: Bow, Staff, or Sword.
	WEAPON}

@export var item_type: Type
@export var name: String
@export_multiline var description: String
@export var sprite: Texture2D
