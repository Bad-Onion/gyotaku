extends Button

@onready var imagem: Sprite2D = $"../../PeixeTeste/Peixetest/Imagem"
@onready var h_slider: HSlider = $"../HSlider"

func _on_pressed() -> void:
	imagem.redefinir_imagem()
	imagem.brush_size = imagem.init_brush_size
