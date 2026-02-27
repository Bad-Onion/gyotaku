class_name FishSpawner
extends Node2D


@export var hook_reference: Node2D
@export var spawn_pool: Array[FishSpawnConfig]
@export var spawn_area_size: Vector2 = Vector2(560, 180)
@export var initial_fishes: int = 3
@export var max_fishes: int = 10
@export var fishes_container: Node
@export var off_screen_margin: float = 100.0
@export var water_surface_y: float = 450.0


func _ready() -> void:
	await get_tree().physics_frame

	for i in range(initial_fishes):
		spawn_fish(true)


func _process(_delta: float) -> void:
	if hook_reference:
		var half_extents := spawn_area_size.y / 2.0
		var min_spawner_y := water_surface_y + half_extents

		global_position.y = maxf(hook_reference.global_position.y, min_spawner_y)


func spawn_fish(spawn_inside: bool) -> void:
	if not fishes_container:
		push_error("FishSpawner: Missing fishes_container.")
		return

	var half_extents := spawn_area_size / 2.0
	var min_y := global_position.y - half_extents.y
	var max_y := global_position.y + half_extents.y
	var random_y := randf_range(min_y, max_y)

	var selected_scene := _get_random_fish_scene(random_y)
	if not selected_scene:
		return

	var fish_instance := selected_scene.instantiate() as Fish
	if not fish_instance:
		push_error("FishSpawner: Instantiated scene is not a Fish.")
		return

	fishes_container.add_child(fish_instance)

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


func _get_random_fish_scene(spawn_depth: float) -> PackedScene:
	if spawn_pool.is_empty():
		return null

	var valid_configs: Array[FishSpawnConfig] = []
	var total_weight := 0.0

	for config in spawn_pool:
		if spawn_depth >= config.min_depth:
			valid_configs.append(config)
			var dynamic_weight = config.spawn_weight + (config.depth_weight_bonus * (spawn_depth / 100.0))
			total_weight += dynamic_weight

	if valid_configs.is_empty():
		return spawn_pool[0].fish_scene

	var random_value := randf_range(0.0, total_weight)
	var current_weight := 0.0

	for config in valid_configs:
		var dynamic_weight = config.spawn_weight + (config.depth_weight_bonus * (spawn_depth / 100.0))
		current_weight += dynamic_weight

		if random_value <= current_weight:
			return config.fish_scene

	return valid_configs[0].fish_scene
