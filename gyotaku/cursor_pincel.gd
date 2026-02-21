extends AnimatedSprite2D

@onready var imagem: Sprite2D = $"../../PeixeTeste/Peixetest/Imagem"
@onready var scale_fac = imagem.brush_size
@onready var cursor: Node2D = $".."

func _process(delta: float) -> void:
	
	cursor.global_position = get_global_mouse_position()
	
	cursor.scale.x = imagem.brush_size / scale_fac
	cursor.scale.y = imagem.brush_size / scale_fac
