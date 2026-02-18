class_name FishingCursorUI
extends Node2D


@export_group("Dependencies")
@export var mechanic_system: FishingMechanicSystem
@export var input_system: PlayerFishingInput

@export_group("Nodes")
@onready var rod_sprite: Sprite2D = %RodSprite
@onready var arrow_sprite: Sprite2D = %ArrowSprite

@export_group("Colors & Thresholds")
@export var color_low: Color = Color.YELLOW
@export var color_perfect: Color = Color.GREEN
@export var color_danger: Color = Color.RED
@export var sweet_spot_min: float = 30.0
@export var sweet_spot_max: float = 70.0

var max_expected_drag: float = 150.0


func _ready() -> void:
	hide()


func activate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	show()


func deactivate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hide()


func _process(delta: float) -> void:
	if not visible or not mechanic_system or not input_system:
		return

	global_position = get_global_mouse_position()

	_update_arrow()
	_update_rod(delta)


func _update_arrow() -> void:
	var drag_vector := input_system.get_drag_vector()

	if input_system.is_active() and drag_vector.length() > 5.0:
		arrow_sprite.show()
		arrow_sprite.rotation = drag_vector.angle()
	else:
		arrow_sprite.hide()

	# Tint the arrow based on current tension
	var tension := mechanic_system.current_tension
	if tension < sweet_spot_min:
		arrow_sprite.modulate = color_low
	elif tension > sweet_spot_max:
		arrow_sprite.modulate = color_danger
	else:
		arrow_sprite.modulate = color_perfect


func _update_rod(delta: float) -> void:
	# Calculate how hard the player is pulling (0.0 to 1.0)
	var drag_length := input_system.get_drag_vector().length()
	var pull_intensity := clampf(drag_length / max_expected_drag, 0.0, 1.0)

	# Optional: If you use an AnimatedSprite2D, you could change frames here:
	# rod_sprite.frame = int(pull_intensity * max_frames)

	# For now, we simulate rod bending by dynamically rotating/scaling it
	var drag_dir := signf(input_system.get_drag_vector().x)
	var target_rotation := pull_intensity * (PI / 4.0) * drag_dir # Bends up to 45 degrees

	rod_sprite.rotation = lerp_angle(rod_sprite.rotation, target_rotation, 15.0 * delta)
