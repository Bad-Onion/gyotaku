class_name FishVisuals
extends Node


@export var sprite: AnimatedSprite2D


func update_visuals(velocity: Vector2, current_rotation: float, delta: float) -> float:
	if not sprite: return current_rotation

	if absf(velocity.x) > 1.0:
		sprite.flip_h = velocity.x > 0

	var target_angle := 0.0
	if absf(velocity.x) > 1.0:
		var slope = velocity.y / absf(velocity.x)
		target_angle = clampf(slope, -0.6, 0.6)

	return lerp_angle(current_rotation, target_angle, 8.0 * delta)


func play_struggle() -> void:
	if sprite:
		sprite.speed_scale = 2.0


func reset_animation() -> void:
	if sprite:
		sprite.speed_scale = 1.0
