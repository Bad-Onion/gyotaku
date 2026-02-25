extends Button

@onready var imagem: Sprite2D = $"../../Peixe/Sprite/Imagem"
@onready var h_slider: HSlider = $"../HSlider"

func _on_pressed() -> void:
	imagem.criar_imagem_nova()
	imagem.brush_size = imagem.init_brush_size
