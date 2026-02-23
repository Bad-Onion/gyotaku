class_name FishMovementConfig
extends Resource


@export_group("Movement Parameters")
@export var base_speed: float = 50.0
@export var chase_speed: float = 100.0
@export var detection_radius: float = 150.0
@export var force_smoothness: float = 300.0
@export var wander_radius_y: float = 30.0

@export_group("Decision Making")
@export_range(0.0, 1.0) var bait_interest_chance: float = 0.5
@export var bait_ignore_duration: float = 3.0
@export var reaction_time_min: float = 0.8
@export var reaction_time_max: float = 2.5

@export_group("Organic Movement")
@export var burst_speed_multiplier: float = 2.5
@export var min_burst_time: float = 0.5
@export var max_burst_time: float = 1.2
@export var min_pause_time: float = 1.0
@export var max_pause_time: float = 2.5
