class_name FishingUpgrades
extends Resource


signal upgrades_changed

@export_group("Multipliers")
@export var reel_force_multiplier: float = 2.0
@export var hook_depth_multiplier: float = 1.0
@export var line_strength_multiplier: float = 2.0
@export var bait_attraction_multiplier: float = 5.0

@export_group("Costs")
@export var reel_cost: int = 10
@export var hook_depth_cost: int = 10
@export var line_strength_cost: int = 10
@export var bait_cost: int = 10

@export_group("Names")
@export var reel_name: String = "Molinete"
@export var hook_depth_name: String = "Tamanho da Linha"
@export var line_strength_name: String = "Resistencia da Linha"
@export var bait_name: String = "Isca"


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
