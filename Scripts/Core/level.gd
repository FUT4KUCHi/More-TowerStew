class_name Level
extends Node

@export var customer: PackedScene

@onready var timer: Timer = $Timer
@onready var seating_system: Node = $Systems/SeatingSystem

func _ready():
	_register_items()
	_register_customers()
	_spawn_customer()

var item_registry:= {}
var customer_registry:= {}

func _register_customers():
	customer_registry["emily"] = preload("res://Custom Resources/Customers/Emily.tres")
	customer_registry["austin"] = preload("res://Custom Resources/Customers/Austin.tres")
	customer_registry["tammy"] = preload("res://Custom Resources/Customers/Tammy.tres")

func _register_items():
	item_registry["tomato_soup"] = preload("res://Custom Resources/Food/TomatoSoup.tres")
	item_registry["chow_mein"] = preload("res://Custom Resources/Food/ChowMein.tres")
	item_registry["steak"] = preload("res://Custom Resources/Food/Steak.tres")

func get_item_data(id: String) -> ItemResource:
	return item_registry.get(id)

func get_customer_data(id: String) -> ItemResource:
	return customer_registry.get(id)

# Also assigns random attributes, commented out.
func _spawn_customer():
	var customer_instance: CharacterBody3D = customer.instantiate()
	if customer_instance:
		add_child(customer_instance)
		customer_instance.set_state(customer_instance.State.FIND_CHAIR)
		customer_instance.global_transform.origin = get_node("Door").global_transform.origin
		timer.start(5.0)
		# assign_random_customer_data(customer_resources, food_resources)
		# customer_instance.order_given.connect(_on_order_received_from_customer)
		# assign_random_customer_data()
		# customer_instance.position = Vector3(0, 0.5, 0)

# Spawns Customers on Timeout, disabled.
func _on_timer_timeout():
	_spawn_customer()
