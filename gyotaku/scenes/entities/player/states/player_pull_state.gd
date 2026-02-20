class_name PlayerPullState
extends GameState


@export var ready_state: PlayerReadyState
@export var animated_sprite: AnimatedSprite2D


func enter() -> void:
	# TODO: Replace this with a constant
	animated_sprite.play("pull_line")
	animated_sprite.animation_finished.connect(_on_animation_finished)


func exit() -> void:
	if animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	if animated_sprite.animation == "pull_line":
		transitioned.emit(self, ready_state.get_id())


func get_id() -> int:
	return PlayerStates.State.PULL
