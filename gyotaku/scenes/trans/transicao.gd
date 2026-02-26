extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 0.0)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func mudar_cena(caminho_da_cena: String) -> void:
	var tween_escurecer = create_tween()
	tween_escurecer.tween_property(color_rect, "color:a", 1.0, 0.25)
	tween_escurecer.tween_interval(0.25)
	await tween_escurecer.finished
	get_tree().change_scene_to_file(caminho_da_cena)
	var tween_clarear = create_tween()
	tween_clarear.tween_interval(0.25)
	tween_clarear.tween_property(color_rect, "color:a", 0.0, 0.25)
