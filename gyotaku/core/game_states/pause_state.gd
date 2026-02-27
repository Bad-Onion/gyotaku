extends GameState


@export var pause_menu_ui: PauseMenu


func enter() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	pause_menu_ui.show()
	pause_menu_ui.resume_requested.connect(_on_resume)
	pause_menu_ui.quit_to_menu_requested.connect(_on_quit)


func exit() -> void:
	get_tree().paused = false
	pause_menu_ui.hide()
	pause_menu_ui.resume_requested.disconnect(_on_resume)
	pause_menu_ui.quit_to_menu_requested.disconnect(_on_quit)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.UI_CANCEL):
		_on_resume()


func _on_resume() -> void:
	transitioned.emit(self, GameStates.State.PREVIOUS)


func _on_quit() -> void:
	transitioned.emit(self, GameStates.State.MAIN_MENU)


func get_id() -> int:
	return GameStates.State.PAUSED
