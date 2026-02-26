class_name MarketState
extends GameState


@export var market_ui: Control

var _is_pausing: bool = false


func _ready() -> void:
	if market_ui:
		market_ui.back_requested.connect(_on_back_requested)

	var state_machine = get_parent()
	if state_machine is StateMachine:
		state_machine.state_changed.connect(_on_global_state_changed)


func get_id() -> int:
	return GameStates.State.MARKET


func enter() -> void:
	if _is_pausing:
		_is_pausing = false
		market_ui.resume_music()
	else:
		market_ui.show()
		market_ui.fade_in_music()

	get_tree().paused = true


func exit() -> void:
	if _is_pausing:
		market_ui.pause_music()
		pass
	else:
		market_ui.hide()
		market_ui.stop_music()
		get_tree().paused = false


func _on_back_requested() -> void:
	_is_pausing = false
	transitioned.emit(self, GameStates.State.PLAYING)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.UI_CANCEL):
		_is_pausing = true
		transitioned.emit(self, GameStates.State.PAUSED)


func _on_global_state_changed(new_state_id: int) -> void:
	if new_state_id == GameStates.State.MAIN_MENU:
		_is_pausing = false

		if market_ui:
			market_ui.hide()
			market_ui.stop_music()
