class_name FishingLineRenderer
extends Line2D


var _current_tension_ratio: float = 0.0


# TODO: Replace magic numbers with variables
func update_tension_visuals(current_tension: float, sweet_spot_min: float) -> void:
	_current_tension_ratio = clampf(remap(current_tension, 0.0, sweet_spot_min, 0.0, 1.0), 0.0, 1.0)


# TODO: Replace magic numbers with variables
func update_line_points(start_pos: Vector2, end_pos: Vector2) -> void:
	var mid_point = (start_pos + end_pos) / 2.0
	var sag_amount = lerp(150.0, 0.0, _current_tension_ratio)
	var control_point = mid_point + Vector2(0, sag_amount)

	clear_points()
	var segments = 20
	for i in range(segments + 1):
		var t = float(i) / segments
		var q0 = start_pos.lerp(control_point, t)
		var q1 = control_point.lerp(end_pos, t)
		add_point(q0.lerp(q1, t))
