extends Node2D

@export var tipo : String
@onready var sprite: Sprite2D = $Sprite
const GURUKUN = preload("uid://dt4rrortstg0f")
@onready var sombra: Sprite2D = $Sombra

func _ready() -> void:
	if tipo == "gurukun":
		sprite.texture = GURUKUN
		sombra.texture = GURUKUN
