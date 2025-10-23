extends Control

var answer = 0

func _on_yes_pressed() -> void:
	answer = 1

func get_answer() -> int:
	return answer

func ask() -> void:
	answer = 0


func _on_no_pressed() -> void:
	answer = -1
