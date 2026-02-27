class_name FishCatalog
extends Resource


signal catalog_changed


@export var entries: Array[FishEntry] = []


func get_entry(id: String) -> FishEntry:
	for entry in entries:
		if entry.id == id:
			return entry

	return null


func mark_fish_caught(id: String) -> void:
	var entry := get_entry(id)

	if entry:
		entry.mark_caught()
		catalog_changed.emit()


func mark_fish_stamped(id: String) -> void:
	var entry := get_entry(id)

	if entry:
		entry.mark_stamped()
		catalog_changed.emit()


func set_fish_nickname(id: String, new_nickname: String) -> void:
	var entry := get_entry(id)

	if entry:
		entry.set_nickname(new_nickname)
		catalog_changed.emit()
