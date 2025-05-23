extends Node3D
class_name Station

@onready var snap_point = $SnapPoint

var player_nearby: bool
var taken: bool = false
var assigned_customer: CharacterBody3D = null
var level: Node = null

var item_stored: bool
var stored_item_id: String = ""
var stored_visual_instance: Node = null

func _ready():
	add_to_group("SnappingPoints")
	add_to_group("Interactable")
	add_to_group("Station")
	level = get_parent().get_parent()
	$Indicator.visible = false

func instantiate_stored_item():
	pass

func give_item_to_table(item_id: String):
	# Player gives item to table
	if stored_visual_instance:
		stored_visual_instance.queue_free()  # Clear old visual if anystored_item_id = item_id
	stored_item_id = item_id
	var item_scene = level.get_item_data(item_id).scene
	stored_visual_instance = item_scene.instantiate()
	stored_visual_instance.add_to_group("Food")
	add_child(stored_visual_instance)  # Display item on table
	stored_visual_instance.global_transform.origin = snap_point.global_transform.origin
	item_stored = true

func take_item_from_table() -> String:
	item_stored = false
	for child in get_children():
		if child.is_in_group("Food"):
			child.queue_free()
			stored_item_id = ""
	if stored_item_id != "":
		return stored_item_id
	return ""

func _process(delta):
	if item_stored:
		%Item.text = ""
	if taken and item_stored:
		%Item.text = stored_item_id
	elif taken and item_stored == false:
		%Item.text = "Vacant"
	else:
		pass

func is_taken() -> bool:
	return taken

func set_taken(value: bool):
	taken = value

func assign_customer_to_table(customer: CharacterBody3D) -> void:
	taken = true
	assigned_customer = customer
	#if assigned_customer:
		#assigned_customer.check_order_item()
	#else:
		#print("Customer wasn't assigned to this table.")

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		print("Player is noticed.")
		if body.hold_socket.item_stored == true:
			print("Item exists in hold socket.")
			$Indicator.visible = true
			$Indicator/AnimationPlayer.play("Drop")

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		$Indicator.visible = false
		$Indicator/AnimationPlayer.stop()
