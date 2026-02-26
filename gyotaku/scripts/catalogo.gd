extends Button
@onready var peixe: Node2D = $"../../Peixe"

func _on_pressed() -> void:
	print("1")
	peixe.salvar_imagem()
	Global.ultimo_peixe_carimbado = peixe.tipo
	print("2")
	Transicao.mudar_cena("res://scenes/minigames/catalogo.tscn")
	
