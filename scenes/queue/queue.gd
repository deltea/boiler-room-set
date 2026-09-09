class_name Queue extends ColorRect


const track_scene = preload("res://scenes/queue_track/queue_track.tscn")


@onready var container: VBoxContainer = $VBoxContainer


var tracks: Array[TrackResource] = []
var separation: float = 49.0
var original_container_y: float = 0.0


func _ready() -> void:
	original_container_y = container.position.y


func set_index(new_idx: int) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var target_y := original_container_y - (separation * new_idx)
	tween.tween_property(container, "position:y", target_y, 1.0)


func create_tracks(new_tracks: Array[TrackResource]) -> void:
	tracks = new_tracks
	# use index
	for t in tracks:
		var track := track_scene.instantiate() as Label
		track.text = t.name
		container.add_child(track)
