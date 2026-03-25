extends Control

# Labels
@onready var health_label: Label = $"Panel/Health"
@onready var level_label: Label = $"Panel/Level"
@onready var exp_label: Label = $"Panel/EXP"
@onready var stamina_label: Label = $"Panel/Blocking stamina"

# Health bar sprite
@onready var health_bar_sprite: TextureRect = $"Panel/Health Bar Sprite"

# Buttons
@onready var take_damage_btn: Button = $"Panel/Health/Take damage"
@onready var add_exp_btn: Button = $"Panel/EXP/Add exp"
@onready var block_btn: Button = $"Panel/Blocking stamina/Block"

@export var hurtbox: Hurtbox

# Constants
const EXP_CAP := 100

const MAX_STAMINA := 1000
const BLOCK_COST := 100

const REGEN_DELAY_SEC := 1.0
const STAMINA_REGEN_PER_SEC := 100.0
const HEALTH_REGEN_PER_SEC := 10.0

# Main fill area inside the atlas
const HEALTH_BAR_FILL_X := 10
const HEALTH_BAR_FILL_Y := 0
const HEALTH_BAR_FILL_FULL_WIDTH := 300
const HEALTH_BAR_FILL_HEIGHT := 20

# Dedicated empty bar region at 0 HP
# Adjust these if needed
const HEALTH_BAR_EMPTY_X := 0
const HEALTH_BAR_EMPTY_Y := 0
const HEALTH_BAR_EMPTY_WIDTH := 1
const HEALTH_BAR_EMPTY_HEIGHT := 20

# Stats
var level: int = 1
var exp: int = 0

var stamina: float = MAX_STAMINA
var regen_locked_until: float = 0.0

# Regen fix
var health_regen_accumulator: float = 0.0

func _ready() -> void:
	take_damage_btn.pressed.connect(_on_take_damage_pressed)
	add_exp_btn.pressed.connect(_on_add_exp_pressed)
	block_btn.pressed.connect(_on_block_pressed)

	health_bar_sprite.custom_minimum_size = Vector2(HEALTH_BAR_FILL_FULL_WIDTH, HEALTH_BAR_FILL_HEIGHT)

	_refresh_ui()

func _process(delta: float) -> void:
	var now := Time.get_ticks_msec() / 1000.0

	# Health regen
	if hurtbox != null and hurtbox.stats != null:
		if hurtbox.stats.Health < hurtbox.stats.MaxHealth:
			health_regen_accumulator += HEALTH_REGEN_PER_SEC * delta

			if health_regen_accumulator >= 1.0:
				var heal_amount: int = int(health_regen_accumulator)
				hurtbox.stats.Health = min(hurtbox.stats.MaxHealth, hurtbox.stats.Health + heal_amount)
				health_regen_accumulator -= heal_amount

	# Stamina regen
	if now >= regen_locked_until and stamina < MAX_STAMINA:
		stamina = min(MAX_STAMINA, stamina + STAMINA_REGEN_PER_SEC * delta)

	_refresh_ui()

func _on_take_damage_pressed() -> void:
	if hurtbox == null or hurtbox.stats == null:
		_refresh_ui()
		return

	hurtbox.stats.Health = max(0.0, hurtbox.stats.Health - 10.0)
	_refresh_ui()

func _on_add_exp_pressed() -> void:
	exp += 100
	while exp >= EXP_CAP:
		exp -= EXP_CAP
		level += 1
	_refresh_ui()

func _on_block_pressed() -> void:
	stamina = max(0.0, stamina - float(BLOCK_COST))
	regen_locked_until = Time.get_ticks_msec() / 1000.0 + REGEN_DELAY_SEC
	_refresh_ui()

func _refresh_ui() -> void:
	if hurtbox != null and hurtbox.stats != null:
		var current_health: float = hurtbox.stats.Health
		var max_health: float = hurtbox.stats.MaxHealth

		health_label.text = "Health %d/%d" % [
			int(round(current_health)),
			int(round(max_health))
		]

		_update_health_bar_fill(current_health, max_health)
	else:
		health_label.text = "Health --/--"

	level_label.text = "Level %d" % level
	exp_label.text = "EXP %d/%d" % [exp, EXP_CAP]
	stamina_label.text = "Blocking stamina: %d/%d" % [int(round(stamina)), MAX_STAMINA]

func _update_health_bar_fill(current_health: float, max_health: float) -> void:
	if max_health <= 0.0:
		return

	var percent: float = current_health / max_health
	percent = clamp(percent, 0.0, 1.0)

	var atlas := health_bar_sprite.texture as AtlasTexture
	if atlas != null:
		if percent <= 0.0:
			atlas.region = Rect2(
				HEALTH_BAR_EMPTY_X,
				HEALTH_BAR_EMPTY_Y,
				HEALTH_BAR_EMPTY_WIDTH,
				HEALTH_BAR_EMPTY_HEIGHT
			)
			return

		var width: int = int(HEALTH_BAR_FILL_FULL_WIDTH * percent)
		if width < 1:
			width = 1

		atlas.region = Rect2(
			HEALTH_BAR_FILL_X,
			HEALTH_BAR_FILL_Y,
			width,
			HEALTH_BAR_FILL_HEIGHT
		)
