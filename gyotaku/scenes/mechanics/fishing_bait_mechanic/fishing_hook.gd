class_name FishingHook
extends Area2D


signal fish_hooked(fish: Fish)

const MONITORING := "monitoring"


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group(NodeGroups.BAIT_GROUP)


func _on_body_entered(body: Node2D) -> void:
	if body is Fish:
		var fish := body as Fish

		if not fish.is_hooked:
			fish.hook()
			fish_hooked.emit(fish)

			set_deferred(MONITORING, false)
			remove_from_group(NodeGroups.BAIT_GROUP)


func reset() -> void:
	set_deferred(MONITORING, true)

	if not is_in_group(NodeGroups.BAIT_GROUP):
		add_to_group(NodeGroups.BAIT_GROUP)
