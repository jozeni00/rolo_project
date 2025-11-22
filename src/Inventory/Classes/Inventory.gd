class_name Inventory
extends Resource

@export_range(0, 10, 1, "suffix:items") var max_size
@export var item_lists: Array[Item]


func has_item(item: Item) -> bool:
	
	if item_lists.is_empty():
		#print("EMPTY")
		return false
	
	for i in item_lists:
		print("item")
		if i == item:
			return true
	
	return false


func add(item: Item) -> bool:
	if item_lists.is_empty() and max_size:
		item_lists.append(item)
		return true
	else:
		return false
		
	return true
