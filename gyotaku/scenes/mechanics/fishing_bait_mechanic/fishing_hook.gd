class_name FishingHook
extends Area2D


signal fish_hooked(fish: Fish)


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# TODO: Remove hardcoded "bait" group and use an exported variable for configurability
	add_to_group("bait")


func _on_body_entered(body: Node2D) -> void:
	if body is Fish:
		var fish := body as Fish

		if not fish.is_hooked:
			fish.hook()
			fish_hooked.emit(fish)
			# Disable collision so it doesn't hook multiple fishes
			set_deferred("monitoring", false)
			remove_from_group("bait")


func reset() -> void:
	set_deferred("monitoring", true)

	# TODO: Remove hardcoded "bait" group and use an exported variable for configurability
	if not is_in_group("bait"):
		add_to_group("bait")
