extends Control

var _player: Player

var player: Player:
	get:
		return _player
	set(value):
		_player = value
		
		var panel = $Panel
		var attributes_node = panel.get_node("SkillTreeContainer/Attributes")
		
		if attributes_node:
			attributes_node.set_dependencies(value, panel)
