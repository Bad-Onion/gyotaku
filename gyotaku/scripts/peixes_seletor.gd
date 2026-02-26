extends GridContainer

@onready var catalogo: Control = $".."

func _ready() -> void:
	for c:Button in get_children():
		c.gui_input.connect(func(input):
			if input is InputEventMouseButton:
				if input.pressed and input.button_index == MOUSE_BUTTON_LEFT:
					catalogo.trocar_peixe_na_tela(c.name)
			)
