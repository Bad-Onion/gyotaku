class_name MainMenu
extends Control


signal play_requested
signal quit_requested

@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton
@onready var menu_music_player: AudioStreamPlayer = %MenuMusicPlayer


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

	if is_visible_in_tree() and menu_music_player:
		menu_music_player.play()


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and menu_music_player:
		if is_visible_in_tree():
			menu_music_player.play()
		else:
			menu_music_player.stop()


func _on_play_button_pressed() -> void:
	play_requested.emit()


func _on_quit_button_pressed() -> void:
	quit_requested.emit()
