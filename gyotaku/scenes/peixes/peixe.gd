extends Node2D

@export var tipo : String
@onready var sprite: Sprite2D = $Sprite
@onready var imagem: Imagem = $Sprite/Imagem
const GURUKUN = preload("uid://dt4rrortstg0f")
const RAYA = preload("uid://cvk6cnuie07k1")

@onready var sombra: Sprite2D = $Sombra

func _ready() -> void:
	if tipo == "gurukun":
		sprite.texture = GURUKUN
		sombra.texture = GURUKUN
	if tipo == "raya":
		sprite.texture = RAYA
		sombra.texture = RAYA

func salvar_imagem() -> void:
	var file_path = "user://" + tipo + ".png"
	#imagem.img.flip_y()
	var error = imagem.img.save_png(file_path)
	
	if error != OK:
		print("Deu erro")
		push_error("Could not save image to " + file_path)
	else:
		print("Image saved successfully to: " + file_path)
