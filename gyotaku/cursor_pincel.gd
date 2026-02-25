extends Node2D

@onready var imagem: Sprite2D = $"../Peixe/Sprite/Imagem"
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
	var current_anim_name = cursor_pincel.animation
	var current_frame_index = cursor_pincel.frame

	var texture: Texture2D = cursor_pincel.sprite_frames.get_frame_texture(current_anim_name, current_frame_index)

	if texture:
		var texture_size: Vector2 = texture.get_size()

		var actual_size: Vector2 = texture_size * cursor_pincel.scale
		
		return actual_size
	else:
		print("Could not get texture for current frame")
		return Vector2.ZERO
