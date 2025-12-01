''' This class itself doesn't do anything unless it contains child nodes 
of type Skill. '''
class_name SkillPath
extends Node

var skills: Dictionary[String,Skill]
var paths: Dictionary[String,String]
var unlocks: Dictionary[String,bool]
var _skill_array: Array[String]
var _next_unlock: int =  0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child_node in get_children():
		if skills.size() > 10:
			break
		if child_node is Skill:
			var uid: String = ResourceUID.id_to_text(
				ResourceLoader.get_resource_uid(
					"res://src/Skills/" + child_node.name + ".tscn")
			)
			skills[child_node.name] = child_node
			paths[child_node.name] = uid
			unlocks[child_node.name] = false
			_skill_array.append(child_node.name)
			print("Skill: ", child_node.name)
			print("Unlocked: ", unlocks[child_node.name])
			print("Path: ", uid)


func unlock_skill() -> void:
	if PlayerData.skill_points:
		unlocks[_skill_array[_next_unlock]] = true
		_next_unlock += 1
		PlayerData.skill_points -= 1


func load_skill(skill_name: String) -> Skill:
	if !unlocks[skill_name]:
		return null
	var scene: PackedScene = load(paths[skill_name])
	var skill: Skill = scene.instantiate()
	return skill
