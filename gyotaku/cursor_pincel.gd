extends Node2D

@onready var imagem: Sprite2D = $"../PeixeTeste/Peixetest/Imagem"
@onready var cursor_pincel: AnimatedSprite2D = $CursorPincel

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		cursor_pincel.play("click" + str(imagem.brush_size))
	elif imagem.brush_size != null:
		cursor_pincel.play("default" + str(imagem.brush_size))
		
	var offset_vector = get_size()
	var offset_y = offset_vector.y / (imagem.brush_size)
	cursor_pincel.offset = Vector2(0,offset_y)

func get_size() -> Vector2:
	# 1. Get the current animation's name and frame index
	var current_anim_name = cursor_pincel.animation
	var current_frame_index = cursor_pincel.frame

	# 2. Get the Texture2D resource for the current frame
	var texture: Texture2D = cursor_pincel.sprite_frames.get_frame_texture(current_anim_name, current_frame_index)

	if texture:
		# 3. Get the original size of the texture frame in pixels
		var texture_size: Vector2 = texture.get_size()

		# 4. Multiply by the node's scale to get the actual size in scene units
		var actual_size: Vector2 = texture_size * cursor_pincel.scale
		
		return actual_size
	else:
		print("Could not get texture for current frame")
		return Vector2.ZERO
