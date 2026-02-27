extends Button


signal stamp_requested(fish_id: String)

@onready var peixe_catalogo: SubViewport = $"../PeixeCatalogo"


func _ready() -> void:
	for connection in pressed.get_connections():
		pressed.disconnect(connection.callable)

	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	stamp_requested.emit(peixe_catalogo.tipo)
