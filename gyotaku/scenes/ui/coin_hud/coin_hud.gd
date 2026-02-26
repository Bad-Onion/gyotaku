class_name CoinHUD
extends Control


@export var economy_system: EconomySystem
@export var is_always_visible: bool = false
@export var display_duration: float = 3.0

@onready var total_label: Label = %TotalLabel
@onready var added_label: Label = %AddedLabel


var _original_added_label_position: Vector2
var _hide_timer: SceneTreeTimer


func _ready() -> void:
	_original_added_label_position = added_label.position
	added_label.modulate.a = 0.0

	if not is_always_visible:
		modulate.a = 0.0

	if economy_system:
		economy_system.coins_changed.connect(update_coins)


func update_coins(total: int, added: int = 0) -> void:
	total_label.text = str(total)

	if added > 0:
		added_label.text = "+" + str(added)
		_play_added_animation()
	else:
		added_label.modulate.a = 0.0

	if not is_always_visible:
		_show_temporarily()


func _show_temporarily() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)

	if _hide_timer:
		_hide_timer.disconnect("timeout", _on_hide_timeout)

	_hide_timer = get_tree().create_timer(display_duration)
	_hide_timer.timeout.connect(_on_hide_timeout)


func _on_hide_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)


func _play_added_animation() -> void:
	added_label.position = _original_added_label_position
	added_label.modulate.a = 1.0

	var tween = create_tween()
	tween.tween_property(added_label, "position:y", _original_added_label_position.y - 30.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(added_label, "modulate:a", 0.0, 1.0)
