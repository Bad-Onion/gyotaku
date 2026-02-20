class_name FishMovement
extends Node

@export var movement_config: FishMovementConfig


class FishBounds:
	var rect: Rect2
	var spawn_y: float

	func _init(p_rect: Rect2, p_spawn_y: float) -> void:
		rect = p_rect
		spawn_y = p_spawn_y


class MovementResult:
	var velocity: Vector2
	var direction: int

	func _init(p_velocity: Vector2, p_direction: int) -> void:
		velocity = p_velocity
		direction = p_direction


var bounds: FishBounds
var _time_offset: float
var _swim_frequency: float
var _vertical_frequency: float


func _ready() -> void:
	_time_offset = randf() * 1000.0
	_swim_frequency = randf_range(0.001, 0.003)
	_vertical_frequency = randf_range(0.001, 0.002)


func set_bounds(new_bounds: FishBounds) -> void:
	bounds = new_bounds


func calculate_velocity(current_posistion: Vector2, current_velocity: Vector2, target: Node2D, current_direction: int, delta: float) -> MovementResult:
	var target_velocity := Vector2.ZERO
	var new_direction := current_direction

	if target:
		var direction = current_posistion.direction_to(target.global_position)

		target_velocity = direction * movement_config.chase_speed
		new_direction = 1 if direction.x > 0 else -1
	else:
		if current_posistion.x <= bounds.rect.position.x:
			new_direction = 1
		elif current_posistion.x >= bounds.rect.end.x:
			new_direction = -1

		var speed_variation = 1.0 + sin(Time.get_ticks_msec() * _swim_frequency + _time_offset) * 0.2
		target_velocity.x = new_direction * movement_config.base_speed * speed_variation

		var y_wave = sin(Time.get_ticks_msec() * _vertical_frequency + _time_offset) * movement_config.wander_radius_y
		var target_y = clampf(bounds.spawn_y + y_wave, bounds.rect.position.y, bounds.rect.end.y)
		var dir_y = (target_y - current_posistion.y)
		target_velocity.y = dir_y * 2.0

	var final_velocity = current_velocity.lerp(target_velocity, 5.0 * delta)
	return MovementResult.new(final_velocity, new_direction)


func find_target(current_position: Vector2, current_target: Node2D) -> Node2D:
	if current_target and not current_target.is_in_group(NodeGroups.BAIT_GROUP):
		return null

	if not current_target:
		var baits = get_tree().get_nodes_in_group(NodeGroups.BAIT_GROUP)

		for bait in baits:
			if current_position.distance_to(bait.global_position) < movement_config.detection_radius:
				return bait as Node2D

		return null

	if current_target and current_position.distance_to(current_target.global_position) > movement_config.detection_radius * 1.5:
		return null

	return current_target


func move(current_velocity_x: float, force_x: float, delta: float) -> float:
	return move_toward(current_velocity_x, force_x, movement_config.force_smoothness * delta)
