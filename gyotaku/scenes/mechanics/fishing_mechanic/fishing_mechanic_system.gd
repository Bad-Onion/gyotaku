class_name FishingMechanicSystem
extends Node


signal fish_caught
signal fish_escaped
signal line_broke

@export_group("Dependencies")
@export var input_system: PlayerFishingInput
@export var center_point: Marker2D

@export_group("Zones & Depth")
@export var safe_zone_radius: float = 30.0
@export var danger_zone_radius: float = 120.0
@export var max_depth: float = 100.0
@export var depth_pull_up_speed: float = 20.0
@export var depth_sink_slow_speed: float = 5.0
@export var depth_sink_fast_speed: float = 30.0

@export_group("Tension")
@export var max_tension: float = 100.0
@export var tension_increase_multiplier: float = 0.5
@export var tension_recovery_rate: float = 40.0
@export var critical_tension_threshold: float = 90.0
@export var impulse_penalty_force: float = 100.0
@export var player_pull_power: float = 1.5
@export var fish_struggle_power: float = 60.0
@export var sweet_spot_min: float = 30.0
@export var sweet_spot_max: float = 70.0

@export_group("Visual Mapping")
@export var surface_y: float = 190.0
@export var bottom_y: float = 340.0

var fish: Fish
var current_tension: float = 0.0
var current_depth: float = 50.0
var was_dragging_last_frame: bool = false


func _ready() -> void:
	set_physics_process(false) # System is idle until a fish bites


func start_minigame(hooked_fish: Fish) -> void:
	fish = hooked_fish
	current_tension = 0.0
	current_depth = 50.0
	fish.velocity.x = fish_struggle_power * fish.movement_direction
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	if not fish or not input_system:
		return

	_process_tug_of_war(delta)
	_process_tension(delta)
	_process_depth(delta)
	# _debug_logs()
	_check_end_conditions()


func _process_tension(delta: float) -> void:
	var drag_vector := input_system.get_drag_vector()
	var is_dragging := input_system.is_active()

	if is_dragging:
		var drag_direction := signf(drag_vector.x)

		# Verifica se está arrastando na direção oposta ao peixe
		if drag_direction != 0 and drag_direction != fish.movement_direction:
			var pull_force := absf(drag_vector.x) * tension_increase_multiplier
			current_tension += pull_force * delta
	else:
		# Recupera a tensão quando não está puxando
		current_tension -= tension_recovery_rate * delta

		# Regra: Se a linha quase quebrar e o jogador largar, o peixe ganha impulso
		if was_dragging_last_frame and current_tension >= critical_tension_threshold:
			_apply_escape_impulse()

	current_tension = clampf(current_tension, 0.0, max_tension)
	was_dragging_last_frame = is_dragging


func _process_depth(delta: float) -> void:
	var distance_from_center := absf(fish.global_position.x - center_point.global_position.x)

	var is_tension_good: bool = current_tension >= sweet_spot_min and current_tension <= sweet_spot_max

	if distance_from_center <= safe_zone_radius and is_tension_good:
		current_depth -= depth_pull_up_speed * delta # Sobe
	elif distance_from_center <= danger_zone_radius:
		current_depth += depth_sink_slow_speed * delta # Desce lentamente
	else:
		current_depth += depth_sink_fast_speed * delta # Desce rápido

	current_depth = clampf(current_depth, 0.0, max_depth)
	fish.global_position.y = remap(current_depth, 0.0, max_depth, surface_y, bottom_y)


func _apply_escape_impulse() -> void:
	# O peixe foge na direção em que estava a ser puxado (ganha a inércia da linha)
	var escape_direction := signf(input_system.get_drag_vector().x)
	fish.apply_impulse(escape_direction * impulse_penalty_force)


func _check_end_conditions() -> void:
	if current_tension >= max_tension:
		line_broke.emit()
		set_physics_process(false)

	elif current_depth <= 0:
		fish_caught.emit()
		set_physics_process(false)

	elif current_depth >= max_depth:
		fish_escaped.emit()
		set_physics_process(false)


func _process_tug_of_war(delta: float) -> void:
	var drag_vector := input_system.get_drag_vector()
	var is_dragging := input_system.is_active()

	var desired_fish_velocity := fish.movement_direction * fish_struggle_power
	var player_velocity := 0.0

	if is_dragging:
		var drag_dir := signf(drag_vector.x)
		# The player only applies force if dragging opposite to the fish's desire
		if drag_dir != 0.0 and drag_dir != fish.movement_direction:
			player_velocity = drag_vector.x * player_pull_power

	var net_velocity := desired_fish_velocity + player_velocity
	fish.velocity.x = move_toward(fish.velocity.x, net_velocity, 400.0 * delta)

	# TODO: Move this visual update to the Fish class, maybe via a signal or direct method call
	if fish.velocity.x != 0 and fish.sprite:
		var current_physical_dir = signf(fish.velocity.x)
		fish.sprite.flip_h = (current_physical_dir < 0)


func _debug_logs() -> void:
	var dist = absf(fish.global_position.x - center_point.global_position.x)
	print("Depth: %3.1f | Tension: %3.1f | Center Dist: %3.1f" % [current_depth, current_tension, dist])
