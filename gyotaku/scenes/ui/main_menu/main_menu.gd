class_name MainMenu
extends Control


signal play_requested
signal quit_requested

@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
    play_button.pressed.connect(_on_play_button_pressed)
    quit_button.pressed.connect(_on_quit_button_pressed)


func _on_play_button_pressed() -> void:
    play_requested.emit()


func _on_quit_button_pressed() -> void:
    quit_requested.emit()
