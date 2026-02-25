extends SubViewport

var ultimo_peixe_carimbado = Global.ultimo_peixe_carimbado
@export var tipo : String
@onready var peixe: Sprite2D = $Peixe

#Sprites (sem contornos):
#const GURUKUN = preload("uid://dgt8q1hy2ubhm")
#const RAYA = preload("uid://cvk6cnuie07k1")
#P&B
const GURUKUN = preload("uid://dk8bybnxddsr")
const RAYA = preload("uid://looocptmvug0")

func atualizar_peixe(novo_tipo: String) -> void:
	# Atualiza a variável pra valer
	tipo = novo_tipo
	
	if tipo == "gurukun":
		peixe.texture = GURUKUN
	elif tipo == "raya":
		peixe.texture = RAYA
		
	# Puxa o arquivo salvo
	var pintura_arquivo = pegar_pintura(tipo)
	
	if pintura_arquivo != null:
		peixe.visible = true
		(peixe.material as ShaderMaterial).set_shader_parameter("pintura_tex", pintura_arquivo)
		var tamanho_do_peixe = peixe.texture.get_size()
		(peixe.material as ShaderMaterial).set_shader_parameter("fish_size", tamanho_do_peixe)
	else:
		peixe.visible = false
	
func pegar_pintura(nome_do_peixe: String) -> Texture2D:
	var caminho_do_arquivo = "user://" + nome_do_peixe + ".png"
	
	if FileAccess.file_exists(caminho_do_arquivo):
		var imagem_salva = Image.load_from_file(caminho_do_arquivo)
		var textura_final = ImageTexture.create_from_image(imagem_salva)
		
		return textura_final
	else: 
		return null
