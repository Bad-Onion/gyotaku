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

@onready var info_panel: Control = %InfoPanel
@onready var info_name: Label = %InfoPanel/NameLabel
@onready var info_desc: Label = %InfoPanel/DescriptionLabel
@onready var info_price: Label = %InfoPanel/PriceLabel

@onready var purchase_sfx: AudioStreamPlayer = %PurchaseSFX

var fade_tween: Tween


func _ready() -> void:
	if upgrades:
		upgrades.upgrades_changed.connect(_on_upgrade_purchased)

	if economy_system:
		economy_system.coins_changed.connect(_on_coins_changed)

	# Click
	back_button.pressed.connect(func(): back_requested.emit())
	reel_btn.pressed.connect(func(): reel_upgrade_requested.emit())
	line_strength_btn.pressed.connect(func(): line_strength_upgrade_requested.emit())
	line_size_btn.pressed.connect(func(): line_size_upgrade_requested.emit())
	bait_btn.pressed.connect(func(): bait_upgrade_requested.emit())

	# Hover
	reel_btn.mouse_entered.connect(_on_hover_reel)
	line_strength_btn.mouse_entered.connect(_on_hover_line_strength)
	line_size_btn.mouse_entered.connect(_on_hover_line_size)
	bait_btn.mouse_entered.connect(_on_hover_bait)

	# Exit
	var clear_func = Callable(self, "_clear_info")
	reel_btn.mouse_exited.connect(clear_func)
	line_strength_btn.mouse_exited.connect(clear_func)
	line_size_btn.mouse_exited.connect(clear_func)
	bait_btn.mouse_exited.connect(clear_func)

	_clear_info()
	_update_market_display()


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


# Hover Logic
func _on_hover_reel() -> void:
	_show_info(upgrades.reel_name, upgrades.reel_description, upgrades.reel_cost)


func _on_hover_line_strength() -> void:
	_show_info(upgrades.line_strength_name, upgrades.line_strength_description, upgrades.line_strength_cost)


func _on_hover_line_size() -> void:
	_show_info(upgrades.hook_depth_name, upgrades.hook_depth_description, upgrades.hook_depth_cost)


func _on_hover_bait() -> void:
	_show_info(upgrades.bait_name, upgrades.bait_description, upgrades.bait_cost)


# Display Logic
func _show_info(item_name: String, description: String, cost: int) -> void:
	info_panel.show()
	info_name.text = item_name
	info_desc.text = description
	info_price.text = "Valor: " + str(cost)


func _clear_info() -> void:
	info_panel.hide()


func _update_market_display() -> void:
	if upgrades:
		reel_btn.visible = not upgrades.is_reel_bought
		line_strength_btn.visible = not upgrades.is_line_strength_bought
		line_size_btn.visible = not upgrades.is_hook_depth_bought
		bait_btn.visible = not upgrades.is_bait_bought

		_clear_info()


func _on_upgrade_purchased() -> void:
	if is_visible_in_tree():
		if upgrades and purchase_sfx and not purchase_sfx.playing:
			purchase_sfx.play()

	_update_market_display()
