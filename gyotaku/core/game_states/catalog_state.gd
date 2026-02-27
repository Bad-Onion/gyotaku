class_name CatalogState
extends GameState


@export var catalog_ui: Control

var _is_pausing: bool = false


func _ready() -> void:
	var state_machine = get_parent()
	if state_machine is StateMachine:
		state_machine.state_changed.connect(_on_global_state_changed)


func enter() -> void:
	if _is_pausing:
		_is_pausing = false

	get_tree().paused = true

	if catalog_ui:
		if not catalog_ui.back_requested.is_connected(_on_back_requested):
			catalog_ui.back_requested.connect(_on_back_requested)

		if not catalog_ui.stamp_requested.is_connected(_on_stamp_requested):
			catalog_ui.stamp_requested.connect(_on_stamp_requested)

		catalog_ui.show()

func get_id() -> int:
	return GameStates.State.CATALOG


func exit() -> void:
	if _is_pausing:
		pass
	else:
		get_tree().paused = false

		if catalog_ui:
			catalog_ui.hide()


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


func _on_stamp_requested(fish_id: String) -> void:
	var stamp_state = get_parent().get_node_or_null("StampState")

	if stamp_state:
		stamp_state.current_fish_id = fish_id

	transitioned.emit(self, GameStates.State.STAMP)
