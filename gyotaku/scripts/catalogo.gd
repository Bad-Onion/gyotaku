extends Button


signal stamp_finished


@onready var peixe: Node2D = $"../../Peixe"


func _ready() -> void:
	for connection in pressed.get_connections():
		pressed.disconnect(connection.callable)

	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	peixe.salvar_imagem()
	stamp_finished.emit()

