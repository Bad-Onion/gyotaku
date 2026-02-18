class_name Fish
extends CharacterBody2D


@export_group("Movement Settings")
@export var base_speed: float = 50.0
@export var chase_speed: float = 85.0
@export var wander_radius_y: float = 40.0 # O quanto ele pode subir/descer do ponto de spawn
@export var detection_radius: float = 150.0 # Distância para ver o anzol

@onready var sprite: AnimatedSprite2D = %FishSprite

var min_x_bound: float
var max_x_bound: float
var min_y_bound: float
var max_y_bound: float

var is_hooked: bool = false
var spawn_y: float = 0.0
var time_offset: float # Para desincronizar o movimento dos peixes
var current_target: Node2D = null # O anzol, se detetado
var movement_direction: int = 1


func _ready() -> void:
	time_offset = randf() * 100.0 # Aleatoriedade inicial


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
		_handle_hooked_rotation(delta)
		move_and_slide()
		return

	_behavior_wander_and_chase(delta)
	move_and_slide()
	_handle_sprite_visuals(delta)


func _behavior_wander_and_chase(delta: float) -> void:
	# Tentar encontrar o anzol (se estiver no grupo "bait")
	if not current_target:
		# TODO: Poderíamos otimizar isso usando um sistema de sinalização ou área de detecção, mas para simplicidade, vamos varrer os isos do grupo "bait"
		# TODO: Replace hardcoded "bait" group with a configurable export var bait_group: String = "bait"
		var baits = get_tree().get_nodes_in_group("bait")
		if baits.size() > 0:
			var potential_bait = baits[0] as Node2D
			if global_position.distance_to(potential_bait.global_position) < detection_radius:
				current_target = potential_bait

	# Se já temos alvo, verifica se fugiu
	if current_target:
		var dist = global_position.distance_to(current_target.global_position)
		if dist > detection_radius * 1.5:
			current_target = null

	var target_velocity = Vector2.ZERO

	if current_target:
		# --- MODO PERSEGUIÇÃO ---
		var direction = global_position.direction_to(current_target.global_position)
		target_velocity = direction * chase_speed
		# Atualiza movement_direction para o sistema saber o lado
		movement_direction = 1 if direction.x > 0 else -1
	else:
		# --- MODO NADO NATURAL ---
		# X: Constante com inversão nos limites
		if global_position.x <= min_x_bound:
			movement_direction = 1
		elif global_position.x >= max_x_bound:
			movement_direction = -1

		# Variação suave de velocidade (Seno)
		var speed_var = 1.0 + sin(Time.get_ticks_msec() * 0.002 + time_offset) * 0.2
		target_velocity.x = movement_direction * base_speed * speed_var

		# Y: Onda suave (Seno) ao redor do spawn_y
		var y_wave = sin(Time.get_ticks_msec() * 0.0015 + time_offset) * wander_radius_y
		var target_y = spawn_y + y_wave

		# CLAMP ESSENCIAL: Impede que saia da água ou da tela
		target_y = clampf(target_y, min_y_bound, max_y_bound)

		# Move-se em direção à altura alvo (efeito mola suave)
		var dir_y = (target_y - global_position.y)
		target_velocity.y = dir_y * 2.0

	# Suavização do movimento (Inércia da água)
	velocity = velocity.lerp(target_velocity, 5.0 * delta)


func _handle_sprite_visuals(delta: float) -> void:
	if not sprite: return

	# Flip Horizontal
	if abs(velocity.x) > 1.0:
		sprite.flip_h = velocity.x > 0

	# Rotação (Inclinar ao subir/descer)
	var target_angle = 0.0
	if abs(velocity.x) > 1.0:
		# Inclinação baseada na velocidade vertical vs horizontal
		var slope = velocity.y / abs(velocity.x)
		target_angle = clamp(slope, -0.6, 0.6) # Limita a inclinação (~35 graus)

		# Se estiver flipado (olhando p/ esquerda), inverte a rotação visual
		if sprite.flip_h:
			target_angle *= -1

	rotation = lerp_angle(rotation, target_angle, 8.0 * delta)


func _handle_hooked_rotation(delta: float) -> void:
	# Quando fisgado, talvez queira que ele olhe para o centro ou siga a linha
	# Por simplicidade, vamos zerar a rotação ou fazer ele debater-se levemente
	rotation = lerp_angle(rotation, 0.0, 5.0 * delta)


func apply_impulse(force_x: float) -> void:
	velocity.x += force_x
	if velocity.x != 0:
		movement_direction = int(sign(velocity.x))
