class_name Level1
extends Node2D


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
	fishing_cursor_ui.deactivate()


func _on_fish_escaped() -> void:
	print("Fail: Fish Escaped!")
	fishing_cursor_ui.deactivate()


func _on_line_broke() -> void:
	print("Fail: Line Broke!")
	fishing_cursor_ui.deactivate()
