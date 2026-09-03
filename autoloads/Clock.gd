extends Node


var time: float = 0.0


func _process(dt: float) -> void:
	time += dt


func wait(duration: float) -> void:
	await get_tree().create_timer(duration, true, false, true).timeout
