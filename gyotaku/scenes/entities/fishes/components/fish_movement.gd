class_name FishMovement
extends Node

@export var movement_config: FishMovementConfig


enum SwimState { BURST, COAST }

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
var _current_state: SwimState = SwimState.BURST
var _state_timer: float = 0.0
var _target_y: float = 0.0
var _bait_ignore_timer: float = 0.0
var _potential_bait: Node2D = null
var _reaction_timer: float = 0.0


func set_bounds(new_bounds: FishBounds) -> void:
	bounds = new_bounds
	_target_y = bounds.spawn_y


func calculate_velocity(current_position: Vector2, current_velocity: Vector2, target: Node2D, current_direction: int, delta: float) -> MovementResult:
	var target_velocity := Vector2.ZERO
	var new_direction := current_direction

	if target:
		var direction = current_position.direction_to(target.global_position)
		target_velocity = direction * movement_config.chase_speed
		new_direction = 1 if direction.x > 0 else -1

		var final_current_velocity = current_velocity.lerp(target_velocity, 5.0 * delta)
		return MovementResult.new(final_current_velocity, new_direction)

	# --- Organic Wander Logic (Burst and Coast) ---
	_state_timer -= delta

	# 1. Handle Bounds Reversal
	if current_position.x <= bounds.rect.position.x:
		new_direction = 1
	elif current_position.x >= bounds.rect.end.x:
		new_direction = -1

	# 2. Handle State Transitions
	if _state_timer <= 0.0:
		if _current_state == SwimState.BURST:
			_current_state = SwimState.COAST
			_state_timer = randf_range(movement_config.min_pause_time, movement_config.max_pause_time)

			# Chance to flip direction during coasting for erratic behavior
			if randf() > 0.7:
				new_direction *= -1
		else:
			_current_state = SwimState.BURST
			_state_timer = randf_range(movement_config.min_burst_time, movement_config.max_burst_time)

			# Pick a new Y target within bounds for the next burst
			_target_y = clampf(bounds.spawn_y + randf_range(-movement_config.wander_radius_y, movement_config.wander_radius_y), bounds.rect.position.y, bounds.rect.end.y)

	# 3. Apply State Velocities
	if _current_state == SwimState.BURST:
		target_velocity.x = new_direction * movement_config.base_speed * movement_config.burst_speed_multiplier

		var distance_to_y = _target_y - current_position.y
		if absf(distance_to_y) > 5.0:
			target_velocity.y = signf(distance_to_y) * (movement_config.base_speed * 0.5)
		else:
			target_velocity.y = 0.0
	else: # COAST
		target_velocity.x = new_direction * movement_config.base_speed * 0.2 # Slow glide
		target_velocity.y = 0.0 # Maintain current depth while coasting

	# Lower lerp weight during coast to simulate gliding momentum
	var lerp_weight = 4.0 if _current_state == SwimState.BURST else 1.5
	var final_velocity = current_velocity.lerp(target_velocity, lerp_weight * delta)

	return MovementResult.new(final_velocity, new_direction)


func find_target(fish: Fish, current_target: Node2D, delta: float) -> Node2D:
	if current_target and not current_target.is_in_group(NodeGroups.BAIT_GROUP):
		return null

	if _bait_ignore_timer > 0.0:
		_bait_ignore_timer -= delta
		return null # Completely ignore baits while the timer is active

	if not current_target:
		var baits = get_tree().get_nodes_in_group(NodeGroups.BAIT_GROUP)
		var found_bait: Node2D = null

		# Find the first bait currently in detection range
		for bait in baits:
			if fish.global_position.distance_to(bait.global_position) < movement_config.detection_radius:
				found_bait = bait
				break

		if found_bait:
			if _potential_bait != found_bait:
				# Fish just noticed the bait, start observing
				_potential_bait = found_bait
				_reaction_timer = randf_range(movement_config.reaction_time_min, movement_config.reaction_time_max)
			else:
				# Fish is observing the bait
				_reaction_timer -= delta
				if _reaction_timer <= 0.0:
					# Observation complete, make the decision roll
					if randf() <= movement_config.bait_interest_chance:
						if found_bait.request_interest(fish):
							_potential_bait = null
							return found_bait as Node2D
					else:
						# Decided to ignore
						_bait_ignore_timer = movement_config.bait_ignore_duration
						_potential_bait = null
		else:
			# Bait left the radius before the fish could react
			_potential_bait = null

		return null

	# If the fish has a target but swims too far away, release it and the slot
	if current_target and fish.global_position.distance_to(current_target.global_position) > movement_config.detection_radius * 1.5:
		if current_target.has_method("remove_interest"):
			current_target.remove_interest(fish)
		return null

	return current_target


func move(current_velocity_x: float, force_x: float, delta: float) -> float:
	return move_toward(current_velocity_x, force_x, movement_config.force_smoothness * delta)
