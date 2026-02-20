class_name PlayerIdleState
extends GameState


@export var equip_state: PlayerEquipState
@export var animated_sprite: AnimatedSprite2D


func enter() -> void:
	# TODO: This should be changed to a "transition" state/animation
	animated_sprite.play(PlayerStates.IDLE_ANIMATION)

	await get_tree().create_timer(1.0).timeout
	transitioned.emit(self, equip_state.get_id())


func get_id() -> int:
	return PlayerStates.State.IDLE
