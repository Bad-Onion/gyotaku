extends AnimatedSprite2D

const LARGO = preload("uid://b1a51irwxqr5k")
@onready var imagem: Sprite2D = $"../PeixeTeste/Peixetest/Imagem"
@onready var scale_fac = imagem.brush_size

func _process(delta: float) -> void:
	
	var pos = get_global_mouse_position()
	pos.x = pos.x + (LARGO.get_size().x/2)
	pos.y = pos.y + (LARGO.get_size().x/2)
	global_position = pos
	
	scale.x = imagem.brush_size / scale_fac
	scale.y = imagem.brush_size / scale_fac
