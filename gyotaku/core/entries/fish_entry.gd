class_name FishEntry
extends Resource


signal entry_updated


@export var id: String = ""
@export var fish_name: String = ""
@export var nickname: String = ""
@export_multiline var description: String = ""


var is_caught: bool = false
var is_stamped: bool = false


func mark_caught() -> void:
	if not is_caught:
		is_caught = true
		entry_updated.emit()


func mark_stamped() -> void:
	if not is_stamped:
		is_stamped = true
		entry_updated.emit()


func set_nickname(new_name: String) -> void:
	if nickname != new_name:
		nickname = new_name
		entry_updated.emit()
