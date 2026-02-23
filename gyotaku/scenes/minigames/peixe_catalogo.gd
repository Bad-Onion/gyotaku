extends SubViewport

var ultimo_peixe_carimbado = Global.ultimo_peixe_carimbado
@export var tipo : String
@onready var peixe: Sprite2D = $Peixe
@onready var pintura: Sprite2D = $Peixe/Pintura

#Sprites (sem contornos):
const GURUKUN = preload("uid://dgt8q1hy2ubhm")
const RAYA = preload("uid://cvk6cnuie07k1")

func atualizar_peixe(novo_tipo: String) -> void:
	# Atualiza a variável pra valer
	tipo = novo_tipo
	
	if tipo == "gurukun":
		peixe.texture = GURUKUN
	elif tipo == "raya":
		peixe.texture = RAYA
		
	# Puxa o arquivo salvo
	var pintura_arquivo = pegar_pintura(tipo)
	
	# Aplica a pintura direto aqui. Não precisa retornar nada pro Control!
	pintura.texture = pintura_arquivo
	
func pegar_pintura(nome_do_peixe: String) -> Texture2D:
	# MUDANÇA AQUI: Usando o nome_do_peixe pra buscar o arquivo certo
	var caminho_do_arquivo = "user://" + nome_do_peixe + ".png"
	
	if FileAccess.file_exists(caminho_do_arquivo):
		var imagem_salva = Image.load_from_file(caminho_do_arquivo)
		var textura_final = ImageTexture.create_from_image(imagem_salva)
		
		return textura_final
	else: 
		return null
