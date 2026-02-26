class_name SaveSystem
extends Node


const SAVE_PATH = "user://save_data.json"

@export var economy_system: EconomySystem
@export var upgrades: FishingUpgrades


func _ready() -> void:
	call_deferred("load_game")

	if economy_system:
		economy_system.coins_changed.connect(func(_total: int, _added: int): save_game())
	if upgrades:
		upgrades.upgrades_changed.connect(save_game)


func save_game() -> void:
	var data := {
		"coins": economy_system.get_coins() if economy_system else 0,
		"upgrades": {
			"is_reel_bought": upgrades.is_reel_bought if upgrades else false,
			"is_line_strength_bought": upgrades.is_line_strength_bought if upgrades else false,
			"is_hook_depth_bought": upgrades.is_hook_depth_bought if upgrades else false,
			"is_bait_bought": upgrades.is_bait_bought if upgrades else false
		}
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string := file.get_as_text()
		file.close()

		var json := JSON.new()
		var error := json.parse(json_string)
		if error == OK:
			_apply_data(json.data)


func _apply_data(data: Dictionary) -> void:
	if economy_system and data.has("coins"):
		economy_system.current_coins = int(data["coins"])
		economy_system.coins_changed.emit(economy_system.current_coins, 0)

	if upgrades and data.has("upgrades"):
		var up_data: Dictionary = data["upgrades"]
		upgrades.is_reel_bought = bool(up_data.get("is_reel_bought", false))
		upgrades.is_line_strength_bought = bool(up_data.get("is_line_strength_bought", false))
		upgrades.is_hook_depth_bought = bool(up_data.get("is_hook_depth_bought", false))
		upgrades.is_bait_bought = bool(up_data.get("is_bait_bought", false))

		upgrades.upgrades_changed.emit()
