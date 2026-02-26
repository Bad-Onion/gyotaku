extends Imagem

@onready var colorrect: ColorRect = $".."
@export var cor_alvo: Color

var esta_cheio = false

func _process(delta: float) -> void:
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == false:
	detectar_se_cheio()
	
func detectar_se_cheio() -> bool:
	var rect = colorrect.get_global_rect()
	if !esta_cheio:
		for x in range(rect.position.x,rect.position.x + rect.size.x):
			for y in range(rect.position.y, rect.position.y + rect.size.y):
				var cor_do_pixel = img.get_pixel(x, y)
				if cor_do_pixel != cor_alvo:
					print("não tá cheio")
					return false
	print("TÁ CHEIO!!!!")
	return true
