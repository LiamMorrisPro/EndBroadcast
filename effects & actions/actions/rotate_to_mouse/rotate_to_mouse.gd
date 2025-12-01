extends Node3D
class_name rotate_to_mouse

var camera : Camera3D
@export var mesh_root: Node3D

var last_look_position : Vector3
var rotation_speed : float = 20.0


var active : bool = false

@onready var aim: Node3D = $"../../aim"

func _ready() -> void:
	
	camera = get_tree().get_first_node_in_group("Camera")
	pass


func _process(delta: float) -> void:


	var mouse_pos = get_viewport().get_mouse_position()
		
	var mouse_ray_start = camera.project_ray_origin(mouse_pos)
	var mouse_ray_target = mouse_ray_start + camera.project_ray_normal(mouse_pos) * 1000
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(mouse_ray_start, mouse_ray_target, 0b00000000_00000000_00000000_00010000)
	var result = space_state.intersect_ray(query)
	if result:
		last_look_position = result.position
		last_look_position.y = global_transform.origin.y
	
	
	if(last_look_position - global_transform.origin).length() < 1.0:
		return
	
	var dir = (last_look_position - global_transform.origin).normalized()
	var angle_y = atan2(dir.x, dir.z) - PI
	
	if active == true:
		mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, angle_y, rotation_speed * delta)
	
	aim.rotation.y = lerp_angle(aim.rotation.y, angle_y, rotation_speed * delta)

	
