class_name FishingHook
extends Area2D


signal fish_hooked(fish: Fish)

const MONITORING := "monitoring"

@export var sink_speed: float = 150.0
@export var max_y_limit: float = 500.0

var is_sinking: bool = false
var hooked_fish: Fish = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group(NodeGroups.BAIT_GROUP)

	set_physics_process(false)
	set_deferred(MONITORING, false)
	hide()


func _physics_process(delta: float) -> void:
	if is_sinking:
		global_position.y += sink_speed * delta

		if global_position.y >= max_y_limit:
			global_position.y = max_y_limit
			stop_sinking()

	elif hooked_fish != null and is_instance_valid(hooked_fish):
		global_position = hooked_fish.global_position


func stop_sinking() -> void:
	is_sinking = false


func cast_line(start_position: Vector2) -> void:
	global_position = start_position
	show()
	set_deferred(MONITORING, true)
	is_sinking = true
	set_physics_process(true)


func _on_body_entered(body: Node2D) -> void:
	if body is Fish:
		var fish := body as Fish

		if not fish.is_hooked:
			stop_sinking()
			hooked_fish = fish
			fish.hook()
			fish_hooked.emit(fish)

			set_deferred(MONITORING, false)
			remove_from_group(NodeGroups.BAIT_GROUP)


func reset() -> void:
	stop_sinking()
	hooked_fish = null
	hide()
	set_deferred(MONITORING, false)
	set_physics_process(false)

	if not is_in_group(NodeGroups.BAIT_GROUP):
		add_to_group(NodeGroups.BAIT_GROUP)
