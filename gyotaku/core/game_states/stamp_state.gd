class_name StampState
extends GameState


@export var stamp_ui: Control

var current_fish_id: String = ""
var _is_pausing: bool = false


func _ready() -> void:
	var state_machine = get_parent()
	if state_machine is StateMachine:
		state_machine.state_changed.connect(_on_global_state_changed)


func enter() -> void:
	if _is_pausing:
		_is_pausing = false

	get_tree().paused = true

	if stamp_ui:
		# Inject the specific fish ID before showing
		if stamp_ui.has_method("initialize_fish"):
			stamp_ui.initialize_fish(current_fish_id)

		# Listen for the minigame completion
		if not stamp_ui.stamp_finished.is_connected(_on_stamp_finished):
			stamp_ui.stamp_finished.connect(_on_stamp_finished)

		stamp_ui.show()


func exit() -> void:
	if not _is_pausing:
		get_tree().paused = false
		
		if stamp_ui:
			stamp_ui.hide()




func get_id() -> int:
	return GameStates.State.STAMP

func _on_stamp_finished() -> void:
	_is_pausing = false
	transitioned.emit(self, GameStates.State.CATALOG)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.UI_CANCEL):
		_is_pausing = true
		transitioned.emit(self, GameStates.State.PAUSED)


func _on_global_state_changed(new_state_id: int) -> void:
	if new_state_id == GameStates.State.MAIN_MENU:
		_is_pausing = false
