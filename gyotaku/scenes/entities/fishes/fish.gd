class_name Fish
extends CharacterBody2D


@export var movement_component: FishMovement
@export var visuals_component: FishVisuals
@export var fishing_config: FishingConfig

var is_hooked: bool = false
var movement_direction: int = 1
var _current_target: Node2D = null


func _ready() -> void:
	if not movement_component or not visuals_component:
		push_error("Fish: Missing components.")


func set_bounds(bounds: FishMovement.FishBounds) -> void:
	movement_component.set_bounds(bounds)


func hook() -> void:
	is_hooked = true
	velocity = Vector2.ZERO
	rotation = 0
	visuals_component.set_struggle_state(true)


func apply_external_force(force_x: float, delta: float) -> void:
	velocity.x = movement_component.move(velocity.x, force_x, delta)

	if velocity.x != 0:
		update_facing_direction(signf(velocity.x))


func apply_impulse(force_x: float) -> void:
	velocity.x += force_x

	if velocity.x != 0:
		movement_direction = int(signf(velocity.x))


func set_vertical_position(y_position: float) -> void:
	global_position.y = y_position


func update_facing_direction(direction: float) -> void:
	if visuals_component:
		visuals_component.update_facing(direction)


func _physics_process(delta: float) -> void:
	if is_hooked:
		rotation = lerp_angle(rotation, 0.0, 5.0 * delta)
		move_and_slide()
		return

	_current_target = movement_component.find_target(global_position, _current_target)

	var movement_data = movement_component.calculate_velocity(global_position, velocity, _current_target, movement_direction, delta)
	velocity = movement_data.velocity
	movement_direction = movement_data.direction

	move_and_slide()

	rotation = visuals_component.update_visuals(velocity, rotation, delta)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.
