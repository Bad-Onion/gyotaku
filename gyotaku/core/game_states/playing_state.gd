extends GameState


@export var level_container: Node
@export var level_scene: PackedScene
@export var economy_system: EconomySystem

var current_level: Node


func enter() -> void:
	if not current_level:
		current_level = level_scene.instantiate()
		level_container.add_child(current_level)

	current_level.market_requested.connect(func(): transitioned.emit(self, GameStates.State.MARKET))
	current_level.coins_earned.connect(_on_level_coins_earned)


func exit() -> void:
	pass


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.UI_CANCEL):
		transitioned.emit(self , GameStates.State.PAUSED)


func clear_level() -> void:
	if current_level:
		current_level.queue_free()
		current_level = null


func get_id() -> int:
	return GameStates.State.PLAYING


func _on_level_coins_earned(amount: int) -> void:
	if economy_system:
		economy_system.add_coins(amount)
	else:
		push_error("PlayingState: EconomySystem is not assigned.")
