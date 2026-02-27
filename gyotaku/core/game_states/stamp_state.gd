class_name StampState
extends GameState


@export var ui_container: Node
@export var stamp_scene: PackedScene

var current_stamp_ui: CanvasLayer
var current_fish_id: String = ""


func enter() -> void:
	if stamp_scene:
		current_stamp_ui = stamp_scene.instantiate()
		ui_container.add_child(current_stamp_ui)

		if current_stamp_ui.has_method("initialize_fish"):
			current_stamp_ui.initialize_fish(current_fish_id)

		if current_stamp_ui.has_signal("stamp_finished"):
			current_stamp_ui.stamp_finished.connect(_on_stamp_finished)


func exit() -> void:
	if current_stamp_ui:
		current_stamp_ui.queue_free()
		current_stamp_ui = null


func get_id() -> int:
	return GameStates.State.STAMP


func _on_stamp_finished() -> void:
	transitioned.emit(self, GameStates.State.CATALOG)
