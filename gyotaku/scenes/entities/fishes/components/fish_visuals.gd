class_name FishVisuals
extends Node


@export var sprite: AnimatedSprite2D


func update_visuals(velocity: Vector2, current_rotation: float, delta: float) -> float:
	if not sprite: return current_rotation

	update_facing(velocity.x)

	var target_angle := 0.0

	if absf(velocity.x) > 1.0:
		var slope = velocity.y / absf(velocity.x)
		target_angle = clampf(slope, -0.6, 0.6)

	return lerp_angle(current_rotation, target_angle, 8.0 * delta)


func set_struggle_state(is_struggling: bool) -> void:
	if sprite:
		sprite.speed_scale = 2.0 if is_struggling else 1.0


func update_facing(direction_x: float) -> void:
	if not sprite: return

	if absf(direction_x) > 0.1:
		sprite.flip_h = direction_x > 0
