class_name Level1
extends Node2D


@onready var fishing_hook: FishingHook = %FishingHook
@onready var fishing_mechanic_system: FishingMechanicSystem = %FishingMechanicSystem
@onready var fishing_cursor_ui: FishingCursorUI = %FishingCursorUI

@onready var main_camera: FishingCamera = %MainCamera
@onready var boat: AnimatedSprite2D = %Boat

@onready var surface_water_sprite: Sprite2D = %Background/OkinawaBackground/SurfaceWater/Water
@onready var ceiling_water_sprite: Sprite2D = %Background/OkinawaUnderwaterBackground/CeilingLayer/UnderwaterCeiling

const BOAT_SURFACE_Y: float = 269.5
const BOAT_UNDERWATER_Y: float = 360.0
const WATERLINE_Y: float = 360.0

var _last_cam_y: float = 0.0
var _boat_target_y: float = BOAT_SURFACE_Y


func _ready() -> void:
	fishing_hook.fish_hooked.connect(_on_fish_hooked)
	fishing_mechanic_system.fish_caught.connect(_on_fish_caught)
	fishing_mechanic_system.fish_escaped.connect(_on_fish_escaped)
	fishing_mechanic_system.line_broke.connect(_on_line_broke)

	_setup_perfect_anchors()


func _process(_delta: float) -> void:
	_handle_perspective_transition()


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
	fishing_hook.reset()


func _handle_perspective_transition() -> void:
	if not main_camera: return

	var cam_y: float = main_camera.global_position.y

	if boat:
		var cam_delta: float = cam_y - _last_cam_y
		# If the delta is massive (camera snapped on frame 1), ignore it to prevent teleportation
		if cam_delta > 0.0 and cam_delta < 50.0:
			_boat_target_y += cam_delta

		_boat_target_y = min(_boat_target_y, BOAT_UNDERWATER_Y)
		boat.base_y = _boat_target_y

	_last_cam_y = cam_y

	# Calculate a single unified transition weight to ensure 0 gaps.
	var start_transition_y: float = 220.0
	var end_transition_y: float = 500.0
	var transition_weight: float = clamp((cam_y - start_transition_y) / (end_transition_y - start_transition_y), 0.0, 1.0)

	# Only shrink/grow. Do not touch position.y here so Parallax can do its job.
	if surface_water_sprite:
		surface_water_sprite.scale.y = 1.0 - transition_weight

	if ceiling_water_sprite:
		ceiling_water_sprite.scale.y = transition_weight

func _setup_perfect_anchors() -> void:
	# 1. Anchor Surface Water: Pivot at the BOTTOM edge, sitting exactly at Y=360
	if surface_water_sprite and surface_water_sprite.texture:
		var tex_w: float = surface_water_sprite.texture.get_width()
		var tex_h: float = surface_water_sprite.texture.get_height()
		var start_x: float = surface_water_sprite.position.x
		if surface_water_sprite.centered:
			start_x -= tex_w / 2.0

		surface_water_sprite.centered = false
		surface_water_sprite.offset = Vector2(0, -tex_h) # Forces pivot to the bottom
		surface_water_sprite.position = Vector2(start_x, WATERLINE_Y)

	# 2. Anchor Ceiling Water: Pivot at the TOP edge, sitting exactly at Y=360
	if ceiling_water_sprite and ceiling_water_sprite.texture:
		var tex_w: float = ceiling_water_sprite.texture.get_width()
		var start_x: float = ceiling_water_sprite.position.x
		if ceiling_water_sprite.centered:
			start_x -= tex_w / 2.0

		ceiling_water_sprite.centered = false
		ceiling_water_sprite.offset = Vector2(0, 0) # Forces pivot to the top
		ceiling_water_sprite.position = Vector2(start_x, WATERLINE_Y)
		ceiling_water_sprite.scale.y = 0.0
