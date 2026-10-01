class_name Queue extends ColorRect


const track_scene = preload("res://scenes/queue_track/queue_track.tscn")


@onready var container: VBoxContainer = $VBoxContainer
@onready var selector: Panel = $Selector


var tracks: Array[TrackResource] = []
var separation: float = 49.0
var original_container_y: float = 0.0


func _ready() -> void:
	original_container_y = container.position.y

	var original_selector_size := selector.size.x
	var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_loops()
	tween.tween_property(selector, "size:x", original_selector_size + 32, 0)
	tween.tween_property(selector, "size:x", original_selector_size, 0.5)
	tween.tween_interval(0.5)


func set_index(new_idx: int) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var target_y := original_container_y - (separation * new_idx)
	tween.tween_property(container, "position:y", target_y, 1.0)

	await Clock.wait(0.1)
	if container.get_child(new_idx - 1) != null:
		(container.get_child(new_idx - 1) as Label).add_theme_color_override("font_color", Color(0.57, 0.57, 0.57))
	(container.get_child(new_idx) as Label).add_theme_color_override("font_color", Color("#f6f6f6"))


func create_tracks(new_tracks: Array[TrackResource]) -> void:
	tracks = new_tracks
	# use index
	for t in tracks:
		var track := track_scene.instantiate() as Label
		track.text = t.name
		container.add_child(track)
