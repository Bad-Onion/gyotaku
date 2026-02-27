class_name ButtonAudioComponent
extends Node


@export var hover_sfx: AudioStream
@export var press_sfx: AudioStream


var _audio_player: AudioStreamPlayer


func _ready() -> void:
	var parent := get_parent()

	if parent is BaseButton:
		_audio_player = AudioStreamPlayer.new()
		add_child(_audio_player)

		parent.mouse_entered.connect(_on_mouse_entered)
		parent.pressed.connect(_on_pressed)


func _on_mouse_entered() -> void:
	if hover_sfx:
		_audio_player.stream = hover_sfx
		_audio_player.play()


func _on_pressed() -> void:
	if press_sfx:
		_audio_player.stream = press_sfx
		_audio_player.play()
