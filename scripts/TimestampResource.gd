class_name TimestampResource extends Resource


@export var minutes: float = 0.0
@export var seconds: float = 0.0


func get_seconds() -> float:
	return minutes * 60.0 + seconds
