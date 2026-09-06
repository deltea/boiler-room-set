class_name Intro extends Control


@export var text_show_time = 0.3


signal finished()


@onready var come: Label = $ComeLabel
@onready var on: Label = $OnLabel
@onready var kid: Label = $KidLabel


func begin() -> void:
	show()
	come.hide()
	on.hide()
	kid.hide()

	come.material.set_shader_parameter("pixel_size", 16)
	on.material.set_shader_parameter("pixel_size", 16)
	kid.material.set_shader_parameter("pixel_size", 16)

	var tween := create_tween()

	tween.tween_callback(func() -> void: come.show())
	tween.tween_property(come.material, "shader_parameter/pixel_size", 1, text_show_time)
	tween.tween_interval(0.04)

	tween.tween_callback(func() -> void: on.show())
	tween.tween_property(on.material, "shader_parameter/pixel_size", 1, text_show_time)
	tween.tween_interval(0.2)

	tween.tween_callback(func() -> void: kid.show())
	tween.tween_property(kid.material, "shader_parameter/pixel_size", 1, text_show_time)
	tween.tween_callback(finished.emit)
