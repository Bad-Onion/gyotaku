class_name WorldLineController
extends Node


@export var world_line_renderer: FishingLineRenderer
@export var player_rod_tip: Marker2D
@export var fishing_hook: FishingHook
@export var mechanic_system: FishingMechanicSystem


func _process(_delta: float) -> void:
	if fishing_hook.visible and not mechanic_system._is_minigame_active:
		world_line_renderer.show()
		world_line_renderer.update_tension_visuals(0.0, 1.0)
		world_line_renderer.update_line_points(player_rod_tip.global_position, fishing_hook.global_position)
	else:
		world_line_renderer.hide()
