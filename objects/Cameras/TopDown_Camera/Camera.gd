extends Node3D

@export var targetNode : Node3D 
@export var stage_target : Node3D

var offset : Vector3 
var target_player : bool = true


func _ready():
	offset = position
	pass


func _physics_process(delta: float) -> void:
	
	if target_player:
		position = lerp(position, targetNode.position + offset, delta * 8)
	else:
		position = lerp(position, stage_target.position + offset, delta * 8)

func switch_to_stage_target():
	target_player = false
	pass

func switch_to_player_target():
	target_player = true
	pass
