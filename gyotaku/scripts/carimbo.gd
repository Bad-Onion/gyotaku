extends Control


signal stamp_finished

@onready var peixe: Node2D = %Peixe
@onready var finalize_button: Button = %Salvar

const cursor = preload("uid://coru6fhwvtq6i")
@onready var no_cursor: Node2D = $Cursor
@onready var pause_menu: PauseMenu = $"../PauseMenu"


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(0,0))

	if finalize_button:
		finalize_button.stamp_finished.connect(func(): stamp_finished.emit())

func _process(delta: float) -> void:
	if visible and !pause_menu.visible:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(0,0))
		no_cursor.visible = true
	else:
		Input.set_custom_mouse_cursor(null)
		no_cursor.visible = false

func initialize_fish(fish_id: String) -> void:
	if peixe and peixe.has_method("inicializar"):
		peixe.inicializar(Global.peixe_a_carimbar)


func _on_visibility_changed() -> void:
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
