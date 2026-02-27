class_name Fish
extends CharacterBody2D


@export var movement_component: FishMovement
@export var visuals_component: FishVisuals
@export var fishing_config: FishingConfig

@export var catalog_id: String = ""

var is_hooked: bool = false
var movement_direction: int = 1
var _current_target: Node2D = null
var _has_entered_screen: bool = false
var _is_escaping: bool = false


func _ready() -> void:
	z_index = 10

	if not movement_component or not visuals_component:
		push_error("Fish: Missing components.")


func set_bounds(bounds: FishMovement.FishBounds) -> void:
	movement_component.set_bounds(bounds)


func hook() -> void:
	is_hooked = true
	velocity = Vector2.ZERO
	rotation = 0
	visuals_component.set_struggle_state(true)


func catch(target_position: Vector2) -> void:
	is_hooked = false
	set_physics_process(false)

	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)


func escape() -> void:
	is_hooked = false
	_is_escaping = true
	visuals_component.set_struggle_state(false)

	velocity.x = 800.0 * signf(movement_direction) if movement_direction != 0 else 800.0
	velocity.y = 0


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

	if _is_escaping:
		move_and_slide()
		return

	_current_target = movement_component.find_target(self, _current_target, delta)

	var movement_data = movement_component.calculate_velocity(global_position, velocity, _current_target, movement_direction, delta)
	velocity = movement_data.velocity
	movement_direction = movement_data.direction

	move_and_slide()

	rotation = visuals_component.update_visuals(velocity, rotation, delta)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	_has_entered_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if _has_entered_screen and not is_hooked:
		queue_free()


func reel_in_to(target_node: Node2D, duration: float) -> void:
	var start_pos: Vector2 = global_position
	var tween: Tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.tween_method(
		func(weight: float) -> void:
			if is_instance_valid(target_node) and is_instance_valid(self):
				global_position = start_pos.lerp(target_node.global_position, weight),
		0.0,
		1.0,
		duration
	)

	tween.tween_callback(queue_free)
