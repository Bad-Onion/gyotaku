extends Node2D

@export var tipo : String
@onready var sprite: Sprite2D = $Sprite
@onready var imagem: Imagem = $Sprite/Imagem
const GURUKUN = preload("uid://dt4rrortstg0f")
const RAYA = preload("uid://cvk6cnuie07k1")

const CAMINHO_SAVE = "user://save_do_jogo.json" 

var save_do_jogo : Dictionary = {}

@onready var sombra: Sprite2D = $Sombra

func _ready() -> void:
	carregar_save()
	
	if Global.peixe_a_carimbar != "":
		tipo = Global.peixe_a_carimbar
	
	if tipo == "gurukun":
		sprite.texture = GURUKUN
		sombra.texture = GURUKUN
	if tipo == "raya":
		sprite.texture = RAYA
		sombra.texture = RAYA

func salvar_imagem() -> void:
	var file_path = "user://" + tipo + ".png"
	
	if imagem.estaVazia == false:
		var error = imagem.img.save_png(file_path)
		if error != OK:
			push_error("Não foi possível salvar a imagem em " + file_path)
		else:
			print("Imagem salva com sucesso!")
			carimbar(true)
	else:
		# Se a tela tá vazia, joga o arquivo do carimbo no lixo
		if FileAccess.file_exists(file_path):
			DirAccess.remove_absolute(file_path)
			print("Carimbo apagado do HD!")
			carimbar(false)
			
func carregar_save():
	if FileAccess.file_exists(CAMINHO_SAVE):
		var file = FileAccess.open(CAMINHO_SAVE, FileAccess.READ)
		if file:
			var texto_do_arquivo = file.get_as_text()
			file.close()
			var json_convertido = JSON.parse_string(texto_do_arquivo)
			if json_convertido != null and typeof(json_convertido) == TYPE_DICTIONARY:
				save_do_jogo = json_convertido
			
func carimbar(carimbado : bool):
	if save_do_jogo.has(tipo):
			save_do_jogo[tipo]["carimbado"] = carimbado
			var texto_json = JSON.stringify(save_do_jogo, "\t")
			
			var file = FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
			if file:
				file.store_string(texto_json)
				file.close()
			else:
				print("Erro em escrever no arquivo")
