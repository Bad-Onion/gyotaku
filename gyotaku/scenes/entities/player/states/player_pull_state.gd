class_name PlayerPullState
extends GameState


@export var ready_state: PlayerReadyState
@export var animated_sprite: AnimatedSprite2D


func enter() -> void:
	# TODO: This should be changed to a "transition" state/animation
	animated_sprite.play(PlayerStates.PULL_ANIMATION)
	animated_sprite.animation_finished.connect(_on_animation_finished)


func exit() -> void:
	if animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	if animated_sprite.animation == PlayerStates.PULL_ANIMATION:
		transitioned.emit(self, ready_state.get_id())


func get_id() -> int:
	return PlayerStates.State.PULL
