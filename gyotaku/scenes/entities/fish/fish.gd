class_name Fish
extends CharacterBody2D


@export var base_speed: float = 20.0
@export var movement_direction: int = 1 # 1 para a direita, -1 para a esquerda

var min_x_bound: float
var max_x_bound: float
var is_hooked: bool = false


func set_bounds(min_x: float, max_x: float) -> void:
	min_x_bound = min_x
	max_x_bound = max_x


func hook() -> void:
	is_hooked = true
	velocity = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if is_hooked:
		move_and_slide() # Only move based on impulses from the mechanic system
		return

	velocity.x = base_speed * movement_direction
	move_and_slide()

	print("Fish X: ", global_position.x, " | Vel: ", velocity.x, " | Dir: ", movement_direction)

	if global_position.x <= min_x_bound and movement_direction < 0:
		movement_direction = 1
	elif global_position.x >= max_x_bound and movement_direction > 0:
		movement_direction = -1

	if is_on_wall():
		movement_direction *= -1


func apply_impulse(force_x: float) -> void:
	# Aplica um dash e inverte ou acelera o movimento
	velocity.x += force_x
	movement_direction = sign(velocity.x) if velocity.x != 0 else movement_direction
