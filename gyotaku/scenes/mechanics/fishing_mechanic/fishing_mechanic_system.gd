class_name FishingMechanicSystem
extends Node


signal fish_caught
signal fish_escaped
signal line_broke
signal tension_updated(current: float, max_val: float)
signal depth_updated(current: float, max_val: float)

@export_group("Dependencies")
@export var input_system: PlayerFishingInput
@export var center_point: Marker2D
@export var default_config: FishingConfig # Default difficulty if the fish doesn't have one

var _fish: Fish
var _current_config: FishingConfig
var _current_tension: float = 0.0
var _current_depth: float = 50.0
var _was_dragging_last_frame: bool = false
var _is_minigame_active: bool = false


func _ready() -> void:
	set_physics_process(false) # System is idle until a fish bites


func start_minigame(hooked_fish: Fish) -> void:
	_fish = hooked_fish
	_assign_dificulty_config()
	_reset_state()

	# Apply initial struggle velocity
	if _fish:
		_fish.velocity.x = _get_fish_struggle_velocity()

	_set_minigame_active(true)


func get_hooked_fish() -> Fish:
	return _fish


func _physics_process(delta: float) -> void:
	if not _is_minigame_active or not _fish or not input_system:
		return

	_handle_tug_of_war_physics(delta)
	_calculate_tension(delta)
	_calculate_depth(delta)
	_check_end_conditions()


# --- Core Mechanics ---
func _handle_tug_of_war_physics(delta: float) -> void:
	var player_pull_velocity = _get_player_pull_velocity()
	var fish_target_velocity = _get_fish_struggle_velocity() + player_pull_velocity

	# TODO: Create a method like _fish.apply_external_force(velocity) to encapsulate this logic inside the Fish class
	_fish.velocity.x = move_toward(_fish.velocity.x, fish_target_velocity, 400.0 * delta)

	if _fish.velocity.x != 0: _fish.update_facing_direction(signf(_fish.velocity.x))


func _calculate_tension(delta: float) -> void:
	var pull_velocity = _get_player_pull_velocity()
	var is_pulling_effectively = pull_velocity != 0.0

	if is_pulling_effectively:
		var pull_intensity = absf(pull_velocity)
		_current_tension += pull_intensity * _current_config.tension_increase_multiplier * delta
	else:
		# Player let go or is not pulling effectively -> Recover Tension
		_current_tension -= _current_config.tension_recovery_rate * delta

		# Fish dashes if player lets go at critical tension
		if _was_dragging_last_frame and _current_tension >= _current_config.critical_tension_threshold:
			_apply_escape_impulse()

	_current_tension = clampf(_current_tension, 0.0, _current_config.max_tension)
	_was_dragging_last_frame = input_system.is_active()

	tension_updated.emit(_current_tension, _current_config.max_tension)


func _calculate_depth(delta: float) -> void:
	if _get_fish_distance_from_center() <= _current_config.safe_zone_radius and (_is_tension_in_sweet_spot() or _is_fish_centered()):
		_current_depth -= _current_config.depth_pull_up_speed * delta # Pull up faster if fish is centered
	elif _get_fish_distance_from_center() <= _current_config.danger_zone_radius:
		_current_depth += _current_config.depth_sink_slow_speed * delta # Sink slower if fish is in the danger zone (but not too far)
	else:
		_current_depth += _current_config.depth_sink_fast_speed * delta # Sink faster if fish is too far from center

	_current_depth = clampf(_current_depth, 0.0, _current_config.max_depth)

	# TODO: Create a method like _fish.set_vertical_position(y) to encapsulate this logic inside the Fish class
	var new_vertical_position = remap(_current_depth, 0.0, _current_config.max_depth, _current_config.surface_y, _current_config.bottom_y)
	_fish.global_position.y = new_vertical_position

	depth_updated.emit(_current_depth, _current_config.max_depth)


# --- Helpers ---
func _is_tension_in_sweet_spot() -> bool:
	return _current_tension >= _current_config.sweet_spot_min and _current_tension <= _current_config.sweet_spot_max


func _apply_escape_impulse() -> void:
	var escape_direction := signf(input_system.get_drag_vector().x)

	_fish.apply_impulse(escape_direction * _current_config.impulse_penalty_force)


func _reset_state() -> void:
	_current_tension = 0.0
	_current_depth = 50.0
	_was_dragging_last_frame = false


func _check_end_conditions() -> void:
	if _current_tension >= _current_config.max_tension:
		line_broke.emit()
		_end_game()
	elif _current_depth <= 0:
		fish_caught.emit()
		_end_game()
	elif _current_depth >= _current_config.max_depth:
		fish_escaped.emit()
		_end_game()


func _end_game() -> void:
	_set_minigame_active(false)
	_fish = null


func _set_minigame_active(active: bool) -> void:
	_is_minigame_active = active
	set_physics_process(active)


func _assign_dificulty_config() -> void:
	# TODO: Add a way to assign different configs based on fish type
	# For now, we use the system default dificulty config
	_current_config = default_config

	if not _current_config:
		push_error("FishingMechanicSystem: No FishingConfig provided!")
		return


func _get_fish_struggle_velocity() -> float:
	return _current_config.fish_struggle_power * _fish.movement_direction


func _get_player_pull_velocity() -> float:
	if not _is_player_pulling_against_fish():
		return 0.0

	return input_system.get_drag_vector().x * _current_config.player_pull_power


func _is_player_pulling_against_fish() -> bool:
	if not input_system.is_active():
		return false

	var drag_direction := signf(input_system.get_drag_vector().x)
	var fish_direction := _fish.movement_direction

	return drag_direction != 0.0 and drag_direction != fish_direction


func _get_fish_distance_from_center() -> float:
	return absf(_fish.global_position.x - center_point.global_position.x)


func _is_fish_centered() -> bool:
	return _get_fish_distance_from_center() <= _current_config.safe_zone_radius * 0.5
