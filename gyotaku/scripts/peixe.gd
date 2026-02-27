extends Node2D


@export var catalog: FishCatalog
@export var tipo : String

@onready var sprite: Sprite2D = $Sprite
@onready var imagem: Imagem = $Sprite/Imagem
@onready var sombra: Sprite2D = $Sombra

const GURUKUN = preload("uid://dt4rrortstg0f")
const RAYA = preload("uid://cvk6cnuie07k1")
const ENGUIA_DEMONIO = preload("uid://cruwc3xutb6wr")
const PEIXE_FANTASMA = preload("uid://dmfo171nmdaqw")


func inicializar(novo_tipo: String) -> void:
	tipo = novo_tipo
	sprite.texture = retornar_tipo()
	sombra.texture = retornar_tipo()


func retornar_tipo() -> Texture2D:
	match tipo:
		"gurukun":
			return GURUKUN
		"arraia":
			return RAYA
		"eel_demon":
			return ENGUIA_DEMONIO
		"ghost_fish":
			return PEIXE_FANTASMA

	return null


func salvar_imagem() -> void:
	var file_path = "user://" + tipo + ".png"

	if imagem.estaVazia == false:
		var error = imagem.img.save_png(file_path)
		if error != OK:
			push_error("Não foi possível salvar a imagem em " + file_path)
		else:
			print("Imagem salva com sucesso!")
			if catalog:
				catalog.mark_fish_stamped(tipo)
	else:
		if FileAccess.file_exists(file_path):
			DirAccess.remove_absolute(file_path)
			print("Carimbo apagado do HD!")

