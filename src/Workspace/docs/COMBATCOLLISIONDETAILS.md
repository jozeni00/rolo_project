# Back-End Combat Details
This will provide a quick summary of how the collision works and how to utilize them.
## Collision Detection

### CharacterStats and SwordStats Resources
Hitbox and Hurtbox uses the resources, `SwordStats` and `CharacterStats` respectively, which holds informations such as stats, and cooldown times.
<p align="center">
  <img width="197" height="177" alt="image" src="https://github.com/user-attachments/assets/3195a463-b85f-4bec-83fd-3429fe5a6792" />
  <img width="200" height="230" alt="image" src="https://github.com/user-attachments/assets/f96dbfab-5073-48a8-b871-df6a15b9923d" />
</p>

Different resource configurations could be saved and easily apply to different character and sword types from the drop-down menu.
<p align="center">
  <img width="101" height="245" alt="image" src="https://github.com/user-attachments/assets/4c467901-9728-44bf-a9a9-5619db43fd4c" />
</p>

All of the configurables are managed from their respective resource class. If more elements are to be add or elements removed, they can do so in the script. Following is the CharacterStats class script.
```gdscript
class_name CharacterStats
extends Resource

enum Element{NONE, AIR, WATER, EARTH, FIRE}

@export var MaxHealth: int = 100
@export var Health: int = 100
@export_range(0,3,0.1) var DodgeCooldown: float = 1.0
@export_range(0,2,0.1) var InvicibleTime: float = 0.5

@export_enum("NONE", "AIR", "WATER", "EARTH", "FIRE") var ElementWeakness: int
@export_enum("NONE", "AIR", "WATER", "EARTH", "FIRE") var ElementResistance: int
```

### Hitbox and Hurtbox Classes
Collisions are tracked using the custom classes `Hitbox` and `Hurtbox`, which inherits from the built-in class `Area2D`. Hitbox will use the resources with stats like `Attack` and Hurtbox with stats like `Health`.
The class definition simply exports the resource so that it could be define in the editor. This could be made more vague by changing the SwordStats class to Resource or similar, so it could work with other weapon classes later down the road.
```gdscript
class_name Hitbox
extends Area2D

@export var stats: SwordStats
```

## Example
A custom `Sword` class can use the Hitbox to inherit it's properties and to interact with the Hurtbox of another object. Below the Sword class uses the defined Hitbox stat, `AttackDuration` to set it's own cooldown timer.
```gdscript
class_name Sword
extends Node2D

@export var hitbox: Hitbox
var cooldown_timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(hitbox, "No Hitbox assigned.")
	cooldown_timer.wait_time = hitbox.stats.AttackDuration
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
```

## Damage Calculation
The Hurtbox applies the damage calculation when a Hitbox enters it's area. It will pull the stats from the Hitbox and apply the damage with the following equation.

$Damage = (Attack + (Weakness\in\lbrace0,1 \rbrace \times ElementalAttack \times 2) + (Resistance\in\lbrace0,1 \rbrace \times ElementalAttack \times 0.5))\times(Crit\in\lbrace random()<CritChance\rbrace)$
