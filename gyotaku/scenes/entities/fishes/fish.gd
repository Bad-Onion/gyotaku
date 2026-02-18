class_name Fish
extends CharacterBody2D


@export_group("Movement Settings")
@export var base_speed: float = 50.0
@export var chase_speed: float = 85.0
@export var wander_radius_y: float = 40.0 # O quanto ele pode subir/descer do ponto de spawn
@export var detection_radius: float = 70.0 # Distância para ver o anzol

@onready var sprite: AnimatedSprite2D = %FishSprite

var min_x_bound: float
var max_x_bound: float
var min_y_bound: float
var max_y_bound: float

var is_hooked: bool = false
var spawn_y: float = 0.0
var current_target: Node2D = null # O anzol, se detetado
var movement_direction: int = 1

var time_offset: float
var swim_frequency: float
var vertical_frequency: float


func _ready() -> void:
	time_offset = randf() * 1000.0 # Aleatoriedade inicial
	swim_frequency = randf_range(0.001, 0.003)
	vertical_frequency = randf_range(0.001, 0.002)


func set_bounds(min_x: float, max_x: float, min_y: float, max_y: float) -> void:
	min_x_bound = min_x
	max_x_bound = max_x
	min_y_bound = min_y
	max_y_bound = max_y
	spawn_y = global_position.y


func hook() -> void:
	is_hooked = true
	velocity = Vector2.ZERO
	rotation = 0


func _physics_process(delta: float) -> void:
	if is_hooked:
		rotation = lerp_angle(rotation, 0.0, 5.0 * delta)
		move_and_slide()
		return

	_behavior_wander_and_chase(delta)
	move_and_slide()
	_handle_sprite_visuals(delta)


func _behavior_wander_and_chase(delta: float) -> void:
	# TODO: Poderíamos otimizar isso usando um sistema de sinalização ou área de detecção, mas para simplicidade, vamos varrer os isos do grupo "bait"
	# TODO: Replace hardcoded "bait" group with a configurable export var bait_group: String = "bait"
	if current_target and not current_target.is_in_group("bait"):
		current_target = null

	# 2. Look for bait if we don't have one
	if not current_target:
		# TODO: Replace hardcoded "bait" group with a configurable export var bait_group: String = "bait"
		var baits = get_tree().get_nodes_in_group("bait")
		if baits.size() > 0:
			var potential_bait = baits[0] as Node2D
			if global_position.distance_to(potential_bait.global_position) < detection_radius:
				current_target = potential_bait

	# 3. Release target if too far
	if current_target:
		var dist = global_position.distance_to(current_target.global_position)
		if dist > detection_radius * 1.5:
			current_target = null

	var target_velocity = Vector2.ZERO

	if current_target:
		# --- CHASE MODE ---
		var direction = global_position.direction_to(current_target.global_position)
		target_velocity = direction * chase_speed
		movement_direction = 1 if direction.x > 0 else -1
	else:
		# --- WANDER MODE ---
		if global_position.x <= min_x_bound:
			movement_direction = 1
		elif global_position.x >= max_x_bound:
			movement_direction = -1

		# Uses unique frequencies for randomness
		var speed_var = 1.0 + sin(Time.get_ticks_msec() * swim_frequency + time_offset) * 0.2
		target_velocity.x = movement_direction * base_speed * speed_var

		var y_wave = sin(Time.get_ticks_msec() * vertical_frequency + time_offset) * wander_radius_y
		var target_y = spawn_y + y_wave
		target_y = clampf(target_y, min_y_bound, max_y_bound)

		var dir_y = (target_y - global_position.y)
		target_velocity.y = dir_y * 2.0

	velocity = velocity.lerp(target_velocity, 5.0 * delta)


func _handle_sprite_visuals(delta: float) -> void:
	if not sprite: return

	# Flip H
	if abs(velocity.x) > 1.0:
		sprite.flip_h = velocity.x > 0

	# Rotation
	var target_angle = 0.0
	if abs(velocity.x) > 1.0:
		var slope = velocity.y / abs(velocity.x)
		target_angle = clamp(slope, -0.6, 0.6)

		# INVERTED logic based on your feedback
		# If flipped (facing left), we need to invert the angle calculation for it to look right
		if sprite.flip_h:
			target_angle *= 1.0 # Changed from -1 to 1 based on observation
		else:
			target_angle *= 1.0

		# NOTE: If it's still wrong, swap the sign below manually:
		# target_angle = -target_angle

	rotation = lerp_angle(rotation, target_angle, 8.0 * delta)


func apply_impulse(force_x: float) -> void:
	velocity.x += force_x
	if velocity.x != 0:
		movement_direction = int(sign(velocity.x))
