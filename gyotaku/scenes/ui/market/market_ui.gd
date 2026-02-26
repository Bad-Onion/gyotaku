extends Control


signal back_requested
signal reel_upgrade_requested
signal line_strength_upgrade_requested
signal line_size_upgrade_requested
signal bait_upgrade_requested


@export var economy_system: EconomySystem
@export var upgrades: FishingUpgrades

@onready var back_button: Button = %BackButton
@onready var market_music: AudioStreamPlayer = %MarketMusic

@onready var reel_btn: TextureButton = %SpinningReelUpgrade
@onready var line_strength_btn: TextureButton = %LineStrengthUpgrade
@onready var line_size_btn: TextureButton = %LineSizeUpgrade
@onready var bait_btn: TextureButton = %FoodBaitUpgrade
@onready var coin_hud: CoinHUD = %CoinHUD

@onready var reel_name: Label = %SpinningReelName
@onready var line_strength_name: Label = %LineStrengthName
@onready var line_size_name: Label = %LineSizeName
# @onready var bait_name: Label = %FoodBaitName

@onready var reel_cost: Label = %SpinningReelPrice
@onready var line_strength_cost: Label = %LineStrengthPrice
@onready var line_size_cost: Label = %LineSizePrice
# @onready var bait_cost: Label = %FoodBaitPrice

var fade_tween: Tween


func _ready() -> void:
	if economy_system:
		economy_system.coins_changed.connect(_on_coins_changed)

	back_button.pressed.connect(func(): back_requested.emit())
	reel_btn.pressed.connect(func(): reel_upgrade_requested.emit())
	line_strength_btn.pressed.connect(func(): line_strength_upgrade_requested.emit())
	line_size_btn.pressed.connect(func(): line_size_upgrade_requested.emit())
	bait_btn.pressed.connect(func(): bait_upgrade_requested.emit())

	_update_name_labels()
	_update_cost_labels()


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


func _on_coins_changed(total_coins: int, _added_amount: int) -> void:
	if coin_hud:
		coin_hud.update_coins(total_coins, 0)


func _update_cost_labels() -> void:
	if upgrades:
		reel_cost.text = str(upgrades.reel_cost)
		line_strength_cost.text = str(upgrades.line_strength_cost)
		line_size_cost.text = str(upgrades.hook_depth_cost)
		# bait_cost.text = str(upgrades.bait_cost)
	else:
		push_error("MarketUI: FishingUpgrades resource not assigned.")


func _update_name_labels() -> void:
	if upgrades:
		reel_name.text = str(upgrades.reel_name)
		line_strength_name.text = str(upgrades.line_strength_name)
		line_size_name.text = str(upgrades.hook_depth_name)
		# bait_name.text = str(upgrades.bait_name)
	else:
		push_error("MarketUI: FishingUpgrades resource not assigned.")
