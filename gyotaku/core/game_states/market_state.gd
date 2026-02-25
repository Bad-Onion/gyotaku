class_name MarketState
extends GameState


@export var market_ui: Control


func _ready() -> void:
	if market_ui:
		market_ui.back_requested.connect(_on_back_requested)


func get_id() -> int:
	return GameStates.State.MARKET


func enter() -> void:
	market_ui.show()
	market_ui.fade_in_music()
	get_tree().paused = true


func exit() -> void:
	market_ui.hide()
	market_ui.stop_music()
	get_tree().paused = false


func _on_back_requested() -> void:
	transitioned.emit(self, GameStates.State.PLAYING)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.UI_CANCEL):
		transitioned.emit(self, GameStates.State.PAUSED)
