class_name FishSpawner
extends Node2D


@export var fish_scene: PackedScene
@export var spawn_area_size: Vector2 = Vector2(560, 180)
@export var max_fishes: int = 5
@export var fishes_container: Node


func _ready() -> void:
	await get_tree().physics_frame

	for i in range(max_fishes):
		spawn_fish()


func spawn_fish() -> void:
	if not fish_scene or not fishes_container:
		push_error("FishSpawner: Missing dependencies.")
		return

	var fish_instance := fish_scene.instantiate() as Fish
	if not fish_instance:
		push_error("FishSpawner: Instantiated scene is not a Fish.")
		return

	fishes_container.add_child(fish_instance)

	var half_extents := spawn_area_size / 2.0
	var min_x := global_position.x - half_extents.x
	var max_x := global_position.x + half_extents.x
	var min_y := global_position.y - half_extents.y
	var max_y := global_position.y + half_extents.y

	# Set random spawn position
	var random_x := randf_range(min_x, max_x)
	var random_y := randf_range(min_y, max_y)

	fish_instance.global_position = Vector2(random_x, random_y)

	var spawn_bounds = FishMovement.FishBounds.new(
		Rect2(min_x, min_y, max_x - min_x, max_y - min_y),
		random_y
	)

	# Inject horizontal bounds
	fish_instance.set_bounds(spawn_bounds)

	# Randomize initial direction
	fish_instance.movement_direction = 1 if randf() > 0.5 else -1
