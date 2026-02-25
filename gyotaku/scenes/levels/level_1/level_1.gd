class_name Level1
extends Node2D


signal total_coins_changed(total: int)

@export var main_camera: Camera2D
@export var fish_chest_marker: Marker2D
@export var economy_system: EconomySystem
@export var coin_hud: CoinHUD

@onready var fishing_hook: FishingHook = %FishingHook
@onready var fishing_mechanic_system: FishingMechanicSystem = %FishingMechanicSystem
@onready var fishing_cursor_ui: FishingCursorUI = %FishingCursorUI


func _ready() -> void:
	fishing_hook.fish_hooked.connect(_on_fish_hooked)
	fishing_mechanic_system.fish_caught.connect(_on_fish_caught)
	fishing_mechanic_system.fish_escaped.connect(_on_fish_escaped)
	fishing_mechanic_system.line_broke.connect(_on_line_broke)

	if economy_system:
		economy_system.coins_changed.connect(_on_coins_changed)


func _on_fish_hooked(fish: Fish) -> void:
	print("Fish hooked! Minigame started.")
	fishing_mechanic_system.start_minigame(fish)
	fishing_cursor_ui.activate()


func _on_fish_caught() -> void:
	print("Success: Fish Caught!")
	var caught_fish = fishing_hook.hooked_fish

	if caught_fish:
		caught_fish.reel_in_to(fish_chest_marker, 0.7)

		if economy_system and caught_fish.fishing_config:
			economy_system.add_coins(caught_fish.fishing_config.coin_reward)

	_end_minigame()


func _on_fish_escaped() -> void:
	print("Fail: Fish Escaped!")
	_end_minigame()


func _on_line_broke() -> void:
	print("Fail: Line Broke!")
	_end_minigame()


func _end_minigame() -> void:
	fishing_cursor_ui.deactivate()
	fishing_hook.hide()

	if main_camera:
		main_camera.target = null
		main_camera.global_position.y = 180.0

	get_tree().create_timer(1.0).timeout.connect(_reset_hook_systems)


func _reset_hook_systems() -> void:
	fishing_hook.reset()


func _on_coins_changed(total_coins: int, added_amount: int) -> void:
	if coin_hud and added_amount > 0:
		coin_hud.update_coins(total_coins, added_amount)

	total_coins_changed.emit(total_coins)



