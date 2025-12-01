extends Node
class_name lean_fx

@export var target_body : CharacterBody3D
@export var mesh_root : Node3D

var flipped : bool = false

func _process(delta: float) -> void:
	if flipped == false:
		mesh_root.rotation.z = lerp(mesh_root.rotation.z, deg_to_rad(-target_body.velocity.x * 2), delta * 10)
	else:
		mesh_root.rotation.z = lerp(mesh_root.rotation.z, deg_to_rad(target_body.velocity.x * 2), delta * 10)
	pass
