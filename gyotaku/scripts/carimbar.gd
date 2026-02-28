extends Button


signal stamp_requested(fish_id: String)

@onready var peixe_catalogo: SubViewport = $"../PeixeCatalogo"
@onready var timer: Timer = $"../Timer"


func _ready() -> void:
	for connection in pressed.get_connections():
		pressed.disconnect(connection.callable)

	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Transicao.tocar_som_click()
	print("Tipo do peixe catalogo: " + peixe_catalogo.tipo)
	Global.peixe_a_carimbar = peixe_catalogo.tipo
	print("Peixe a carimbar: " + Global.peixe_a_carimbar)
	Transicao.mudar_cena()
	timer.start()

func _on_timer_timeout() -> void:
	stamp_requested.emit(peixe_catalogo.tipo)
