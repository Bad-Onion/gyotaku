extends Button

@onready var imagem: Sprite2D = $"../../Peixe/Sprite/Imagem"

func _on_pressed() -> void:
	imagem.salvar_imagem()
