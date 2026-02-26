class_name FishingUpgrades
extends Resource


signal upgrades_changed

@export var reel_force_multiplier: float = 2.0
@export var hook_depth_multiplier: float = 1.0
@export var line_strength_multiplier: float = 1.0
@export var bait_attraction_multiplier: float = 1.0


func upgrade_reel(amount: float = 0.2) -> void:
	reel_force_multiplier += amount
	upgrades_changed.emit()


func upgrade_line_strength(amount: float = 0.2) -> void:
	line_strength_multiplier += amount
	upgrades_changed.emit()


func upgrade_hook_depth(amount: float = 0.2) -> void:
	hook_depth_multiplier += amount
	upgrades_changed.emit()


func upgrade_bait(amount: float = 0.2) -> void:
	bait_attraction_multiplier += amount
	upgrades_changed.emit()
