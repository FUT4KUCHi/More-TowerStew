extends Node3D
class_name HoldSocket

var item_stored: bool
var held_item_id: String = ""
var level: Node = null

func _ready():
	level = get_parent().get_parent()

func grab_item_from_fridge(item_id: String, target: String) -> void:
	var target_fridge = get_parent().radar_component.find_nearby_target(target, 3.0)
	var item_grabbing = level.get_item_data(item_id)
	if !item_stored and target_fridge is Fridge:
		held_item_id = item_id
		instantiate_item_scene()
		item_stored = true
		print("Item Grabbed from Fridge.")

func grab_item(item_id: String, target: String) -> void:
	var target_table = get_parent().radar_component.find_nearby_target(target, 3.0)
	var item_grabbing = level.get_item_data(item_id)
	if target_table:
		held_item_id = item_id
		instantiate_item_scene()
		item_stored = true
		target_table.remove_item_from_self()

func drop_item(target: String) -> void:
	if held_item_id:
		var dropping_to = get_parent().radar_component.find_nearby_target(target, 3.0)
		if dropping_to:
			dropping_to.get_item_data_from_socket(held_item_id)
			item_stored = false
		
		# Deleting the Instance from the Socket.
			remove_item_from_self()

# Helper Functions

func remove_item_from_self():
	item_stored = false
	held_item_id = ""
	for child in get_children():
		if child.is_in_group("Food"):
			child.queue_free()

func instantiate_item_scene():
	var item_id = level.get_item_data(held_item_id)
	if item_id:
		var instance = item_id.scene.instantiate()
		add_child(instance)
		instance.add_to_group("Food")
		instance.global_transform.origin = global_transform.origin
