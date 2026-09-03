extends Node3D


@export var tracks: Array[TrackResource] = []
@export var start_track_idx: int = 0


@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var cover: Sprite2D = $CanvasLayer/Cover
@onready var title_label: RichTextLabel = $CanvasLayer/Info/VBoxContainer/Title
@onready var artist_label: RichTextLabel = $CanvasLayer/Info/VBoxContainer/Artist

@onready var scrolling_bar: ColorRect = $CanvasLayer/ScrollingBar
@onready var scrolling_label_1: Label = $CanvasLayer/ScrollingBar/Label1
@onready var scrolling_label_2: Label = $CanvasLayer/ScrollingBar/Label2


var curr_track_idx: int = start_track_idx
var player_pos: float = 0.0
var scrolling_label_length: float = 0.0


func _ready() -> void:
	player.play()

	set_curr_track(start_track_idx)


func _process(dt: float) -> void:
	player_pos = player.get_playback_position() + AudioServer.get_time_since_last_mix()
	player_pos -= AudioServer.get_output_latency()


func get_curr_track() -> TrackResource:
	return tracks[curr_track_idx]


func set_curr_track(idx: int) -> void:
	curr_track_idx = idx

	var curr_track := get_curr_track()
	player.seek(curr_track.timestamp.get_seconds())
	title_label.text = "[wave]" + curr_track.name
	artist_label.text = "[wave]// " + curr_track.artist
	cover.texture = curr_track.cover_art

	if idx < tracks.size() - 1:
		var next_track := tracks[curr_track_idx + 1]
		set_scrolling_label("next up: " + next_track.name + " by " + next_track.artist)
	else:
		set_scrolling_label("hope you enjoyed the mix, see you next time!")


func set_scrolling_label(text: String) -> void:
	scrolling_label_1.text = text
	scrolling_label_2.text = text
	scrolling_label_length = scrolling_label_1.get_combined_minimum_size().x
	scrolling_label_2.position.x = scrolling_label_length


func _on_scrolling_bar_timer_timeout() -> void:
	scrolling_bar.position.x -= 20.0

	if abs(scrolling_bar.position.x) > scrolling_label_length:
		scrolling_bar.position.x = 0
