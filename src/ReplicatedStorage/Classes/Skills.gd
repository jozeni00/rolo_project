class_name CombatSkills
extends Resource

# General skill attribute, all skills hitbox are assumed to be circle
## How big the hitbox is.
@export_range(0.5, 10,0.5) var hitbox_radius: float = 1.0
## How long the hitbox stays in the scene.
@export_range(0, 10) var persistance_time: float = 0.0

# Projectile skills.
## Speed of projectile.
@export var speed: float = 0.0

@export var stats: SwordStats
