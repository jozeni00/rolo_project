extends Control

signal attribute_points_changed(points: int)

# Labels
@onready var health_label: Label = $"Panel/Health"
@onready var level_label: Label = $"Panel/Level"
@onready var exp_label: Label = $"Panel/EXP"
@onready var stamina_label: Label = $"Panel/Blocking stamina"

# Health bar
@onready var health_bar_sprite: TextureRect = $"Panel/Health Bar"

# Button
@onready var block_btn: Button = $"Panel/Blocking stamina/Block"

@export var hurtbox: Hurtbox

# Constants
const EXP_CAP := 100
const MAX_STAMINA := 1000
const BLOCK_COST := 100

const STAMINA_REGEN_DELAY_SEC := 1.0
const HEALTH_REGEN_DELAY_SEC := 2.0

const STAMINA_REGEN_PER_SEC := 100.0
const HEALTH_REGEN_PER_SEC := 10.0

# Health bar size
const HEALTH_BAR_WIDTH := 320
const HEALTH_BAR_HEIGHT := 20

# Stats
var level: int = 1
var exp: int = 0
var stamina: float = MAX_STAMINA

var stamina_regen_locked_until: float = 0.0
var health_regen_locked_until: float = 0.0
var health_regen_accumulator: float = 0.0

var last_health_value: float = -1.0

func _ready() -> void:
	block_btn.pressed.connect(_on_block_pressed)

	health_bar_sprite.size = Vector2(HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT)
	health_bar_sprite.custom_minimum_size = Vector2(HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT)
	health_bar_sprite.z_index = -1

	if hurtbox != null and hurtbox.stats != null:
		last_health_value = float(hurtbox.stats.Health)

	_refresh_ui()

func _process(delta: float) -> void:
	var now: float = Time.get_ticks_msec() / 1000.0

	if hurtbox != null and hurtbox.stats != null:
		var current_health: float = float(hurtbox.stats.Health)

		# If health dropped, delay health regen by 1 second
		if last_health_value >= 0.0 and current_health < last_health_value:
			health_regen_locked_until = now + HEALTH_REGEN_DELAY_SEC
			health_regen_accumulator = 0.0

		last_health_value = current_health

		if now >= health_regen_locked_until:
			if hurtbox.stats.Health < hurtbox.stats.MaxHealth:
				health_regen_accumulator += HEALTH_REGEN_PER_SEC * delta

				if health_regen_accumulator >= 1.0:
					var heal_amount: int = int(health_regen_accumulator)

					hurtbox.stats.Health = min(
						hurtbox.stats.MaxHealth,
						hurtbox.stats.Health + heal_amount
					)

					health_regen_accumulator -= float(heal_amount)
					last_health_value = float(hurtbox.stats.Health)

	if now >= stamina_regen_locked_until and stamina < MAX_STAMINA:
		stamina = min(MAX_STAMINA, stamina + STAMINA_REGEN_PER_SEC * delta)

	_refresh_ui()

func add_exp(amount: int) -> void:
	exp += amount

	while exp >= EXP_CAP:
		exp -= EXP_CAP
		level += 1
		give_attribute_point()

	_refresh_ui()

func give_attribute_point() -> void:
	var player = get_tree().get_first_node_in_group("Player")

	if player == null:
		return

	player.skill_points += 5

	# Live update trigger
	attribute_points_changed.emit(player.skill_points)

func _on_block_pressed() -> void:
	stamina = max(0.0, stamina - float(BLOCK_COST))
	stamina_regen_locked_until = Time.get_ticks_msec() / 1000.0 + STAMINA_REGEN_DELAY_SEC
	_refresh_ui()

func _refresh_ui() -> void:
	if hurtbox != null and hurtbox.stats != null:
		var current: float = float(hurtbox.stats.Health)
		var max_h: float = float(hurtbox.stats.MaxHealth)

		health_label.text = "Health %d/%d" % [int(current), int(max_h)]
		_update_health_bar(current, max_h)
	else:
		health_label.text = "Health --/--"

	level_label.text = "Level %d" % level
	exp_label.text = "EXP %d/%d" % [exp, EXP_CAP]
	stamina_label.text = "Blocking stamina: %d/%d" % [int(stamina), MAX_STAMINA]

func _update_health_bar(current: float, max_h: float) -> void:
	if max_h <= 0.0:
		return

	var atlas := health_bar_sprite.texture as AtlasTexture
	if atlas == null:
		return

	var percent: float = clamp(current / max_h, 0.0, 1.0)
	var width: int = int(round(HEALTH_BAR_WIDTH * percent))

	if width <= 0:
		health_bar_sprite.visible = false
		return

	health_bar_sprite.visible = true
	atlas.region = Rect2(0, 0, width, HEALTH_BAR_HEIGHT)
