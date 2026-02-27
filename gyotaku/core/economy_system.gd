class_name EconomySystem
extends Node


signal coins_changed(total_coins: int, added_amount: int)


var current_coins: int = 0


func add_coins(amount: int) -> void:
	current_coins += amount
	coins_changed.emit(current_coins, amount)


func get_coins() -> int:
	return current_coins
