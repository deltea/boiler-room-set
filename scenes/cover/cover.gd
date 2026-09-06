class_name Cover extends Sprite2D


@export var shadow_offset: float = 40.0
@export var pull_back_angle: float = 20.0


@onready var shadow: Sprite2D = $Shadow


var original_pos: Vector2
var rot_offset: float = 0.0


func _ready() -> void:
	original_pos = position

	shadow.show()

	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).set_loops()
	tween.tween_interval(0.8)
	tween.tween_property(self, "rot_offset", -pull_back_angle, 1.0).as_relative().set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "rot_offset", 360 + pull_back_angle, 2.0).as_relative()
	tween.tween_interval(14.0)


func _process(dt: float) -> void:
	rotation_degrees = sin(Clock.time * 1.0) * 4.0 + rot_offset
	position.y = original_pos.y + cos(Clock.time * 0.9) * 10.0

	shadow.position = position + Vector2.ONE * shadow_offset
	shadow.rotation = rotation


func change_texture(new_texture: Texture2D) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR)
	if texture != new_texture:
		tween.tween_property(material, "shader_parameter/pixel_size", 70, 0.5)
		tween.tween_callback(func() -> void: texture = new_texture)
	else:
		tween.tween_property(material, "shader_parameter/pixel_size", 70, 0.0)
	tween.tween_property(material, "shader_parameter/pixel_size", 4, 0.5)
