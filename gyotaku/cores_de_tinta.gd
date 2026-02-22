extends GridContainer

@onready var imagem: Sprite2D = $"../PeixeTeste/Peixetest/Imagem"

#Pega cor da paleta de cores quando clica nela
func _ready() -> void:
	for c:ColorRect in get_children():
		c.gui_input.connect(func(input):
			if input is InputEventMouseButton:
				if input.pressed and input.button_index == MOUSE_BUTTON_LEFT:
					imagem.paint_color = c.color
			)
