extends Node2D

@onready var p = get_tree().get_first_node_in_group("Player")
var playerPresence
var questGiver
var questGiven
var dialogue

func _ready() -> void:
	playerPresence = false
	questGiver = true
	questGiven = false
	dialogue = "Hm? You look strong enough...\nCan you bring me the tooth of King Sharko?"
	pass
	
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Interact") and playerPresence):
		interact()
	pass

func interact() -> void:
	$Label.text = dialogue
	if(!questGiven):
		questGiven = true
		dialogue = "'Ya got the tooth yet?"
	#if(questGiven and )
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area == p.hurtbox):
		print("Player Here")
		playerPresence = true
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	playerPresence = false
	$Label.text = ""
	pass # Replace with function body.
