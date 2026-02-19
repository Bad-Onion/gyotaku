class_name Fish
extends CharacterBody2D


@export var movement_component: FishMovement
@export var visuals_component: FishVisuals

var is_hooked: bool = false
var movement_direction: int = 1
var _current_target: Node2D = null


func _ready() -> void:
	if not movement_component or not visuals_component:
		push_error("Fish: Missing components.")


# TODO: Refactor to use a single method for setting bounds with a struct or class for better organization and type safety
func set_bounds(min_x: float, max_x: float, min_y: float, max_y: float) -> void:
	movement_component.set_bounds(min_x, max_x, min_y, max_y, global_position.y)


func hook() -> void:
	is_hooked = true
	velocity = Vector2.ZERO
	rotation = 0
	visuals_component.play_struggle()


func apply_impulse(force_x: float) -> void:
	velocity.x += force_x

	if velocity.x != 0:
		movement_direction = int(signf(velocity.x))


# TODO: Refactor so that the visuals component can handle all animation states, including struggling and normal swimming, for better separation of concerns
func update_facing_direction(dir: float) -> void:
	if visuals_component and visuals_component.sprite:
		visuals_component.sprite.flip_h = (dir > 0)


func _physics_process(delta: float) -> void:
	if is_hooked:
		rotation = lerp_angle(rotation, 0.0, 5.0 * delta)
		move_and_slide()
		return

	_current_target = movement_component.find_target(global_position, _current_target)

	var mov_data = movement_component.calculate_velocity(global_position, velocity, _current_target, movement_direction, delta)
	velocity = mov_data["velocity"]
	movement_direction = mov_data["direction"]

	move_and_slide()

	rotation = visuals_component.update_visuals(velocity, rotation, delta)
