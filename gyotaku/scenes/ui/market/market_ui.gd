extends Control


signal back_requested

@onready var back_button: Button = %BackButton
@onready var market_music: AudioStreamPlayer = $MarketMusic

var fade_tween: Tween


func _ready() -> void:
	back_button.pressed.connect(func(): back_requested.emit())


func fade_in_music(duration: float = 1.5) -> void:
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()

	market_music.volume_db = -60.0
	market_music.play()

	fade_tween = create_tween()
	fade_tween.tween_property(market_music, "volume_db", 0.0, duration)


func stop_music() -> void:
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()

	market_music.stop()
