extends Control

# Labels
@onready var health_label: Label = $"Panel/Health"
@onready var level_label: Label = $"Panel/Level"
@onready var exp_label: Label = $"Panel/EXP"
@onready var stamina_label: Label = $"Panel/Blocking stamina"

# Buttons
@onready var take_damage_btn: Button = $"Panel/Health/Take damage"
@onready var add_exp_btn: Button = $"Panel/EXP/Add exp"
@onready var block_btn: Button = $"Panel/Blocking stamina/Block"

# Constants
const MAX_HEALTH := 100
const EXP_CAP := 100

const MAX_STAMINA := 1000
const BLOCK_COST := 100

const REGEN_DELAY_SEC := 1.0
const STAMINA_REGEN_PER_SEC := 100.0
const HEALTH_REGEN_PER_SEC := 1   # HP regen per second

# Stats
var health: float = MAX_HEALTH
var level: int = 1
var exp: int = 0

var stamina: float = MAX_STAMINA
var regen_locked_until: float = 0.0

func _ready() -> void:
	take_damage_btn.pressed.connect(_on_take_damage_pressed)
	add_exp_btn.pressed.connect(_on_add_exp_pressed)
	block_btn.pressed.connect(_on_block_pressed)
	_refresh_ui()

func _process(delta: float) -> void:
	var now := Time.get_ticks_msec() / 1000.0

	# Health Regen (1/sec)
	if health < MAX_HEALTH:
		health = min(MAX_HEALTH, health + HEALTH_REGEN_PER_SEC * delta)

	
	# Stamina Regen (after delay)
	if now >= regen_locked_until and stamina < MAX_STAMINA:
		stamina = min(MAX_STAMINA, stamina + STAMINA_REGEN_PER_SEC * delta)

	_refresh_ui()

func _on_take_damage_pressed() -> void:
	health = max(0.0, health - 10.0)
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
	health_label.text = "Health %d/%d" % [int(round(health)), MAX_HEALTH]
	level_label.text = "Level %d" % level
	exp_label.text = "EXP %d/%d" % [exp, EXP_CAP]
	stamina_label.text = "Blocking stamina: %d/%d" % [int(round(stamina)), MAX_STAMINA]
