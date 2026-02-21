class_name Imagem

extends Sprite2D

@onready var cor_atual: ColorRect = $"../../../Panel/CorAtual"
#Cor inicial
@export var paint_color : Color = Color.RED :
	#Atualiza o indicador de cor atual
	set(value):
		paint_color = value
		cor_atual.color = value
@export var img_size = Vector2i(640,360)
@export var brush_size = 10
@export var cor_fundo : Color
@onready var brush_slide: HSlider = $"../../../Panel/HSlider"

var img : Image

func _ready() -> void:
	#Cria imagem branca vazia
	img = Image.create_empty(img_size.x, img_size.y, false, Image.FORMAT_RGBA8)
	#img.fill(cor_fundo)
	texture = ImageTexture.create_from_image(img)
	
func _paint_tex(pos) -> void:
	#Pinta um retângulo de acordo com o brush size no mouse
	img.fill_rect(Rect2i(pos, Vector2i(0,6)).grow(brush_size/2), paint_color)

func _process(delta: float) -> void:
	brush_size = brush_slide.value

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
	pass
