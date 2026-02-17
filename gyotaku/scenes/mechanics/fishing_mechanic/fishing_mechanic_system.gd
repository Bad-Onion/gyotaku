class_name FishingMechanicSystem
extends Node


signal fish_caught
signal fish_escaped
signal line_broke

@export_group("Dependencies")
@export var input_system: PlayerFishingInput
@export var center_point: Marker2D

@export_group("Zones & Depth")
@export var safe_zone_radius: float = 15.0
@export var danger_zone_radius: float = 60.0
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
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	if not fish or not input_system:
		return

	_process_tension(delta)
	_process_depth(delta)
	_check_end_conditions()


func _process_tension(delta: float) -> void:
	var drag_vector := input_system.get_drag_vector()
	var is_dragging := input_system.is_active()

	if is_dragging:
		var drag_direction := signf(drag_vector.x)
		var fish_direction := signf(fish.velocity.x)

		# Verifica se está a arrastar na direção oposta ao peixe
		if drag_direction != 0 and drag_direction != fish_direction:
			var pull_force := absf(drag_vector.x) * tension_increase_multiplier
			current_tension += pull_force * delta
	else:
		# Recupera a tensão quando não está a puxar
		current_tension -= tension_recovery_rate * delta

		# Regra: Se a linha quase quebrar e o jogador largar, o peixe ganha impulso
		if was_dragging_last_frame and current_tension >= critical_tension_threshold:
			_apply_escape_impulse()

	current_tension = clamp(current_tension, 0.0, max_tension)
	was_dragging_last_frame = is_dragging


func _process_depth(delta: float) -> void:
	var distance_from_center := absf(fish.global_position.x - center_point.global_position.x)

	if distance_from_center <= safe_zone_radius:
		current_depth -= depth_pull_up_speed * delta # Sobe
	elif distance_from_center <= danger_zone_radius:
		current_depth += depth_sink_slow_speed * delta # Desce lentamente
	else:
		current_depth += depth_sink_fast_speed * delta # Desce rápido


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
