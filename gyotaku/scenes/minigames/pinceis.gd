extends GridContainer

@onready var imagem: Sprite2D = $"../PeixeTeste/Peixetest/Imagem"

#Pega pincel certo quando clica nele:
func _ready() -> void:
	for c:ColorRect in get_children():
		c.gui_input.connect(func(input):
			if input is InputEventMouseButton:
				if input.pressed and input.button_index == MOUSE_BUTTON_LEFT:
					imagem.brush_size = int(c.name)
			)
