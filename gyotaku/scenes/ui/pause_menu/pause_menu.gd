class_name PauseMenu
extends Control


signal resume_requested
signal quit_to_menu_requested

@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
    resume_button.pressed.connect(_on_resume_button_pressed)
    quit_button.pressed.connect(_on_quit_button_pressed)


func _on_resume_button_pressed() -> void:
    resume_requested.emit()


func _on_quit_button_pressed() -> void:
    quit_to_menu_requested.emit()
