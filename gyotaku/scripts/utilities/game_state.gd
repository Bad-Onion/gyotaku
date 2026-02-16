class_name GameState
extends Node


signal transitioned(state: GameState, new_state_id: int)


func enter() -> void:
    pass


func exit() -> void:
    pass


func update(_delta: float) -> void:
    pass


func physics_update(_delta: float) -> void:
    pass


func handle_input(_event: InputEvent) -> void:
    pass


func get_id() -> int:
    push_error("State must override get_id()")
    return -1
