extends Control

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var rows := $VBoxContainer.get_children()
@onready var skill_points_label: Label = $SkillPointsLabel

func _ready():
	visible = false
	player.stats_changed.connect(refresh)
	refresh()

func refresh():
	if not player:
		return

	skill_points_label.text = "Skill Points: " + str(player.skill_points)

	for row in rows:
		if row.has_method("setup"):
			row.setup(player)
