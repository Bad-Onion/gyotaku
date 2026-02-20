class_name PlayerFishingInput
extends Node


var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2.ZERO
var current_drag_vector: Vector2 = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.FISHING_DRAG):
		is_dragging = true
		drag_start_position = event.position
	elif event.is_action_released(InputActions.FISHING_DRAG):
		is_dragging = false
		current_drag_vector = Vector2.ZERO
	elif event is InputEventMouseMotion and is_dragging:
		current_drag_vector = event.position - drag_start_position


func get_drag_vector() -> Vector2:
	return current_drag_vector


func is_active() -> bool:
	return is_dragging
