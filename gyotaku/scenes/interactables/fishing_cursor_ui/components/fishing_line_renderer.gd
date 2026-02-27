class_name FishingLineRenderer
extends Line2D


@export var base_sag: float = 150.0
@export var line_segments: int = 20

var _current_tension_ratio: float = 0.0


func update_tension_visuals(current_tension: float, sweet_spot_min: float) -> void:
	_current_tension_ratio = clampf(remap(current_tension, 0.0, sweet_spot_min, 0.0, 1.0), 0.0, 1.0)


func update_line_points(start_position_global: Vector2, end_position_global: Vector2) -> void:
	var start_position = to_local(start_position_global)
	var end_position = to_local(end_position_global)

	var mid_point = (start_position + end_position) / 2.0

	var distance := start_position.distance_to(end_position)
	var dynamic_sag := minf(base_sag, distance * 0.5)

	var sag_amount = lerp(dynamic_sag, 0.0, _current_tension_ratio)
	var control_point = mid_point + Vector2(0, sag_amount)

	clear_points()

	# Bezier equation for quadratic curve -> B(t) = (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
	for i in range(line_segments + 1):
		var t = float(i) / line_segments
		var q0 = start_position.lerp(control_point, t)
		var q1 = control_point.lerp(end_position, t)

		add_point(q0.lerp(q1, t))
