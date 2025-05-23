extends Node3D

@export var resource: FoodResource

func _ready():
	add_to_group("Interactable")
	add_to_group("Food")
	var instance = resource.item.instantiate()
	add_child(instance)

func on_interact():
	return self
