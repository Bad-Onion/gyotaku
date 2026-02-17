class_name PlayerFishingInput
extends Node


var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2.ZERO
var current_drag_vector: Vector2 = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
    # TODO: Create a custom input action for fishing and use it instead of hardcoding mouse button checks
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_start_position = event.position
		else:
			is_dragging = false
			current_drag_vector = Vector2.ZERO

	elif event is InputEventMouseMotion and is_dragging:
		current_drag_vector = event.position - drag_start_position


func get_drag_vector() -> Vector2:
	return current_drag_vector


func is_active() -> bool:
	return is_dragging
