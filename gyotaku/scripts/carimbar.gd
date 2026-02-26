extends Button

@onready var peixe_catalogo: SubViewport = $"../PeixeCatalogo"

func _on_pressed() -> void:
	Global.peixe_a_carimbar = peixe_catalogo.tipo
	get_tree().change_scene_to_file("res://scenes/minigames/carimbo.tscn")
