extends Button

@onready var peixe_catalogo: SubViewport = $"../PeixeCatalogo"

func _on_pressed() -> void:
	Global.peixe_a_carimbar = peixe_catalogo.tipo
	Transicao.mudar_cena("res://scenes/minigames/carimbo.tscn",false)
