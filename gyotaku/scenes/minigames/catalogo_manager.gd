extends Control

@onready var peixe_catalogo: SubViewport = $PeixeCatalogo
@onready var pintura: Sprite2D = $PeixeCatalogo/Peixe/Pintura
@onready var peixe: Sprite2D = $Peixe
@onready var caixa_de_texto: TextEdit = $NomeDoPeixe
const CAMINHO_SAVE = "user://nome_peixes.txt"
var tipo : String
var todos_os_nomes : Dictionary = {}

func _ready() -> void:

	Input.set_custom_mouse_cursor(null)

	if Global.ultimo_peixe_carimbado != "":
		trocar_peixe_na_tela(Global.ultimo_peixe_carimbado)
	else:
		trocar_peixe_na_tela("gurukun")

func trocar_peixe_na_tela(novo_tipo: String):
	tipo = novo_tipo
	load_text(tipo)
	# 1. Manda o SubViewport trocar as texturas internas dele
	peixe_catalogo.atualizar_peixe(tipo)
	
	# 2. Pede pra atualizar a tela
	adicionar_peixe_ao_catalogo()

func adicionar_peixe_ao_catalogo():
	# Espera o SubViewport processar o Clip+Draw
	await get_tree().process_frame
	# Pega o resultado mesclado e joga na cara do jogador
	peixe.texture = peixe_catalogo.get_texture()


func _on_nome_do_peixe_text_changed() -> void:
	save_text(caixa_de_texto.text)

func save_text(conteudo_digitado : String):
	todos_os_nomes[tipo] = conteudo_digitado
	var texto_json = JSON.stringify(todos_os_nomes)
	
	
	var file = FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
	if file:
		file.store_string(texto_json)
		file.close()
	else:
		print("Erro em escrever no arquivo")

func load_text(tipo_buscado : String):
	if FileAccess.file_exists(CAMINHO_SAVE):
		var file = FileAccess.open(CAMINHO_SAVE, FileAccess.READ)
		if file:
			var texto_do_arquivo = file.get_as_text()
			file.close()
			var json_convertido = JSON.parse_string(texto_do_arquivo)
			if json_convertido != null and typeof(json_convertido) == TYPE_DICTIONARY:
				todos_os_nomes = json_convertido
			print("Texto carregado.")
		else:
			print("Erro para abrir o arquivo")
	if todos_os_nomes.has(tipo_buscado):
		caixa_de_texto.text = todos_os_nomes[tipo_buscado]
	else:
		caixa_de_texto.text = ""
