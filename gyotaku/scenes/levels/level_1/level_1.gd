class_name Level1
extends Node2D


@export var main_camera: Camera2D

@onready var fishing_hook: FishingHook = %FishingHook
@onready var fishing_mechanic_system: FishingMechanicSystem = %FishingMechanicSystem
@onready var fishing_cursor_ui: FishingCursorUI = %FishingCursorUI


func _ready() -> void:
	fishing_hook.fish_hooked.connect(_on_fish_hooked)
	fishing_mechanic_system.fish_caught.connect(_on_fish_caught)
	fishing_mechanic_system.fish_escaped.connect(_on_fish_escaped)
	fishing_mechanic_system.line_broke.connect(_on_line_broke)


func _on_fish_hooked(fish: Fish) -> void:
	print("Fish hooked! Minigame started.")
	fishing_mechanic_system.start_minigame(fish)
	fishing_cursor_ui.activate()


func _on_fish_caught() -> void:
	print("Success: Fish Caught!")
	_end_minigame()


func _on_fish_escaped() -> void:
	print("Fail: Fish Escaped!")
	_end_minigame()


func _on_line_broke() -> void:
	print("Fail: Line Broke!")
	_end_minigame()


func _end_minigame() -> void:
	fishing_cursor_ui.deactivate()

	if main_camera:
		main_camera.target = null
		main_camera.global_position.y = 180.0

	get_tree().create_timer(1.0).timeout.connect(_reset_hook_systems)


func _reset_hook_systems() -> void:
	fishing_hook.reset()
