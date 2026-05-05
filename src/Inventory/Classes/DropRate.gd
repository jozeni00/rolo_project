class_name DropRate
extends Resource

@export var item: Item
@export_range(0, 100, 1, "suffix:%") var probability: float = 10
@export_range(0, 10, 1, "suffix:items") var min_amount: int = 0
@export_range(1, 10, 1, "suffix:items") var max_amount: int = 1

## Returns the quantity of the item to be dropped.
func get_drop_amount() -> int:
	var drop: bool = randf_range(0, 100) <= probability
	# Tough luck, no drop
	if !drop:
		return 0
	
	# Got lucky, there is a drop
	var amount = randi_range(min_amount, max_amount)
	return amount
