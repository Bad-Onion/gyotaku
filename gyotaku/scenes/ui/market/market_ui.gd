extends Control


signal back_requested
signal reel_upgrade_requested
signal line_strength_upgrade_requested
signal line_size_upgrade_requested
signal bait_upgrade_requested

@onready var back_button: Button = %BackButton
@onready var market_music: AudioStreamPlayer = %MarketMusic

@onready var reel_btn: TextureButton = $UpgradesContainer/SpinningReelUpgrade
@onready var line_strength_btn: TextureButton = $UpgradesContainer/LineStrengthUpgrade
@onready var line_size_btn: TextureButton = $UpgradesContainer/LineSizeUpgrade
@onready var bait_btn: TextureButton = $UpgradesContainer/FoodBaitUpgrade

var fade_tween: Tween


func _ready() -> void:
	back_button.pressed.connect(func(): back_requested.emit())
	reel_btn.pressed.connect(func(): reel_upgrade_requested.emit())
	line_strength_btn.pressed.connect(func(): line_strength_upgrade_requested.emit())
	line_size_btn.pressed.connect(func(): line_size_upgrade_requested.emit())
	bait_btn.pressed.connect(func(): bait_upgrade_requested.emit())


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


func pause_music() -> void:
	market_music.stream_paused = true

	if fade_tween and fade_tween.is_valid():
		fade_tween.pause()


func resume_music() -> void:
	market_music.stream_paused = false

	if fade_tween and fade_tween.is_valid():
		fade_tween.play()
