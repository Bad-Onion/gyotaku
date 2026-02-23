extends SubViewport

@export var tipo : String
@onready var peixe: Sprite2D = $Peixe
@onready var pintura: Sprite2D = $Peixe/Pintura

#Sprites:
const GURUKUN = preload("uid://dt4rrortstg0f")

func _ready() -> void:
	var pintura_arquivo = pegar_pintura(tipo)
	if tipo == "gurukun":
		peixe.texture = GURUKUN
		pintura.texture = pintura_arquivo
		
func pegar_pintura(tipo) -> Texture:
	return null
