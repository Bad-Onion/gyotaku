class_name PlayerReadyState
extends GameState


@export var cast_state: PlayerCastState
@export var player_input: PlayerFishingInput


func enter() -> void:
	pass


func update(_delta: float) -> void:
	if Input.is_action_just_pressed(InputActions.THROW_HOOK):
		transitioned.emit(self, cast_state.get_id())


func get_id() -> int:
	return PlayerStates.State.READY
