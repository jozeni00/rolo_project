extends Node2D

const LOOT = preload("res://src/Inventory/loot.tscn")
@onready var p = get_tree().get_first_node_in_group("Player")
var playerPresence
var questGiver
var questGiven
var dialogue
var success
var leave_timer: Timer = Timer.new()

var questItem : Item = load("res://src/Inventory/Resources/Item/sharkoTooth.tres")

func _ready() -> void:
	playerPresence = false
	questGiver = true
	questGiven = false
	success = false
	leave_timer.one_shot = true
	leave_timer.wait_time = 1
	add_child(leave_timer)
	leave_timer.connect("timeout", Callable(self,"_on_leave_timeout"))
	#leave_timer.start()
	dialogue = "Hm? You want to get back to the Overworld\n...\nYou look strong enough...\nCan you bring me the tooth of King Sharko?"
	pass
	
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Interact") and playerPresence):
		interact()
	pass

func checkPrgrs() -> bool:
	#return false
	success = p.myInventory.has_item(questItem)
	return success
	
func interact() -> void:
	$Label.text = dialogue
	if(!questGiven):
		questGiven = true
		dialogue = "'Ya got the tooth yet?"
	elif(questGiven):
		if(checkPrgrs()):
			dialogue = "There it is!\nHere, I'll send you back"
			$Label.text = dialogue
			leave_timer.start()
			#get_tree().get_first_node_in_group("Engine").get_child(0).queue_free()
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		print("Player Here")
		playerPresence = true
	pass # Replace with function body.

func _on_leave_timeout() -> void:
	get_tree().get_first_node_in_group("Engine").get_child(0).queue_free()

func _on_area_2d_area_exited(area: Area2D) -> void:
	playerPresence = false
	$Label.text = ""
	pass # Replace with function body.
