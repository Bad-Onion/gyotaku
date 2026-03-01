class_name SharedUIMusic
extends AudioStreamPlayer

const CARIMBO = preload("uid://cv044wmmpvgig")

@export var state_machine: Node


func _ready() -> void:
	if state_machine and state_machine.has_signal("state_changed"):
		state_machine.state_changed.connect(_on_state_changed)


func _on_state_changed(new_state_id: int) -> void:
	var needs_music = (new_state_id == GameStates.State.CATALOG or new_state_id == GameStates.State.STAMP)
	if needs_music:
		Transicao.tocar_musica(CARIMBO)
	else:
		Transicao.parar_musica()
