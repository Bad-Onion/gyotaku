class_name PerspectiveTransitionController
extends Node


@export var main_camera: Camera2D
@export var boat: Node2D

@onready var surface_water_sprite: Sprite2D = %Background/OkinawaBackground/SurfaceWater/Water
@onready var ceiling_water_sprite: Sprite2D = %Background/OkinawaUnderwaterBackground/CeilingLayer/UnderwaterCeiling
@onready var depth_layer: ParallaxLayer = %Background/OkinawaUnderwaterBackground/DepthLayer

const BOAT_SURFACE_Y: float = 269.5
const BOAT_UNDERWATER_Y: float = 360.0
const WATERLINE_Y: float = 360.0

var _last_cam_y: float = 0.0
var _boat_target_y: float = BOAT_SURFACE_Y


func _ready() -> void:
	_setup_perfect_anchors()


func _process(_delta: float) -> void:
	_handle_perspective_transition()


func _handle_perspective_transition() -> void:
	if not main_camera: return

	var camera_y: float = main_camera.global_position.y

	if boat:
		var cam_delta: float = camera_y - _last_cam_y

		if cam_delta > 0.0 and cam_delta < 50.0:
			_boat_target_y += cam_delta

		_boat_target_y = min(_boat_target_y, BOAT_UNDERWATER_Y)
		boat.base_y = _boat_target_y

	_last_cam_y = camera_y

	var start_transition_y: float = 220.0
	var end_transition_y: float = 500.0
	var transition_weight: float = clamp((camera_y - start_transition_y) / (end_transition_y - start_transition_y), 0.0, 1.0)

	if surface_water_sprite:
		surface_water_sprite.scale.y = 1.0 - transition_weight

	if ceiling_water_sprite:
		ceiling_water_sprite.scale.y = transition_weight


func _setup_perfect_anchors() -> void:
	if surface_water_sprite and surface_water_sprite.texture:
		var tex_w: float = surface_water_sprite.texture.get_width()
		var tex_h: float = surface_water_sprite.texture.get_height()
		var start_x: float = surface_water_sprite.position.x

		if surface_water_sprite.centered:
			start_x -= tex_w / 2.0

		surface_water_sprite.centered = false
		surface_water_sprite.offset = Vector2(0, -tex_h)
		surface_water_sprite.position = Vector2(start_x, WATERLINE_Y)

	if ceiling_water_sprite and ceiling_water_sprite.texture:
		var tex_w: float = ceiling_water_sprite.texture.get_width()
		var start_x: float = ceiling_water_sprite.position.x

		if ceiling_water_sprite.centered:
			start_x -= tex_w / 2.0

		ceiling_water_sprite.centered = false
		ceiling_water_sprite.offset = Vector2(0, 0)
		ceiling_water_sprite.position = Vector2(start_x, WATERLINE_Y)
		ceiling_water_sprite.scale.y = 0.0
