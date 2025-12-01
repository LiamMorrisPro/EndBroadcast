extends Node3D
class_name rotate_to_motion

@export var mesh_root: Node3D
@export var rotation_speed : float = 10.0

var held_rotation : float

var active : bool = true

func _process(delta: float) -> void:
	
	if active == false:
		held_rotation = mesh_root.rotation.y
		return
	
	var h_input =  Input.get_axis("left", "right")
	var v_input =  Input.get_axis("up", "down")
	
	var target_rotation = atan2(h_input, v_input) - PI
	
	
	if abs(h_input) > 0.1 or abs(v_input) > 0.1:
		mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)
		held_rotation = target_rotation
	else:
		mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, held_rotation, rotation_speed * delta)
	
	
	
	
