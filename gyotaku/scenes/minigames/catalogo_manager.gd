extends Control

@onready var peixe_catalogo: SubViewport = $PeixeCatalogo
@onready var pintura: Sprite2D = $PeixeCatalogo/Peixe/Pintura
@onready var peixe: TextureRect = $GridContainer/Peixe

func _ready() -> void:
	adicionar_peixe_ao_catalogo(pintura.texture)

func adicionar_peixe_ao_catalogo(pintura_salva: Texture2D):
	# 1. Coloca a pintura que o jogador fez lá no estúdio invisível
	pintura.texture = pintura_salva
	
	# 2. Espera 1 frame pro Godot processar o Clip e o Multiply no SubViewport
	await get_tree().process_frame
	
	# 3. Pega o resultado pronto e joga na cara do jogador no catálogo!
	peixe.texture = peixe_catalogo.get_texture()
