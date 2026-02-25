extends Control

@onready var peixe_catalogo: SubViewport = $PeixeCatalogo
@onready var pintura: Sprite2D = $PeixeCatalogo/Peixe/Pintura
@onready var peixe: Sprite2D = $Peixe
@onready var caixa_de_texto: LineEdit = $NomeDoPeixe
@onready var desc: Label = $Desc
@onready var nome_cien: Label = $NomeCien

const CAMINHO_SAVE = "user://save_do_jogo.json" 

var tipo : String
var save_do_jogo : Dictionary = {} 
var regex = RegEx.new()

func _ready() -> void:
	caixa_de_texto.max_length = 16
	regex.compile("[^a-zA-Z0-9 áéíóúãõâêîôûçÁÉÍÓÚÃÕÂÊÎÔÛÇ]")
	Input.set_custom_mouse_cursor(null)

	carregar_save_completo()

	if Global.ultimo_peixe_carimbado != "":
		trocar_peixe_na_tela(Global.ultimo_peixe_carimbado)
	else:
		trocar_peixe_na_tela("gurukun")

func trocar_peixe_na_tela(novo_tipo: String):
	tipo = novo_tipo
	
	atualizar_textos_da_tela(tipo) 
	
	peixe_catalogo.atualizar_peixe(tipo)
	adicionar_peixe_ao_catalogo()

func adicionar_peixe_ao_catalogo():
	await get_tree().process_frame
	peixe.texture = peixe_catalogo.get_texture()

func _on_nome_do_peixe_text_changed(texto : String) -> void:
	var texto_limpo = regex.sub(texto, "", true)
	if texto_limpo != texto:
		var posicao_cursor = caixa_de_texto.caret_column
		caixa_de_texto.text = texto_limpo
		caixa_de_texto.caret_column = clamp(posicao_cursor - 1, 0, texto_limpo.length())
	
	save_text(texto_limpo)

func save_text(conteudo_digitado : String):
	if save_do_jogo.has(tipo):
		save_do_jogo[tipo]["apelido"] = conteudo_digitado
		
		var texto_json = JSON.stringify(save_do_jogo, "\t")
		
		var file = FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
		if file:
			file.store_string(texto_json)
			file.close()
		else:
			print("Erro em escrever no arquivo")

func carregar_save_completo():
	if FileAccess.file_exists(CAMINHO_SAVE):
		var file = FileAccess.open(CAMINHO_SAVE, FileAccess.READ)
		if file:
			var texto_do_arquivo = file.get_as_text()
			file.close()
			var json_convertido = JSON.parse_string(texto_do_arquivo)
			if json_convertido != null and typeof(json_convertido) == TYPE_DICTIONARY:
				save_do_jogo = json_convertido
			print("Save carregado na memória.")
		else:
			print("Erro para abrir o arquivo de save")
	else:
		print("Arquivo de save não encontrado no Catálogo.")

func atualizar_textos_da_tela(tipo_buscado : String):
	if save_do_jogo.has(tipo_buscado):
		caixa_de_texto.text = save_do_jogo[tipo_buscado]["apelido"]
		desc.text = save_do_jogo[tipo_buscado]["descricao"]
		nome_cien.text = save_do_jogo[tipo_buscado]["nome"]
	else:
		caixa_de_texto.text = ""
		desc.text = ""
		nome_cien.text = ""

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if caixa_de_texto.has_focus():
			caixa_de_texto.release_focus()
