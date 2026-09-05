class_name ScrollingBar extends ColorRect


@onready var scrolling_label_1: Label = $Label1
@onready var scrolling_label_2: Label = $Label2


var scrolling_label_length: float = 0.0
var alt_text: Array[String] = ["", ""]
var curr_idx: int = 0


func set_alt_text(slot: int, text: String) -> void:
	alt_text[slot] = text
	set_label_text(alt_text[curr_idx])


func set_label_text(text: String) -> void:
	scrolling_label_1.text = text
	scrolling_label_2.text = text
	scrolling_label_length = scrolling_label_1.get_combined_minimum_size().x
	scrolling_label_2.position.x = scrolling_label_length


func _on_scrolling_bar_timer_timeout() -> void:
	position.x -= 20.0

	if abs(position.x) > scrolling_label_length:
		position.x = 0


func _on_alt_timer_timeout() -> void:
	curr_idx = (curr_idx + 1) % alt_text.size()
	set_label_text(alt_text[curr_idx])
