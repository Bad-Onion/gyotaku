class_name FishingCursorUI
extends Node2D


@export_group("Dependencies")
@export var mechanic_system: FishingMechanicSystem
@export var input_system: PlayerFishingInput
@export var hud_config: FishingHudConfig

@export_group("Nodes")
@onready var rod_sprite: AnimatedSprite2D = %RodSprite
@onready var arrow_sprite: Sprite2D = %ArrowSprite
@onready var fishing_line: FishingLineRenderer = %FishingLine
@onready var tip_marker: Marker2D = %RodSprite/TipMarker

var max_expected_drag: float = 150.0
var _current_tension: float = 0.0
var _drag_start_global: Vector2 = Vector2.ZERO
var _was_dragging: bool = false


func _ready() -> void:
	hide()


func activate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	show()

	if fishing_line:
		fishing_line.show()

	if mechanic_system and not mechanic_system.tension_updated.is_connected(_on_tension_updated):
		mechanic_system.tension_updated.connect(_on_tension_updated)


func deactivate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hide()

	if fishing_line:
		fishing_line.hide()

	if mechanic_system and mechanic_system.tension_updated.is_connected(_on_tension_updated):
		mechanic_system.tension_updated.disconnect(_on_tension_updated)


func _process(delta: float) -> void:
	if not visible or not mechanic_system or not input_system:
		return

	if Input.get_mouse_mode() != Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	if input_system.is_active():
		if not _was_dragging:
			_drag_start_global = global_position
			_was_dragging = true

		global_position = _drag_start_global + input_system.get_drag_vector()
	else:
		if _was_dragging:
			_was_dragging = false
			get_viewport().warp_mouse(global_position)
		else:
			global_position = get_global_mouse_position()

	_update_arrow()
	_update_rod(delta)
	_update_string_physics()


func _on_tension_updated(current: float, _max_val: float) -> void:
	_current_tension = current

	if fishing_line:
		fishing_line.update_tension_visuals(_current_tension, hud_config.sweet_spot_min)


func _update_arrow() -> void:
	var drag_vector := input_system.get_drag_vector()

	if input_system.is_active() and drag_vector.length() > 5.0:
		arrow_sprite.show()
		arrow_sprite.rotation = drag_vector.angle()
	else:
		arrow_sprite.hide()

	if _current_tension < hud_config.sweet_spot_min:
		arrow_sprite.modulate = hud_config.color_low
	elif _current_tension > hud_config.sweet_spot_max:
		arrow_sprite.modulate = hud_config.color_danger
	else:
		arrow_sprite.modulate = hud_config.color_perfect


func _update_rod(delta: float) -> void:
	var drag_length := input_system.get_drag_vector().length()
	var pull_intensity := clampf(drag_length / max_expected_drag, 0.0, 1.0)
	var drag_direction := signf(input_system.get_drag_vector().x)

	if drag_direction == 0:
		drag_direction = 1.0

	var target_rotation := pull_intensity * (PI / 4.0) * drag_direction
	rod_sprite.rotation = lerp_angle(rod_sprite.rotation, target_rotation, 15.0 * delta)


func _update_string_physics() -> void:
	var current_fish = mechanic_system.get_hooked_fish()

	if not current_fish or not tip_marker:
		fishing_line.clear_points()
		return

	var fish_screen_position = current_fish.get_global_transform_with_canvas().origin
	fishing_line.update_line_points(tip_marker.global_position, fish_screen_position)
