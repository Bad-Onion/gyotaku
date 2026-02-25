extends GameState


signal coins_updated(total: int)

@export var level_container: Node
@export var level_scene: PackedScene

var current_level: Node


func enter() -> void:
	if not current_level:
		current_level = level_scene.instantiate()
		level_container.add_child(current_level)

	current_level.total_coins_changed.connect(func(total: int): coins_updated.emit(total))


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
