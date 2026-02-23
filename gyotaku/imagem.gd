class_name Imagem

extends Sprite2D

@onready var peixetest: Sprite2D = $".."
@onready var cor_atual: ColorRect = $"../../../CorAtual"
#Cor inicial
@export var paint_color : Color = Color8(31,31,31):
	#Atualiza o indicador de cor atual
	set(value):
		paint_color = value
		cor_atual.color = value
var img_size
@export var init_brush_size = 10
var brush_size = init_brush_size
@export var cor_fundo : Color
@onready var brush_slide: HSlider = $"../../../HSlider"

var img : Image

func _ready() -> void:
	redefinir_imagem()
	
func redefinir_imagem():
	#Cria imagem branca vazia
	img_size = Vector2i(500,300)
	img = Image.create_empty(img_size.x, img_size.y, false, Image.FORMAT_RGBA8)
	img.fill(cor_fundo)
	texture = ImageTexture.create_from_image(img)
	#get_parent().material.set_shader_parameter("paint_texture", img)
	
func _paint_tex(pos) -> void:	
	#Pinta um retângulo de acordo com o brush size no mouse
	#img.fill_rect(Rect2i(pos, Vector2i(0,1)).grow(brush_size/2), paint_color)
	
	#Pinta um círculo
	var raio = brush_size / 2.0
	var raio_quadrado = raio * raio
	
	# Define a área quadrada (bounding box) ao redor do centro do pincel
	var min_x = int(pos.x - raio)
	var max_x = int(pos.x + raio)
	var min_y = int(pos.y - raio)
	var max_y = int(pos.y + raio)
	
	# Percorre os pixels dessa área quadrada
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			if x >= 0 and x < img_size.x and y >= 0 and y < img_size.y:
				# Calcula a distância do pixel atual até o centro do clique
				var distancia_quadrado = Vector2(x - pos.x, y - pos.y).length_squared()
				# Se a distância ao quadrado for menor ou igual ao raio ao quadrado, o pixel faz parte do círculo
				if distancia_quadrado <= raio_quadrado:
					img.set_pixel(x, y, paint_color)

func _input(event: InputEvent) -> void:
	#Inputs do mouse:
	if event is InputEventMouseButton:
		#Clique esquerdo pra pintar
		if event.pressed and event.is_echo() == false and event.button_index == MOUSE_BUTTON_LEFT:
			var lpos = to_local(event.position)
			var impos = lpos-offset+get_rect().size/2.0
			
			_paint_tex(impos)
			texture.update(img)
		#Clique direito pra usar conta gotas na posição do mouse
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var lpos = to_local(event.position)
			var impos = lpos-offset+get_rect().size/2.0
			
			paint_color = img.get_pixelv(impos)
	#CLicar e arrastar pra fazer linhas
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			var lpos = to_local(event.position)
			var impos = lpos-offset+get_rect().size/2.0
			
			# Suaviza as linhas criando mais pontos entre cada ponto
			if event.relative.length_squared() > 0:
				var num = ceili(event.relative.length())
				var target_pos = impos - (event.relative)
				for i in num:
					impos = impos.move_toward(target_pos, 1.0)
					_paint_tex(impos)
				
			texture.update(img)
		
func salvar_imagem() -> void:
	var file_path = "user://peixe.png"
	img.flip_y()
	var error = img.save_png(file_path)
	
	if error != OK:
		print("Deu erro")
		push_error("Could not save image to " + file_path)
	else:
		print("Image saved successfully to: " + file_path)
