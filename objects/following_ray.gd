extends Node3D

@export var node_to_follow : Node3D


func _physics_process(_delta: float) -> void:
	global_position = node_to_follow.global_position + Vector3(0,1,0)
