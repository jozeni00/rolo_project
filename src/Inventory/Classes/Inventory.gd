class_name Inventory
extends Resource

@export_range(0, 10, 1, "suffix:items") var max_size
@export var item_lists: Array[Item]

## Initialize inventory with a maximum size and starting items.
func _init(MaxSize: int, items: Array[Item]) -> void:
	max_size = MaxSize
	item_lists.assign(items)

## Returns true if the given item is currently in the inventory.
func has_item(item: Item) -> bool:
	
	if item_lists.is_empty():
		#print("EMPTY")
		return false
	
	return item_lists.has(item)

## Add the item into the inventory if there is space.
func add(item: Item) -> bool:
	if item_lists.is_empty() and max_size:
		item_lists.append(item)
		return true
	else:
		return false
		
	return true

func print_items() -> void:
	for item in item_lists:
		print(item.name)
