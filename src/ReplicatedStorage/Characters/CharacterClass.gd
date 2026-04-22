class_name  Character
extends Node2D

enum State{IDLE, WALK, CHASE, ATTACK, SPECIAL, HURT, DEATH}

## State when the character is standing still.
const IDLE := State.IDLE
## State when the character is randomly walking around.
const WALK := State.WALK
## State when the enemy character is pursuing the player.
const CHASE := State.CHASE
## State when the enemy character is currently performing an attack.
const ATTACK := State.ATTACK
## State when the character is performing a skill/ability.
const SPECIAL := State.SPECIAL
## State when the character is attacked.
const HURT := State.HURT
## State when the character's health reaches 0.
const DEATH := State.DEATH



## The current state of the enemy. Whenever the state changes,
## the state's transition function will be called.
var state: State:
	set(value):
		state_exits[state].call()
		state = value
		state_entries[state].call()

## The function table that holds each state's "_init"/entry function.
var state_entries: Dictionary[State, Callable] = {}

## The function table that holds each state's "_process" function.
var state_updates: Dictionary[State, Callable] = {}			

## The function table that holds each state's exit function.
var state_exits: Dictionary[State, Callable] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_entries[IDLE] = Callable(self, "_idle_entry")
	state_entries[WALK] = Callable(self, "_walk_entry")
	state_entries[CHASE] = Callable(self, "_chase_entry")
	state_entries[ATTACK] = Callable(self, "_attack_entry")
	state_entries[SPECIAL] = Callable(self, "_special_entry")
	state_entries[HURT] = Callable(self, "_hurt_entry")
	state_entries[DEATH] = Callable(self, "_death_entry")
	
	state_updates[IDLE] = Callable(self, "_idle")
	state_updates[WALK] = Callable(self, "_walk")
	state_updates[CHASE] = Callable(self, "_chase")
	state_updates[ATTACK] = Callable(self, "_attack")
	state_updates[SPECIAL] = Callable(self, "_special")
	state_updates[HURT] = Callable(self, "_hurt")
	state_updates[DEATH] = Callable(self, "_death")
	
	state_exits[IDLE] = Callable(self, "_idle_exit")
	state_exits[WALK] = Callable(self, "_walk_exit")
	state_exits[CHASE] = Callable(self, "_chase_exit")
	state_exits[ATTACK] = Callable(self, "_attack_exit")
	state_exits[SPECIAL] = Callable(self, "_special_exit")
	state_exits[HURT] = Callable(self, "_hurt_exit")
	state_exits[DEATH] = Callable(self, "_death_exit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state_updates[state].call(delta)

# State update function.
func _idle(_delta: float = 0.0167) -> void:
	pass
	
func _walk(_delta: float = 0.0167) -> void:
	pass

func _chase(_delta: float = 0.0167) -> void:
	pass

func _attack(_delta: float = 0.0167) -> void:
	pass

func _hurt(_delta: float = 0.0167) -> void:
	pass

func _death(_delta: float = 0.0167) -> void:
	pass

# State entry function.
func _idle_entry() -> void:
	pass
	
func _walk_entry() -> void:
	pass

func _chase_entry() -> void:
	pass

func _attack_entry() -> void:
	pass

func _hurt_entry() -> void:
	pass

func _death_entry() -> void:
	pass

# State exit function.
func _idle_exit() -> void:
	pass
	
func _walk_exit() -> void:
	pass

func _chase_exit() -> void:
	pass

func _attack_exit() -> void:
	pass

func _hurt_exit() -> void:
	pass

func _death_exit() -> void:
	pass
