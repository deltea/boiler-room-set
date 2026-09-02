class_name DotGenerator extends Node2D


@export var dot_texture: Texture2D
@export var dot_color: Color = Color.BLACK
@export var rows: int = 4
@export var dot_chance: float = 0.5
@export var row_spacing: float = 32.0
@export var dot_speed: float = 50.0
@export var dot_scale: float = 0.08
@export var preprocess_rows: int = 20
@export var row_delay: float = 1.2


func _ready() -> void:
	$Timer.wait_time = row_delay
	for i in range(preprocess_rows):
		create_row(i * dot_speed * row_delay)


func create_row(y_pos: float) -> void:
	var timer := get_tree().create_timer(25.0)
	for i in range(rows):
		if (randf() > dot_chance): continue

		var dot := Sprite2D.new()
		add_child(dot)
		dot.texture = dot_texture
		dot.self_modulate = dot_color
		dot.scale = Vector2.ONE * dot_scale
		dot.position.x = i * row_spacing
		dot.position.y = y_pos
		timer.timeout.connect(dot.queue_free)


func _on_timer_timeout() -> void:
	create_row(0.0)

	var tween := create_tween().set_parallel().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	for d in get_children():
		if not is_instance_valid(d) or not d is Sprite2D: continue
		# d.position.y += dot_speed * dt
		tween.tween_property(d, "position:y", dot_speed * row_delay, 0.3).as_relative()
