extends MeshInstance3D


@export var mesh_target : MeshInstance3D


func _process(_delta: float) -> void:
	mesh = mesh_target.mesh
	global_transform = mesh_target.global_transform
