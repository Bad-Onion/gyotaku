class_name FishingConfig
extends Resource


@export_group("Tension Settings")
@export var max_tension: float = 100.0
@export var tension_increase_multiplier: float = 0.5
@export var tension_recovery_rate: float = 40.0
@export var critical_tension_threshold: float = 90.0
@export var sweet_spot_min: float = 10.0
@export var sweet_spot_max: float = 80.0

@export_group("Forces")
@export var player_pull_power: float = 1.5
@export var fish_struggle_power: float = 60.0
@export var impulse_penalty_force: float = 100.0

@export_group("Zones & Depth")
@export var safe_zone_radius: float = 60.0
@export var danger_zone_radius: float = 120.0
@export var max_depth: float = 100.0
@export var depth_pull_up_speed: float = 20.0
@export var depth_sink_slow_speed: float = 5.0
@export var depth_sink_fast_speed: float = 30.0

@export_group("Visual Mapping")
@export var surface_y: float = 190.0
@export var bottom_y: float = 340.0
