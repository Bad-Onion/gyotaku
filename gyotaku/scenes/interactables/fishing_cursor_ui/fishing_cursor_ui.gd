class_name FishingCursorUI
extends Node2D


@export_group("Dependencies")
@export var mechanic_system: FishingMechanicSystem
@export var input_system: PlayerFishingInput

@export_group("Nodes")
@onready var rod_sprite: Sprite2D = %RodSprite
@onready var arrow_sprite: Sprite2D = %ArrowSprite
@onready var fishing_line: Line2D = %FishingLine
@onready var tip_marker: Marker2D = %RodSprite/TipMarker

@export_group("Colors & Thresholds")
@export var color_low: Color = Color.YELLOW
@export var color_perfect: Color = Color.GREEN
@export var color_danger: Color = Color.RED
@export var sweet_spot_min: float = 30.0
@export var sweet_spot_max: float = 70.0

var max_expected_drag: float = 150.0


func _ready() -> void:
	hide()

	if fishing_line:
		fishing_line.top_level = true


func activate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	show()

	if fishing_line:
		fishing_line.show()


func deactivate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hide()

	if fishing_line:
		fishing_line.hide()


func _process(delta: float) -> void:
	if not visible or not mechanic_system or not input_system:
		return

	global_position = get_global_mouse_position()

	_update_arrow()
	_update_rod(delta)
	_update_string_physics()


func _update_arrow() -> void:
	var drag_vector := input_system.get_drag_vector()

	if input_system.is_active() and drag_vector.length() > 5.0:
		arrow_sprite.show()
		arrow_sprite.rotation = drag_vector.angle()
	else:
		arrow_sprite.hide()

	# Tint the arrow based on current tension
	var tension := mechanic_system.current_tension
	if tension < sweet_spot_min:
		arrow_sprite.modulate = color_low
	elif tension > sweet_spot_max:
		arrow_sprite.modulate = color_danger
	else:
		arrow_sprite.modulate = color_perfect


func _update_rod(delta: float) -> void:
	# Calculate how hard the player is pulling (0.0 to 1.0)
	var drag_length := input_system.get_drag_vector().length()
	var pull_intensity := clampf(drag_length / max_expected_drag, 0.0, 1.0)

	# When using a sprite sheet for the rod, change the frame based on pull_intensity
	# rod_sprite.frame = int(pull_intensity * max_frames)

	# For now, simulate rod bending by dynamically rotating/scaling it
	var drag_dir := signf(input_system.get_drag_vector().x)

	if drag_dir == 0:
		drag_dir = 1.0 # Default to right if no direction, to avoid NaN

	var target_rotation := pull_intensity * (PI / 4.0) * drag_dir # Bends up to 45 degrees

	rod_sprite.rotation = lerp_angle(rod_sprite.rotation, target_rotation, 15.0 * delta)


func _update_string_physics() -> void:
	# Se não houver peixe ou marcador, não desenha
	if not mechanic_system.fish or not tip_marker:
		fishing_line.clear_points()
		return

	var start_pos = tip_marker.global_position
	var end_pos = mechanic_system.fish.global_position

	# Calcular a tensão normalizada (0.0 a 1.0)
	# Tensão 0 = linha frouxa (muita curva)
	# Tensão 100 = linha esticada (reta)
	var tension_ratio = clampf(mechanic_system.current_tension / 100.0, 0.0, 1.0)

	# Criar curva de Bezier quadrática
	# O ponto de controle fica no meio, mas cai para baixo dependendo da "falta" de tensão
	var mid_point = (start_pos + end_pos) / 2.0

	# Quanto menor a tensão, mais a linha "cai" (sag)
	# Ajuste o valor 150.0 para controlar o quanto a linha cai
	var sag_amount = lerp(150.0, 0.0, tension_ratio)

	# Adiciona gravidade ao ponto de controle
	var control_point = mid_point + Vector2(0, sag_amount)

	# Desenhar a curva com segmentos suaves
	fishing_line.clear_points()
	var segments = 20
	for i in range(segments + 1):
		var t = float(i) / segments
		# Fórmula de Bezier Quadrática: (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
		var q0 = start_pos.lerp(control_point, t)
		var q1 = control_point.lerp(end_pos, t)
		var point = q0.lerp(q1, t)
		fishing_line.add_point(point)
