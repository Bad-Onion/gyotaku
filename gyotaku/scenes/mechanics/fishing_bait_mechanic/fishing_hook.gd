class_name FishingHook
extends Area2D


signal fish_hooked(fish: Fish)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Fish:
		var fish := body as Fish
		if not fish.is_hooked:
			fish.hook()
			fish_hooked.emit(fish)
			# Disable collision so it doesn't hook multiple fishes
			set_deferred("monitoring", false)
