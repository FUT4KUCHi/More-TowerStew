class_name Fridge extends Node3D

@export var item: ItemResource

func _ready():
	add_to_group("Interactable")
	add_to_group("Fridge")

func on_interact():
	var level = get_tree().current_scene
	var food_keys = level.item_registry.keys()
	var item: ItemResource = level.item_registry[food_keys[randi() % food_keys.size()]]
	return item.id
