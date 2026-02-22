class_name FishSpawner
extends Node2D


@export var fish_scene: PackedScene
@export var spawn_area_size: Vector2 = Vector2(560, 180)
@export var initial_fishes: int = 3
@export var max_fishes: int = 10
@export var fishes_container: Node
@export var off_screen_margin: float = 100.0


func _ready() -> void:
	await get_tree().physics_frame

	for i in range(initial_fishes):
		spawn_fish(true)


func spawn_fish(spawn_inside: bool) -> void:
	if not fish_scene or not fishes_container:
		push_error("FishSpawner: Missing dependencies.")
		return

	var fish_instance := fish_scene.instantiate() as Fish
	if not fish_instance:
		push_error("FishSpawner: Instantiated scene is not a Fish.")
		return

	fishes_container.add_child(fish_instance)

	var half_extents := spawn_area_size / 2.0
	var min_y := global_position.y - half_extents.y
	var max_y := global_position.y + half_extents.y

	var random_y := randf_range(min_y, max_y)
	var spawn_x := 0.0
	var start_direction := 1

	if spawn_inside:
		var min_x := global_position.x - half_extents.x
		var max_x := global_position.x + half_extents.x
		spawn_x = randf_range(min_x, max_x)
		start_direction = 1 if randf() > 0.5 else -1
	else:
		var spawn_left := randf() > 0.5

		if spawn_left:
			spawn_x = (global_position.x - half_extents.x) - off_screen_margin
			start_direction = 1
		else:
			spawn_x = (global_position.x + half_extents.x) + off_screen_margin
			start_direction = -1

	fish_instance.global_position = Vector2(spawn_x, random_y)

	var spawn_bounds = FishMovement.FishBounds.new(
		Rect2(global_position.x - half_extents.x, min_y, spawn_area_size.x, spawn_area_size.y),
		random_y
	)

	fish_instance.set_bounds(spawn_bounds)
	fish_instance.movement_direction = start_direction


func _on_spawn_timer_timeout() -> void:
	if fishes_container and fishes_container.get_child_count() < max_fishes:
		spawn_fish(false)
