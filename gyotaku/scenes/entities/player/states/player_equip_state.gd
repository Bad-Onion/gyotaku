class_name PlayerEquipState
extends GameState


@export var ready_state: PlayerReadyState
@export var animated_sprite: AnimatedSprite2D


func enter() -> void:
	# TODO: Replace this with a constant in the animation player, and use that instead. This is because the animation name can be changed, and we don't want to have to change the code every time that happens.
	animated_sprite.play("equip_rod")
	animated_sprite.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	if animated_sprite.animation == "equip_rod":
		animated_sprite.animation_finished.disconnect(_on_animation_finished)
		transitioned.emit(self, ready_state.get_id())


func get_id() -> int:
	return PlayerStates.State.EQUIP
