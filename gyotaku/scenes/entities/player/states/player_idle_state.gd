class_name PlayerIdleState
extends GameState


@export var equip_state: PlayerEquipState
@export var animated_sprite: AnimatedSprite2D


func enter() -> void:
	# TODO: This should be changed to a "transition" state, where the player goes back to idle, then transitions to the equip state after a delay. This is because the player can be interrupted while equipping, and we want to make sure they go back to idle before equipping again.
	animated_sprite.play("idle")

	await get_tree().create_timer(1.0).timeout
	transitioned.emit(self, equip_state.get_id())


func get_id() -> int:
	return PlayerStates.State.IDLE
