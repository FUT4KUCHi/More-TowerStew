extends CharacterBody3D

@export_group("Movement")
@export var movement_speed: float = 5.00
@export var rotation_speed: float = 12.00
@export var acceleration: float = 0.1
@export var deceleration: float = 0.25

var movement_input_vector = Vector2.ZERO	
var last_movement_direction = Vector3.BACK
@onready var player_model = $MeshInstance3D # Player Model
@onready var hold_socket: Node3D = $HoldSocket # Item Socket
@onready var radar_component = $RadarComponent # RadarComponent

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var level
var nearby_stations
var points: int = 0

func _ready():
	add_to_group("Player")
	level = get_tree().current_scene
	%Points.text = "Points: " 

func _physics_process(delta):
	# Global.debug.add_property(" Item Holding:", hold_socket.item_stored, 1)
	if hold_socket.held_item_id:
		$HoldSocket/AnimationPlayer.play("rotation")
		%Label3D.text = "Item: " + hold_socket.held_item_id + " Holding: " + str(hold_socket.item_stored)
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if move_direction:
		velocity.x = lerp(velocity.x, move_direction.x * movement_speed, acceleration)
		velocity.z = lerp(velocity.z, move_direction.z * movement_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
		
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
	player_model.global_rotation.y = lerp_angle(player_model.rotation.y, target_angle, rotation_speed * delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		var target = radar_component.find_nearby_target("Interactable", 5.0)
		if target == null: return
		
		if target.is_in_group("Customer"):
			handle_customer(target)
		
		if target.is_in_group("TrashCan"):
			hold_socket.remove_item_from_self()
		
		if target.is_in_group("Fridge"):
			var item_id = target.on_interact()
			hold_socket.grab_item_from_fridge(item_id, "Fridge")
		
		if target.is_in_group("Table"):
			if hold_socket.item_stored == true:
				hold_socket.drop_item("Table")
			elif hold_socket.item_stored == false:
				print("This was called.")
				hold_socket.grab_item(target.stored_item_id, "Table")
			
func handle_customer(target) -> void:
	if target.current_state == 2:
		target.set_state(target.State.ORDERING)
	if target.current_state == target.State.ORDERING:
		target.set_state(target.State.WAITING)
		target.has_ordered = true
	if target.current_state == target.State.IMPATIENT:
		target.set_state(target.State.WAITING)

func point_increase():
	points += 50
	return points
