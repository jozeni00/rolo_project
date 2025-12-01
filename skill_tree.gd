class_name skill_tree
extends Node2D

@onready var selection = $fireSword
@onready var lastSelection = $earthSword
@export var skills: Array[skillNode]
@export var numRows = 3
@export var numCols = 3
@onready var rowCol = Vector2(1, 0)
@onready var selectionIndex = 3
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var reticule = $Reticule
@onready var currentElement = "NONE"

"""
This is the script for the Skill Tree

This script assumes that you arrrange the array of skills like so:
[skillA1, skillA2, skillA3, skillB1, skillB2, skillB3 ...]

It also assumes that you have an equal number of rows of skills for each column
For instance, a skill tree with 3 rows and 3 columns assumes that each column has 3 rows

So you can't make one branch lopsided with this script, unfortunately
"""

var active
func _ready() -> void:
	active = false
	
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("SkillTree")):
		active = !active
		if(!active):
			reticule.hide()
		else:
			reticule.show()
		print("TOGGLE")
	if(active):
		if(Input.is_action_just_pressed("Down")):
			rowCol[1] += 1
			if(rowCol[1] > (numCols-1)):
				rowCol[1] = 0
		elif(Input.is_action_just_pressed("Up")):
			rowCol[1] -= 1
			if(rowCol[1] < 0):
				rowCol[1] = (numCols - 1) 
		elif(Input.is_action_just_pressed("Right")):
			rowCol[0] += 1
			if(rowCol[0] > (numRows-1)):
				rowCol[0] = 0
			
		elif(Input.is_action_just_pressed("Left")):
			rowCol[0] -= 1
			if(rowCol[0] < (0)):
				rowCol[0] = (numRows - 1) 
		if(Input.get_vector("Left", "Right", "Up", "Down").length() > 0):
			selectionIndex = (rowCol[0] * numRows) + rowCol[1]
			selection = (skills[selectionIndex])
			reticule.global_position = selection.global_position
			
		if(selection != lastSelection):
			lastSelection = selection
		if(Input.is_action_just_pressed("Interact")):
			purchaseSkill(player.skill_points)

func checkCompatibility() -> bool:		
	if(currentElement == "NONE"):
		currentElement = selection.elem
		return true
	elif(currentElement in selection.elem):
		return true
	return false
		
func purchaseSkill(points: int)->void:
	if(points >= selection.skillCost and checkCompatibility()):
		selection.swapSprite()
		player.skill_points -= selection.skillCost
		print(player.skill_points)
	else:
		print("NOT RIGHT")
