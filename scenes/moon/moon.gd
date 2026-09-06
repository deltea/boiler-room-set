class_name Moon extends Sprite2D


@export var eclipse_time: float = 2.0
@export var time_offset: float = 0.0


@onready var eclipse: Sprite2D = $Mask/Eclipse


func _ready() -> void:
	eclipse.show()

	await Clock.wait(time_offset)

	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_loops()
	tween.tween_property(eclipse, "scale:x", 0.0, eclipse_time).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(eclipse, "scale:y", 0.5, eclipse_time).set_ease(Tween.EASE_IN)

	tween.tween_property(eclipse, "position:x", 600, 0.0)

	tween.tween_property(eclipse, "scale:x", -1.0, eclipse_time).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(eclipse, "scale:y", 1.0, eclipse_time).set_ease(Tween.EASE_OUT)
	tween.tween_property(eclipse, "position:x", 0, 0.0)

	tween.tween_property(eclipse, "scale:x", 1.0, 0.0)
	tween.parallel().tween_property(eclipse, "scale:y", 1.0, 0.0)
