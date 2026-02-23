class_name BoatFloating
extends AnimatedSprite2D


@export var vertical_float_speed: float = 2.0
@export var vertical_float_amplitude: float = 3.0
@export var tilt_animation_speed: float = 1.5
@export var max_tilt_radians: float = 0.03

var base_y: float
var _time_passed: float = 0.0


func _ready() -> void:
	base_y = position.y

func _process(delta: float) -> void:
	_time_passed += delta
	position.y = base_y + sin(_time_passed * vertical_float_speed) * vertical_float_amplitude
	rotation = sin(_time_passed * tilt_animation_speed) * max_tilt_radians
