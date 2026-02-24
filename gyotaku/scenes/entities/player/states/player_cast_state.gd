class_name PlayerCastState
extends GameState


signal hook_casted

@export var pull_state: PlayerPullState
@export var animated_sprite: AnimatedSprite2D
@export var fishing_hook: FishingHook
@export var game_camera: FishingCamera
@export var rod_tip_marker: Marker2D
@export var fishing_mechanic_system: FishingMechanicSystem


func enter() -> void:
	# TODO: This should be changed to a "transition" state/animation
	animated_sprite.play(PlayerStates.CAST_ANIMATION)
	animated_sprite.animation_finished.connect(_on_animation_finished)

	fishing_mechanic_system.fish_caught.connect(_on_minigame_ended)
	fishing_mechanic_system.fish_escaped.connect(_on_minigame_ended)
	fishing_mechanic_system.line_broke.connect(_on_minigame_ended)


func get_id() -> int:
	return PlayerStates.State.CAST


func exit() -> void:
	if animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_finished)

	fishing_mechanic_system.fish_caught.disconnect(_on_minigame_ended)
	fishing_mechanic_system.fish_escaped.disconnect(_on_minigame_ended)
	fishing_mechanic_system.line_broke.disconnect(_on_minigame_ended)


func _on_minigame_ended() -> void:
	transitioned.emit(self, pull_state.get_id())


func _on_animation_finished() -> void:
	if animated_sprite.animation == PlayerStates.CAST_ANIMATION:
		animated_sprite.animation_finished.disconnect(_on_animation_finished)

		fishing_hook.cast_line(rod_tip_marker.global_position)
		game_camera.target = fishing_hook

		hook_casted.emit()
