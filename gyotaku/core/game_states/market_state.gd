class_name MarketState
extends GameState


@export var market_ui: Control
@export var upgrades: FishingUpgrades
@export var economy_system: EconomySystem

# Temporary fixed costs
var reel_upgrade_cost: int = 10
var line_strength_cost: int = 10
var hook_depth_cost: int = 10
var bait_cost: int = 10

var _is_pausing: bool = false


func _ready() -> void:
	if market_ui:
		market_ui.back_requested.connect(_on_back_requested)
		market_ui.reel_upgrade_requested.connect(_on_reel_upgraded)
		market_ui.line_strength_upgrade_requested.connect(_on_line_strength_upgraded)
		market_ui.line_size_upgrade_requested.connect(_on_line_size_upgraded)
		market_ui.bait_upgrade_requested.connect(_on_bait_upgraded)

	var state_machine = get_parent()
	if state_machine is StateMachine:
		state_machine.state_changed.connect(_on_global_state_changed)


func get_id() -> int:
	return GameStates.State.MARKET


func enter() -> void:
	if _is_pausing:
		_is_pausing = false
		market_ui.resume_music()
	else:
		market_ui.show()
		market_ui.fade_in_music()

	get_tree().paused = true


func exit() -> void:
	if _is_pausing:
		market_ui.pause_music()
		pass
	else:
		market_ui.hide()
		market_ui.stop_music()
		get_tree().paused = false


func _on_back_requested() -> void:
	_is_pausing = false
	transitioned.emit(self, GameStates.State.PLAYING)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.UI_CANCEL):
		_is_pausing = true
		transitioned.emit(self, GameStates.State.PAUSED)


func _on_global_state_changed(new_state_id: int) -> void:
	if new_state_id == GameStates.State.MAIN_MENU:
		_is_pausing = false

		if market_ui:
			market_ui.hide()
			market_ui.stop_music()


func _on_reel_upgraded() -> void:
	if _try_purchase(reel_upgrade_cost):
		if upgrades: upgrades.upgrade_reel()


func _on_line_strength_upgraded() -> void:
	if _try_purchase(line_strength_cost):
		if upgrades: upgrades.upgrade_line_strength()


func _on_line_size_upgraded() -> void:
	if _try_purchase(hook_depth_cost):
		if upgrades: upgrades.upgrade_hook_depth()


func _on_bait_upgraded() -> void:
	if _try_purchase(bait_cost):
		if upgrades: upgrades.upgrade_bait()


func _try_purchase(cost: int) -> bool:
	if not economy_system:
		push_error("MarketState: EconomySystem is not assigned.")
		return false

	if economy_system.get_coins() >= cost:
		economy_system.add_coins(-cost)
		print("MarketState: You bought successfully")
		return true

	print("Not enough coins!") # Optional: Trigger a UI feedback signal here later
	return false
