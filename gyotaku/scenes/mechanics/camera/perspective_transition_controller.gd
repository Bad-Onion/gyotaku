class_name PerspectiveTransitionController
extends Node


@export var main_camera: Camera2D
@export var boat: Node2D
@export var gap_filler_layer: CanvasLayer

@onready var surface_water_sprite: AnimatedSprite2D = %Background/OkinawaBackground/SurfaceWater/Water
@onready var ceiling_water_sprite: Sprite2D = %Background/OkinawaUnderwaterBackground/CeilingLayer/UnderwaterCeiling
@onready var depth_layer: ParallaxLayer = %Background/OkinawaUnderwaterBackground/DepthLayer

const BOAT_SURFACE_Y: float = 269.5
const BOAT_UNDERWATER_Y: float = 360.0
const WATERLINE_Y: float = 360.0


func _ready() -> void:
	_setup_perfect_anchors()
	_setup_rendering_order()


func _process(_delta: float) -> void:
	_handle_perspective_transition()


func _handle_perspective_transition() -> void:
	if not main_camera: return

	var camera_y: float = main_camera.get_screen_center_position().y

	var start_transition_y: float = 180.0
	var end_transition_y: float = 500.0
	var transition_weight: float = clamp((camera_y - start_transition_y) / (end_transition_y - start_transition_y), 0.0, 1.0)

	if boat:
		boat.base_y = lerp(BOAT_SURFACE_Y, BOAT_UNDERWATER_Y, transition_weight)

	if surface_water_sprite:
		surface_water_sprite.scale.y = 1.0 - transition_weight

	if ceiling_water_sprite:
		ceiling_water_sprite.scale.y = transition_weight * 1.2

	# TODO: This is completely bad practice but I don't have time now
	if gap_filler_layer:
		if camera_y >= 565.0 and camera_y <= 800.0:
			gap_filler_layer.layer = -2
		else:
			gap_filler_layer.layer = -3


func _setup_perfect_anchors() -> void:
	if surface_water_sprite and surface_water_sprite.sprite_frames:
		var current_anim: StringName = surface_water_sprite.animation
		var current_frame: int = surface_water_sprite.frame
		var tex: Texture2D = surface_water_sprite.sprite_frames.get_frame_texture(current_anim, current_frame)

		if tex:
			var tex_w: float = tex.get_width()
			var tex_h: float = tex.get_height()
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


func _setup_rendering_order() -> void:
	if ceiling_water_sprite and ceiling_water_sprite.get_parent():
		ceiling_water_sprite.get_parent().remove_child(ceiling_water_sprite)
		add_child(ceiling_water_sprite)

		ceiling_water_sprite.modulate.a = 0.9
		ceiling_water_sprite.z_index = 5

	if boat:
		boat.z_index = 0
