class_name FishingAudioManager
extends Node


@export_group("Dependencies")
@export var fishing_mechanic_system: FishingMechanicSystem
@export var player_cast_state: PlayerCastState
@export var fishing_hook: Node2D

@export_group("Audio Players")
@export var bgm_calm_player: AudioStreamPlayer
@export var bgm_active_player: AudioStreamPlayer
@export var sfx_throw: AudioStreamPlayer
@export var sfx_splash: AudioStreamPlayer
@export var sfx_reel: AudioStreamPlayer

@export_group("Audio Streams")
@export var reel_slow: AudioStream
@export var reel_normal: AudioStream
@export var reel_fast: AudioStream

var _bgm_tween: Tween
const FADE_DURATION: float = 0.7
const MIN_VOL: float = -80.0
const MAX_VOL: float = 0.0


func _ready() -> void:
	_connect_signals()

	bgm_calm_player.volume_db = MAX_VOL
	bgm_active_player.volume_db = MIN_VOL


func _connect_signals() -> void:
	if fishing_mechanic_system:
		fishing_mechanic_system.minigame_started.connect(_on_minigame_started)
		fishing_mechanic_system.fish_caught.connect(_on_minigame_ended)
		fishing_mechanic_system.fish_caught.connect(_on_fish_caught)
		fishing_mechanic_system.fish_escaped.connect(_on_minigame_ended)
		fishing_mechanic_system.line_broke.connect(_on_minigame_ended)
		fishing_mechanic_system.tension_updated.connect(_on_tension_updated)

	if player_cast_state:
		player_cast_state.hook_casted.connect(_on_hook_casted)

	if fishing_hook:
		fishing_hook.water_entered.connect(_on_hook_water_entered)


# --- BGM ---
func _on_minigame_started() -> void:
	_crossfade_bgm(bgm_calm_player, bgm_active_player)


func _on_minigame_ended() -> void:
	_crossfade_bgm(bgm_active_player, bgm_calm_player)
	sfx_reel.stop()


func _crossfade_bgm(from_player: AudioStreamPlayer, to_player: AudioStreamPlayer) -> void:
	if _bgm_tween and _bgm_tween.is_valid():
		_bgm_tween.kill()

	_bgm_tween = create_tween()

	var current_position := from_player.get_playback_position()

	to_player.volume_db = MIN_VOL
	to_player.play(current_position)

	_bgm_tween.set_parallel(true)
	_bgm_tween.tween_property(from_player, "volume_db", MIN_VOL, FADE_DURATION)
	_bgm_tween.tween_property(to_player, "volume_db", MAX_VOL, FADE_DURATION)

	_bgm_tween.set_parallel(false)
	_bgm_tween.tween_callback(from_player.stop)


# --- SFX ---
func _on_hook_casted() -> void:
	sfx_throw.play()


func _on_fish_caught() -> void:
	sfx_splash.play()


func _on_hook_water_entered() -> void:
	sfx_splash.play()


func _on_tension_updated(current: float, max_val: float) -> void:
	var is_pulling: bool = fishing_mechanic_system.input_system.is_active()

	if not is_pulling or current == 0.0:
		sfx_reel.stop()
		return

	if not sfx_reel.playing:
		sfx_reel.play()

	var tension_ratio := current / max_val

	if tension_ratio > 0.8 and sfx_reel.stream != reel_fast:
		_play_reel_sound(reel_fast)
	elif tension_ratio > 0.4 and tension_ratio <= 0.8 and sfx_reel.stream != reel_normal:
		_play_reel_sound(reel_normal)
	elif tension_ratio <= 0.4 and sfx_reel.stream != reel_slow:
		_play_reel_sound(reel_slow)


func _play_reel_sound(stream: AudioStream) -> void:
	var playback_position := sfx_reel.get_playback_position()
	sfx_reel.stream = stream
	sfx_reel.play(playback_position)
