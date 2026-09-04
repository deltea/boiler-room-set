class_name ChannelDisplay extends HBoxContainer


@export var min_hz: float = 120.0
@export var max_hz: float = 2800.0


@onready var left_channel: ColorRect = $LeftBackground/ColorRect
@onready var right_channel: ColorRect = $RightBackground/ColorRect


var spectrum: AudioEffectSpectrumAnalyzerInstance


func _ready() -> void:
	var bus_idx := AudioServer.get_bus_index("Master")
	spectrum = AudioServer.get_bus_effect_instance(bus_idx, 0)


func _process(dt: float) -> void:
	var mag := spectrum.get_magnitude_for_frequency_range(min_hz, max_hz)
	left_channel.scale = left_channel.scale.lerp(clampf(mag.x * 8, 0, 1) * Vector2.ONE, 30 * dt)
	right_channel.scale = right_channel.scale.lerp(clampf(mag.y * 8, 0, 1) * Vector2.ONE, 30 * dt)
