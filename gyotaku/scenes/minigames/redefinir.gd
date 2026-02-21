extends Button

@onready var imagem: Sprite2D = $"../../PeixeTeste/Peixetest/Imagem"

func _on_pressed() -> void:
	imagem.redefinir_imagem()
