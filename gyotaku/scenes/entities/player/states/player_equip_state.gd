class_name PlayerEquipState
extends GameState


@export var ready_state: PlayerReadyState
@export var animated_sprite: AnimatedSprite2D


func enter() -> void:
	# TODO: This should be changed to a "transition" state/animation
	animated_sprite.play(PlayerStates.EQUIP_ANIMATION)
	animated_sprite.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	if animated_sprite.animation == PlayerStates.EQUIP_ANIMATION:
		animated_sprite.animation_finished.disconnect(_on_animation_finished)
		transitioned.emit(self, ready_state.get_id())


func get_id() -> int:
	return PlayerStates.State.EQUIP
