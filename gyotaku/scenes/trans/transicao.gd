extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var sfx_transicao: AudioStreamPlayer = $SfxTransicao
@onready var musica_fundo: AudioStreamPlayer = $MusicaFundo
@onready var sfx_hover: AudioStreamPlayer = $SfxHover
@onready var sfx_click: AudioStreamPlayer = $SfxClick

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 0.0)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	get_tree().node_added.connect(_on_no_adicionado)
	
	_varrer_arvore_existente(get_tree().root)

func _varrer_arvore_existente(node: Node) -> void:
	#Atualiza os nós que carregarem antes do autoload
	_on_no_adicionado(node)
	for filho in node.get_children():
		_varrer_arvore_existente(filho)
	
func _on_no_adicionado(node: Node) -> void:
	#Pega os nos futuros
	if node is BaseButton:
		if not node.mouse_entered.is_connected(tocar_som_hover):
			node.mouse_entered.connect(tocar_som_hover)
		if node.name != "Salvar":
			if not node.button_down.is_connected(tocar_som_click):
				node.button_down.connect(tocar_som_click)

func tocar_som_hover() -> void:
	sfx_hover.play()

func tocar_som_click() -> void:
	sfx_click.play()
	
func mudar_cena(caminho_da_cena: String, tocar_sfx: bool) -> void:
	if tocar_sfx:
		sfx_transicao.play()

	var tween_escurecer = create_tween()
	tween_escurecer.tween_property(color_rect, "color:a", 1.0, 0.25)
	tween_escurecer.tween_interval(0.25)
	
	await tween_escurecer.finished
	
	get_tree().change_scene_to_file(caminho_da_cena)
	
	var tween_clarear = create_tween()
	tween_clarear.tween_interval(0.25)
	tween_clarear.tween_property(color_rect, "color:a", 0.0, 0.25)

func tocar_musica(nova_musica: AudioStream) -> void:
	if musica_fundo.stream == nova_musica:
		return
		
	if musica_fundo.playing == false:
		musica_fundo.stream = nova_musica
		musica_fundo.volume_db = -60.0 # Começa no mudo
		musica_fundo.play()
		
		var tween_fadein = create_tween()
		tween_fadein.tween_property(musica_fundo, "volume_db", 0.0, 1.0) # Leva 1 segundo pra chegar no volume max
		return

	var tween_crossfade = create_tween()
	
	tween_crossfade.tween_property(musica_fundo, "volume_db", -60.0, 1.0)
	await tween_crossfade.finished
	
	musica_fundo.stream = nova_musica
	musica_fundo.play()
	
	var tween_fadein = create_tween()
	tween_fadein.tween_property(musica_fundo, "volume_db", 0.0, 1.0)
