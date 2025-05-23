extends Node

var current_item: Node = null

func set_item(item: Node) -> void:
	current_item = item

func get_item() -> Node:
	return current_item

func clear() -> void:
	current_item = null

func has_item() -> bool:
	return current_item != null
