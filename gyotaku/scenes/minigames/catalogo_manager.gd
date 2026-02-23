extends Control

@onready var peixe_catalogo: SubViewport = $PeixeCatalogo
@onready var pintura: Sprite2D = $PeixeCatalogo/Peixe/Pintura
@onready var peixe: TextureRect = $GridContainer/Peixe

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)

	if Global.ultimo_peixe_carimbado != "":
		trocar_peixe_na_tela(Global.ultimo_peixe_carimbado)
	else:
		trocar_peixe_na_tela("gurukun")

func trocar_peixe_na_tela(nome_do_peixe: String):
	# 1. Manda o SubViewport trocar as texturas internas dele
	peixe_catalogo.atualizar_peixe(nome_do_peixe)
	
	# 2. Pede pra atualizar a tela
	adicionar_peixe_ao_catalogo()

func adicionar_peixe_ao_catalogo():
	# Espera o SubViewport processar o Clip+Draw
	await get_tree().process_frame
	# Pega o resultado mesclado e joga na cara do jogador
	peixe.texture = peixe_catalogo.get_texture()
