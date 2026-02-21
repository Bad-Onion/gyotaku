extends CanvasLayer

const cursor = preload("uid://coru6fhwvtq6i")

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(0,0))
