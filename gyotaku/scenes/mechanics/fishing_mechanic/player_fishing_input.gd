class_name PlayerFishingInput
extends Node


@export var cursor_smoothness: float = 12.0
@export var max_drag_distance: float = 250.0

var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2.ZERO
var _raw_drag_vector: Vector2 = Vector2.ZERO
var _actual_drag_vector: Vector2 = Vector2.ZERO
var _resistance_vector: Vector2 = Vector2.ZERO
var _stiffness: float = 1.0


func apply_resistance(directional_pull: Vector2, stiffness: float = 1.0) -> void:
	_resistance_vector = directional_pull
	_stiffness = maxf(1.0, stiffness)


func _physics_process(delta: float) -> void:
	if is_dragging:
		var dampened_drag := _raw_drag_vector / _stiffness
		var target_vector := dampened_drag + _resistance_vector

		if target_vector.length() > max_drag_distance:
			target_vector = target_vector.limit_length(max_drag_distance)

		_actual_drag_vector = _actual_drag_vector.lerp(target_vector, cursor_smoothness * delta)
	else:
		_actual_drag_vector = Vector2.ZERO
		_resistance_vector = Vector2.ZERO
		_stiffness = 1.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.FISHING_DRAG):
		is_dragging = true
		drag_start_position = event.position
		_raw_drag_vector = Vector2.ZERO
		_actual_drag_vector = Vector2.ZERO
	elif event.is_action_released(InputActions.FISHING_DRAG):
		is_dragging = false
		_raw_drag_vector = Vector2.ZERO
		_actual_drag_vector = Vector2.ZERO
	elif event is InputEventMouseMotion and is_dragging:
		_raw_drag_vector = event.position - drag_start_position


func is_active() -> bool:
	return is_dragging


func get_drag_vector() -> Vector2:
	return _actual_drag_vector
