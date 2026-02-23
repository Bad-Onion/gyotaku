extends Button
@onready var peixe: Node2D = $"../../Peixe"

func _on_pressed() -> void:
	peixe.salvar_imagem()
	Global.ultimo_peixe_carimbado = peixe.tipo
	get_tree().change_scene_to_file("res://scenes/minigames/catalogo.tscn")
