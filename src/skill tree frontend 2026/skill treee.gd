extends Control

var player: Player:
	set(value):
		player = value
		# Pass it down to the Attributes node
		$Panel/Skill\ tree\ container/Attributes.player = value
