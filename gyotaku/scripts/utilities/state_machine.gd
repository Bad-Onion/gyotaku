class_name StateMachine
extends Node


signal state_changed(new_state_id: int)

@export var initial_state: GameState

var current_state: GameState
var previous_state_id: int = GameStates.State.MAIN_MENU
var states: Dictionary[int, GameState] = {}


func _ready() -> void:
	await owner.ready

	for child in get_children():
		if child is GameState:
			states[child.get_id()] = child
			child.transitioned.connect(on_child_transitioned)

	if initial_state:
		initial_state.enter()
		current_state = initial_state
		state_changed.emit(initial_state.get_id())


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


func on_child_transitioned(state: GameState, target_state_id: int) -> void:
	if state != current_state:
		return

	var new_state_id: int = target_state_id
	if target_state_id == GameStates.State.PREVIOUS:
		new_state_id = previous_state_id

	var new_state: GameState = states.get(new_state_id)
	if not new_state:
		push_error("GameState Machine: Target state ID '%s' does not exist." % new_state_id)
		return

	if current_state:
		if current_state.get_id() != GameStates.State.PAUSED:
			previous_state_id = current_state.get_id()

		current_state.exit()

	new_state.enter()
	current_state = new_state
	state_changed.emit(new_state_id)
