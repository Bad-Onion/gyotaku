class_name WaterVisuals
extends ColorRect


@onready var _material: ShaderMaterial = material as ShaderMaterial


func set_wave_intensity(amplitude: float, speed: float) -> void:
	if _material:
		_material.set_shader_parameter("wave_amplitude", amplitude)
		_material.set_shader_parameter("wave_speed", speed)


func set_water_color(water_color: Color) -> void:
	if _material:
		_material.set_shader_parameter("water_tint", water_color)
