extends Control

@onready var peixe_catalogo: SubViewport = $PeixeCatalogo
@onready var pintura: Sprite2D = $PeixeCatalogo/Peixe/Pintura
@onready var peixe: Sprite2D = $Peixe
@onready var caixa_de_texto: LineEdit = $NomeDoPeixe
@onready var desc: Label = $Desc
@onready var nome_cien: Label = $NomeCien

@onready var container_botoes: Node = $Peixes
@onready var anterior: Button = $Anterior
@onready var proximo: Button = $Proximo
@onready var gosto_de_chamar: Label = $GostoDeChamar
@onready var era_assim: Label = $EraAssim

var pagina_atual : int = 0
const ITENS_POR_PAGINA : int = 5
var botoes_desbloqueados : Array[Button] = []

@onready var botao_carimbar: Button = $Carimbar
@onready var aviso_vazio: Label = $AvisoVazio

const CAMINHO_SAVE = "user://save_do_jogo.json" 

var save_do_jogo : Dictionary = {} 
var tipo : String
var regex = RegEx.new()

func _ready() -> void:
	caixa_de_texto.max_length = 16
	regex.compile("[^a-zA-Z0-9 áéíóúãõâêîôûçÁÉÍÓÚÃÕÂÊÎÔÛÇ]")
	Input.set_custom_mouse_cursor(null)

	carregar_save_completo()
	
	var primeiro_peixe_disponivel = atualizar_botoes_de_selecao()
	if primeiro_peixe_disponivel != "":
		alternar_interface(true)
		
		if Global.ultimo_peixe_carimbado != "" and save_do_jogo.has(Global.ultimo_peixe_carimbado) and save_do_jogo[Global.ultimo_peixe_carimbado]["pego"] == true:
			trocar_peixe_na_tela(Global.ultimo_peixe_carimbado)
		else:
			trocar_peixe_na_tela(primeiro_peixe_disponivel)
	else:
		# Se retornou "", é porque não tem nenhum botão visível
		alternar_interface(false)

func atualizar_botoes_de_selecao(peixe_alvo: String = "") -> String:
	botoes_desbloqueados.clear()
	var primeiro_peixe = ""

	for botao in container_botoes.get_children():
		if botao is Button: 
			botao.visible = false
			var id_peixe = botao.name 

			if save_do_jogo.has(id_peixe) and save_do_jogo[id_peixe]["pego"] == true:
				botoes_desbloqueados.append(botao)
				if primeiro_peixe == "":
					primeiro_peixe = id_peixe

	if peixe_alvo != "":
		for i in range(botoes_desbloqueados.size()):
			if botoes_desbloqueados[i].name == peixe_alvo:
				pagina_atual = i / ITENS_POR_PAGINA 
				break

	var indice_inicio = pagina_atual * ITENS_POR_PAGINA
	var indice_fim = indice_inicio + ITENS_POR_PAGINA

	for i in range(botoes_desbloqueados.size()):
		if i >= indice_inicio and i < indice_fim:
			botoes_desbloqueados[i].visible = true

	anterior.disabled = (pagina_atual == 0)
	proximo.disabled = (indice_fim >= botoes_desbloqueados.size())

	return primeiro_peixe

func _on_anterior_pressed() -> void:
	if pagina_atual > 0:
		pagina_atual -= 1
		atualizar_botoes_de_selecao()

func _on_proximo_pressed() -> void:
	if (pagina_atual + 1) * ITENS_POR_PAGINA < botoes_desbloqueados.size():
		pagina_atual += 1
		atualizar_botoes_de_selecao()

func alternar_interface(tem_peixe: bool):
	peixe.visible = tem_peixe
	caixa_de_texto.visible = tem_peixe
	desc.visible = tem_peixe
	nome_cien.visible = tem_peixe
	botao_carimbar.visible = tem_peixe
	gosto_de_chamar.visible = tem_peixe
	era_assim.visible = tem_peixe
	anterior.visible = tem_peixe
	proximo.visible = tem_peixe
	
	aviso_vazio.visible = !tem_peixe

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
		desc.text = "Descrição desconhecida"
		nome_cien.text = "Desconhecido"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if caixa_de_texto.has_focus():
			caixa_de_texto.release_focus()
