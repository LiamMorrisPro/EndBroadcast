extends Node3D
class_name Pathfinder



@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var agent_body : CharacterBody3D

var target : Node3D
var target_position : Vector3
var target_step : Vector3

var target_range : float = 10.0
var slack : float = 2.0

var speed : float = 7.0


func _ready():
	target_position = global_position





func _physics_process(_delta: float) -> void:
	
	if agent_body.canSeeTarget == false:
		target_range = 1.0
	else:
		target_range = 10.0
	
	
	target_position = agent_body.target_position
	
	#pathfind to target position
	nav_agent.set_target_position(target_position)
	target_step = nav_agent.get_next_path_position()
	var direction = (target_step - global_position).normalized()
	
	
	var target_distance = target_position - global_position
	if target_distance.length() > target_range + slack:
		nav_agent.set_velocity(direction * speed)
	elif target_distance.length() < target_range - slack:
		nav_agent.set_velocity(-direction * speed)
	else:
		nav_agent.set_velocity(Vector3.ZERO)
	



func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	agent_body.velocity = lerp(agent_body.velocity ,safe_velocity, get_physics_process_delta_time() * 3)
	agent_body.move_and_slide()
