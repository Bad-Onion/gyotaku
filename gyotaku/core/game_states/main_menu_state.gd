extends GameState


@export var main_menu_ui: MainMenu
@export var level_container: Node


func enter() -> void:
    get_tree().paused = false

    _clear_levels()

    main_menu_ui.show()
    main_menu_ui.play_requested.connect(_on_play_requested)
    main_menu_ui.quit_requested.connect(_on_quit_requested)


func exit() -> void:
    print("Exiting Main Menu State")
    main_menu_ui.hide()
    main_menu_ui.play_requested.disconnect(_on_play_requested)
    main_menu_ui.quit_requested.disconnect(_on_quit_requested)


func _on_play_requested() -> void:
    transitioned.emit(self , GameStates.State.PLAYING)


func _on_quit_requested() -> void:
    get_tree().quit()


func _clear_levels() -> void:
    for child in level_container.get_children():
        child.queue_free()


func get_id() -> int:
    return GameStates.State.MAIN_MENU
