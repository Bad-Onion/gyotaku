class_name FishSpawnConfig
extends Resource


@export var fish_scene: PackedScene
@export_range(0.1, 100.0, 0.1) var spawn_weight: float = 1.0

@export_group("Depth Mechanics")
@export var min_depth: float = 0.0
@export var depth_weight_bonus: float = 0.0
