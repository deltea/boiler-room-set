extends Node3D


@export var tracks: Array[TrackResource] = []
@export var start_track_idx: int = 0


@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var cover: Sprite2D = $CanvasLayer/Cover
@onready var title_label: RichTextLabel = $CanvasLayer/Info/VBoxContainer/Title
@onready var artist_label: RichTextLabel = $CanvasLayer/Info/VBoxContainer/Artist
@onready var scrolling_bar: ScrollingBar = $CanvasLayer/ScrollingBar


var curr_track_idx: int = start_track_idx
var player_pos: float = 0.0
var timestamps: Array[float] = []


func _ready() -> void:
	player.play()

	generate_timestamps()
	set_curr_track(start_track_idx)


func generate_timestamps() -> void:
	for track in tracks:
		timestamps.append(track.timestamp.get_seconds())
	timestamps.pop_front()


func _process(dt: float) -> void:
	player_pos = player.get_playback_position() + AudioServer.get_time_since_last_mix()
	player_pos -= AudioServer.get_output_latency()

	var next_idx: int = 0
	for i in range(timestamps.size()):
		if player_pos < timestamps[i]:
			break
		next_idx += 1

	if next_idx > curr_track_idx:
		set_curr_track(next_idx)


func get_curr_track() -> TrackResource:
	return tracks[curr_track_idx]


func set_curr_track(idx: int) -> void:
	curr_track_idx = idx

	var curr_track := get_curr_track()
	title_label.text = "[wave]" + curr_track.name
	artist_label.text = "[wave]// " + curr_track.artist
	cover.change_texture(curr_track.cover_art)

	scrolling_bar.set_alt_text(1, "now playing: " + curr_track.name + " by " + curr_track.artist)
	if idx < tracks.size() - 1:
		var next_track := tracks[curr_track_idx + 1]
		scrolling_bar.set_alt_text(0, "next up: " + next_track.name + " by " + next_track.artist)
	else:
		scrolling_bar.set_alt_text(0, "hope you enjoyed the mix, see you next time!")


func seek_to_track(track_idx: int, offset: float = 0.0) -> void:
	player.seek(tracks[track_idx].timestamp.get_seconds() + offset)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		player.seek(player_pos - 10)
	if event.is_action_pressed("right"):
		player.seek(player_pos + 10)
	if event.is_action_pressed("space"):
		var target_scale := 2.0 if player.pitch_scale == 1.0 else 1.0
		var tween := create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(player, "pitch_scale", target_scale, 0.5)


func _on_audio_stream_player_finished() -> void:
	print("done!!!")
