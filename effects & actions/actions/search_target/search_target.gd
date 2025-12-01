extends Node3D
class_name search_target

@export var agent_body: CharacterBody3D

var target_array : Array
var current_target : Node3D
var target_current_position : Vector3

@onready var ray_cast: RayCast3D = $FollowingRay/RayCast3D

var botnet : Bot_Net
var in_botnet : bool = false


@onready var collision_shape: CollisionShape3D = $Area3D/CollisionShape3D

var initial_range : float 



func _ready() -> void:
	if agent_body.get_parent().is_in_group("BotNet"):
		in_botnet = true
		botnet = agent_body.get_parent()
	
	initial_range =collision_shape.shape.radius

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target_array.append(body)
		current_target = target_array[0]
	

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target_array.erase(body)
		if !target_array.is_empty():
			current_target = target_array[0]


func check_if_visible() -> bool:
	
	if agent_body.canSeeTarget:
		collision_shape.shape.radius = initial_range + 30
	else:
		collision_shape.shape.radius = initial_range

	
	
	
	
	if target_array.is_empty():
		return false
		
	ray_cast.target_position = current_target.global_position - ray_cast.global_position + Vector3(0,1,0)
	
	if !ray_cast.is_colliding():
		return false
	
	if ray_cast.get_collider().is_in_group("Player"):
		target_current_position = current_target.global_position
		return true
	else:
		return false
