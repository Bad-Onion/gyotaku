class_name PlayerFishingInput
extends Node


@export var cursor_smoothness: float = 12.0
@export var max_drag_distance: float = 250.0
@export var screen_margin: float = 25.0

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
		_constrain_cursor_to_screen()

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


func _constrain_cursor_to_screen() -> void:
	var viewport: Viewport = get_viewport()
	var mouse_position: Vector2 = viewport.get_mouse_position()

	var safe_rect: Rect2 = viewport.get_visible_rect().grow(-screen_margin)

	if not safe_rect.has_point(mouse_position):
		var clamped_x: float = clampf(mouse_position.x, safe_rect.position.x, safe_rect.end.x)
		var clamped_y: float = clampf(mouse_position.y, safe_rect.position.y, safe_rect.end.y)

		viewport.warp_mouse(Vector2(clamped_x, clamped_y))
