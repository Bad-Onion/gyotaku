extends CanvasLayer

const cursor = preload("uid://b1a51irwxqr5k")

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
