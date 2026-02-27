class_name FishingUpgrades
extends Resource


signal upgrades_changed

@export_group("Upgraded Multipliers")
@export var upgraded_reel_force: float = 2.0
@export var upgraded_hook_depth: float = 1.5
@export var upgraded_line_strength: float = 2.0
@export var upgraded_bait_attraction: float = 2.0

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

var is_reel_bought: bool = false
var is_hook_depth_bought: bool = false
var is_line_strength_bought: bool = false
var is_bait_bought: bool = false


var reel_force_multiplier: float:
	get: return upgraded_reel_force if is_reel_bought else 1.0


var hook_depth_multiplier: float:
	get: return upgraded_hook_depth if is_hook_depth_bought else 1.0


var line_strength_multiplier: float:
	get: return upgraded_line_strength if is_line_strength_bought else 1.0


var bait_attraction_multiplier: float:
	get: return upgraded_bait_attraction if is_bait_bought else 1.0


func upgrade_reel() -> void:
	if not is_reel_bought:
		is_reel_bought = true
		upgrades_changed.emit()


func upgrade_line_strength() -> void:
	if not is_line_strength_bought:
		is_line_strength_bought = true
		upgrades_changed.emit()


func upgrade_hook_depth() -> void:
	if not is_hook_depth_bought:
		is_hook_depth_bought = true
		upgrades_changed.emit()


func upgrade_bait() -> void:
	if not is_bait_bought:
		is_bait_bought = true
		upgrades_changed.emit()
