extends Control


signal back_requested
signal stamp_requested(fish_id: String)


@export var catalog: FishCatalog

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

@onready var back_button: Button = %Sair


var tipo : String
var regex = RegEx.new()

var posicao_original_peixe_x : float

func _ready() -> void:
	caixa_de_texto.max_length = 16
	regex.compile("[^a-zA-Z0-9 áéíóúãõâêîôûçÁÉÍÓÚÃÕÂÊÎÔÛÇ]")
	Input.set_custom_mouse_cursor(null)

	posicao_original_peixe_x = peixe.global_position.x

	visibility_changed.connect(_on_visibility_changed)

	if back_button:
		for connection in back_button.pressed.get_connections():
			back_button.pressed.disconnect(connection.callable)
		back_button.pressed.connect(_on_back_pressed)

	if botao_carimbar:
		botao_carimbar.stamp_requested.connect(func(fish_id): stamp_requested.emit(fish_id))

	if not catalog:
		push_error("Catalogo resource missing! Arraste o main_catalog.tres para o Inspector.")


func atualizar_botoes_de_selecao(peixe_alvo: String = "") -> String:
	botoes_desbloqueados.clear()
	var primeiro_peixe = ""

	for botao in container_botoes.get_children():
		if botao is Button:
			botao.visible = false
			var id_peixe = botao.name

			var entry = catalog.get_entry(id_peixe)

			if entry and entry.is_caught:
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
	if tipo == "eel_demon":
		peixe.global_position.x = 280
		if peixe.material:
			peixe.material.set_shader_parameter("ativar_fade", true)
	elif tipo == "arraia" or tipo == "ghost_fish":
		peixe.global_position.x = 210
		if peixe.material:
			peixe.material.set_shader_parameter("ativar_fade", false)
	else:
		peixe.global_position.x = posicao_original_peixe_x
		if peixe.material:
			peixe.material.set_shader_parameter("ativar_fade", false)

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

	if catalog:
		catalog.set_fish_nickname(tipo, texto_limpo)

func atualizar_textos_da_tela(tipo_buscado : String):
	var entry = catalog.get_entry(tipo_buscado)

	if entry:
		caixa_de_texto.text = entry.nickname

		desc.text = entry.description
		nome_cien.text = entry.fish_name
	else:
		caixa_de_texto.text = ""
		desc.text = "Descrição desconhecida"
		nome_cien.text = "Desconhecido"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if caixa_de_texto.has_focus():
			caixa_de_texto.release_focus()


func _on_visibility_changed() -> void:
	if visible:
		var primeiro_peixe_disponivel = atualizar_botoes_de_selecao()

		if primeiro_peixe_disponivel != "":
			alternar_interface(true)
			trocar_peixe_na_tela(primeiro_peixe_disponivel)
		else:
			alternar_interface(false)


func _on_back_pressed() -> void:
	print("Catalog 'Sair' button pressed cleanly!")
	back_requested.emit()
