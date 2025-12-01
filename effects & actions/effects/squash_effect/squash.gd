extends Node3D
class_name squash_effect

@export var squash_curve_up : Curve
@export var squash_curve_down : Curve

@export var effect_speed : float = 5.0
@export var target_mesh_root : Node3D


@onready var timer: Timer = $Timer
var timed_in : bool = false


var squash_init : bool = false
var stretch_init : bool = false

func _process(_delta: float) -> void:
	
	var time_value = (timer.wait_time - timer.time_left) * effect_speed * squash_curve_down.max_domain
	time_value = clamp(time_value, 0.0, squash_curve_down.max_domain)
	
	
	
	if squash_init and timed_in:
		target_mesh_root.scale.y = squash_curve_down.sample(time_value)
		target_mesh_root.scale.x = squash_curve_up.sample(time_value)
		target_mesh_root.scale.z = squash_curve_up.sample(time_value)
	elif stretch_init and timed_in:
		target_mesh_root.scale.y = squash_curve_up.sample(time_value)
		target_mesh_root.scale.x = squash_curve_down.sample(time_value)
		target_mesh_root.scale.z = squash_curve_down.sample(time_value)
	elif !timed_in:
		target_mesh_root.scale = Vector3.ONE

func start_stretch():
	stretch_init = true
	timed_in = true
	timer.start()

func start_squash():
	squash_init = true
	timed_in = true
	timer.start()

func _on_timer_timeout() -> void:
	timed_in = false
	squash_init = false
	stretch_init = false
