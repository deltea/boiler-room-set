class_name WaveformVisualizer extends Node2D


@export var band_width: float = 4
@export var band_color: Color = Color.GRAY
@export var band_count: int = 100
@export var min_band_length: float = 8
@export var max_band_length: float = 640
@export var min_hz: float = 500.0
@export var max_hz: float = 2800.0
@export var freq_offset: int = 0

@export var height: float = 720
@export var x_padding: float = 0
@export var dir: float = -1.0


var spectrum: AudioEffectSpectrumAnalyzerInstance
var bands: Array[Line2D] = []


func _ready() -> void:
	var bus_idx := AudioServer.get_bus_index("Master")
	spectrum = AudioServer.get_bus_effect_instance(bus_idx, 0)

	for i in range(band_count):
		var line := Line2D.new()
		add_child(line)
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		line.width = band_width
		line.default_color = band_color
		line.add_point(Vector2(0, 0))
		line.add_point(Vector2(0, 0))
		bands.append(line)


func _process(dt: float) -> void:
	# evenly spread bands out
	var step := height / (band_count + 1)
	for i in range(band_count):

		# get magnitude at specific frequency
		var t0 := float(i + freq_offset) / band_count
		var t1 := float(i + freq_offset + 1) / band_count
		var prev_hz := min_hz + pow(t0, 2.5) * (max_hz - min_hz)
		var hz := min_hz + pow(t1, 2.5) * (max_hz - min_hz)
		var mag := spectrum.get_magnitude_for_frequency_range(prev_hz, hz)

		# var energy =
		var x_pos := (mag.length()) * (max_band_length - min_band_length) + min_band_length
		var y_pos := (i + 1) * step

		bands[i].set_point_position(0, Vector2(x_padding, y_pos))
		bands[i].set_point_position(1, Vector2(x_padding - x_pos, y_pos))
