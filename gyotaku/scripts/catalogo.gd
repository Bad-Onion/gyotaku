extends Button


signal stamp_finished


@onready var carimbo_sfx: AudioStreamPlayer = $"../../CarimboSfx"
@onready var peixe: Node2D = $"../../Peixe"


func _ready() -> void:
	for connection in pressed.get_connections():
		pressed.disconnect(connection.callable)

	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Global.ultimo_peixe_carimbado = peixe.tipo
	print("Ultimo peixe carimbado: " + Global.ultimo_peixe_carimbado)
	carimbo_sfx.play()
	peixe.salvar_imagem()
	stamp_finished.emit()
