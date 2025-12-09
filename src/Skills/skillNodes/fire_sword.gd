extends skillNode

func loadSkill() -> void:
	get_tree().get_first_node_in_group("Player").weaponNode.load_specSkill("shoot_beam")
	get_tree().get_first_node_in_group("Player").weapon.stats.WeaponElement = GameData.Element.FIRE
	get_tree().get_first_node_in_group("Player").weaponNode.sprite.play("fire")
	get_tree().get_first_node_in_group("Player").weaponNode.sprite.pause()
	
