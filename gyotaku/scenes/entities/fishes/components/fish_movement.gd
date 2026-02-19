class_name FishMovement
extends Node


@export var base_speed: float = 50.0
@export var chase_speed: float = 85.0
@export var wander_radius_y: float = 40.0
@export var detection_radius: float = 70.0

# TODO: Use a single variable for all x and y bounds
var min_x_bound: float
var max_x_bound: float
var min_y_bound: float
var max_y_bound: float
var spawn_y: float = 0.0

var _time_offset: float
var _swim_frequency: float
var _vertical_frequency: float


func _ready() -> void:
	_time_offset = randf() * 1000.0
	_swim_frequency = randf_range(0.001, 0.003)
	_vertical_frequency = randf_range(0.001, 0.002)


func set_bounds(min_x: float, max_x: float, min_y: float, max_y: float, current_y: float) -> void:
	min_x_bound = min_x
	max_x_bound = max_x
	min_y_bound = min_y
	max_y_bound = max_y
	spawn_y = current_y

# TODO: Refactor to return a struct or class instead of a dictionary for better type safety
func calculate_velocity(current_posistion: Vector2, current_velocity: Vector2, target: Node2D, current_direction: int, delta: float) -> Dictionary:
	var target_velocity := Vector2.ZERO
	var new_direction := current_direction

	if target:
		var direction = current_posistion.direction_to(target.global_position)

		target_velocity = direction * chase_speed
		new_direction = 1 if direction.x > 0 else -1
	else:
		if current_posistion.x <= min_x_bound:
			new_direction = 1
		elif current_posistion.x >= max_x_bound:
			new_direction = -1

		var speed_var = 1.0 + sin(Time.get_ticks_msec() * _swim_frequency + _time_offset) * 0.2
		target_velocity.x = new_direction * base_speed * speed_var

		var y_wave = sin(Time.get_ticks_msec() * _vertical_frequency + _time_offset) * wander_radius_y
		var target_y = clampf(spawn_y + y_wave, min_y_bound, max_y_bound)
		var dir_y = (target_y - current_posistion.y)
		target_velocity.y = dir_y * 2.0

	return {
		"velocity": current_velocity.lerp(target_velocity, 5.0 * delta),
		"direction": new_direction
	}


func find_target(current_pos: Vector2, current_target: Node2D) -> Node2D:
	if current_target and not current_target.is_in_group("bait"):
		return null

	if not current_target:
		var baits = get_tree().get_nodes_in_group("bait")
		if baits.size() > 0:
			var potential_bait = baits[0] as Node2D
			if current_pos.distance_to(potential_bait.global_position) < detection_radius:
				return potential_bait
		return null

	if current_target and current_pos.distance_to(current_target.global_position) > detection_radius * 1.5:
		return null

	return current_target
