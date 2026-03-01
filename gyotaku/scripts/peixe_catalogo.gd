extends SubViewport


@export var tipo: String
@onready var peixe: Sprite2D = $Peixe

#Sprites
const GURUKUN = preload("uid://dk8bybnxddsr")
const RAYA = preload("uid://looocptmvug0")
const ENGUIA_DEMONIO = preload("uid://cx7h8s5lxtmmw")
const PEIXE_FANTASMA = preload("uid://drxxqsnpsgngb")


func atualizar_peixe(novo_tipo: String) -> void:
	tipo = novo_tipo
	print("tipo peixe catalogo: " + tipo)

	peixe.texture = retornar_tipo()

	var pintura_arquivo = pegar_pintura(tipo)

	peixe.visible = true

	(peixe.material as ShaderMaterial).set_shader_parameter("pintura_tex", pintura_arquivo)
	# Cannot call method 'get_size' on a null value.
	var tamanho_do_peixe = peixe.texture.get_size()
	(peixe.material as ShaderMaterial).set_shader_parameter("fish_size", tamanho_do_peixe)

func retornar_tipo():
	match tipo:
		"gurukun":
			return GURUKUN
		"arraia":
			return RAYA
		"eel_demon":
			return ENGUIA_DEMONIO
		"ghost_fish":
			return PEIXE_FANTASMA

func pegar_pintura(nome_do_peixe: String) -> Texture2D:
	var caminho_do_arquivo = "user://" + nome_do_peixe + ".png"

	if FileAccess.file_exists(caminho_do_arquivo):
		var imagem_salva = Image.load_from_file(caminho_do_arquivo)
		var textura_final = ImageTexture.create_from_image(imagem_salva)
		return textura_final
	else:
		#Criar imagem preta se não tiver o arquivo
		var imagem_preta = Image.create_empty(500, 300, false, Image.FORMAT_RGBA8)
		imagem_preta.fill(Color.BLACK)

		# Converte pra textura e manda pro Shader
		return ImageTexture.create_from_image(imagem_preta)
