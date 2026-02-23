extends SubViewport

var ultimo_peixe_carimbado = Global.ultimo_peixe_carimbado
@export var tipo : String
@onready var peixe: Sprite2D = $Peixe
@onready var pintura: Sprite2D = $Peixe/Pintura

#Sprites (sem contornos):
const GURUKUN = preload("uid://dgt8q1hy2ubhm")
const RAYA = preload("uid://cvk6cnuie07k1")

func _ready() -> void:
	if ultimo_peixe_carimbado != null:
		tipo = ultimo_peixe_carimbado
	
	if tipo == "gurukun":
		peixe.texture = GURUKUN
	if tipo == "raya":
		peixe.texture = RAYA
		
	var pintura_arquivo = pegar_pintura(tipo)
	pintura.texture = pintura_arquivo
func pegar_pintura(nome_do_peixe: String) -> Texture2D:
	var caminho_do_arquivo = "user://" + tipo + ".png"
	
	if FileAccess.file_exists(caminho_do_arquivo):
		var imagem_salva = Image.load_from_file(caminho_do_arquivo)
		var textura_final = ImageTexture.create_from_image(imagem_salva)
		
		return textura_final
	else: return null
