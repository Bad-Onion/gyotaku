class_name SaveSystem
extends Node


const SAVE_PATH = "user://save_data.json"

@export var economy_system: EconomySystem
@export var upgrades: FishingUpgrades
@export var catalog: FishCatalog


var _is_ready_to_save: bool = false


func _ready() -> void:
	call_deferred("_initialize_save_system")


func _initialize_save_system() -> void:
	load_game()

	if economy_system: economy_system.coins_changed.connect(func(_total: int, _added: int): save_game())
	if upgrades: upgrades.upgrades_changed.connect(save_game)
	if catalog: catalog.catalog_changed.connect(save_game)

	_is_ready_to_save = true


func save_game() -> void:
	if not _is_ready_to_save:
		return

	var catalog_data := {}

	if catalog:
		for entry in catalog.entries:
			catalog_data[entry.id] = {
				"is_caught": entry.is_caught,
				"is_stamped": entry.is_stamped,
				"nickname": entry.nickname
			}

	var data := {
		"coins": economy_system.get_coins() if economy_system else 0,
		"upgrades": {
			"is_reel_bought": upgrades.is_reel_bought if upgrades else false,
			"is_line_strength_bought": upgrades.is_line_strength_bought if upgrades else false,
			"is_hook_depth_bought": upgrades.is_hook_depth_bought if upgrades else false,
			"is_bait_bought": upgrades.is_bait_bought if upgrades else false
		},
		"catalog": catalog_data
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("Save file not found. Starting fresh.")
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file:
		var json_string := file.get_as_text()

		file.close()

		var data = JSON.parse_string(json_string)

		if data == null or typeof(data) != TYPE_DICTIONARY:
			push_error("SAVE SYSTEM ERROR: Failed to parse JSON. The file might be corrupted.")
			return

		print("JSON loaded successfully from disk.")
		_apply_data(data)


func _apply_data(data: Dictionary) -> void:
	if economy_system == null:
		push_error("SAVE SYSTEM ERROR: EconomySystem is missing! Assign it in the Inspector.")
	elif data.has("coins"):
		economy_system.current_coins = int(data["coins"])
		economy_system.coins_changed.emit(economy_system.current_coins, 0)
		print("-> Coins loaded: ", economy_system.current_coins)

	if upgrades == null:
		push_error("SAVE SYSTEM ERROR: Upgrades resource is missing! Assign it in the Inspector.")
	elif data.has("upgrades"):
		var up_data: Dictionary = data["upgrades"]

		upgrades.is_reel_bought = bool(up_data.get("is_reel_bought", false))
		upgrades.is_line_strength_bought = bool(up_data.get("is_line_strength_bought", false))
		upgrades.is_hook_depth_bought = bool(up_data.get("is_hook_depth_bought", false))
		upgrades.is_bait_bought = bool(up_data.get("is_bait_bought", false))
		upgrades.upgrades_changed.emit()
		print("-> Upgrades loaded.")

	if catalog == null:
		push_error("SAVE SYSTEM ERROR: Catalog resource is missing! Assign it in the Inspector.")
	elif data.has("catalog"):
		var cat_data: Dictionary = data["catalog"]

		for entry in catalog.entries:
			if cat_data.has(entry.id):
				var fish_data: Dictionary = cat_data[entry.id]

				entry.is_caught = bool(fish_data.get("is_caught", false))
				entry.is_stamped = bool(fish_data.get("is_stamped", false))

				if fish_data.has("nickname"):
					entry.nickname = str(fish_data["nickname"])

		catalog.catalog_changed.emit()
		print("-> Catalog loaded.")
