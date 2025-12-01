extends Node3D
class_name First_Person_Move

@export var TargetBody : CharacterBody3D
@export var TargetHead : Node3D
@export var camera : Camera3D


var h_input 
var v_input

var speed : float = 10
var accel : float = 20
var air_accel : float = 5

var gravity = 9.8
var sensitivity = 0.003

var bob_origin
var bob_freq = 2.0
var bob_amp = 0.05
var bob_t = 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	bob_origin = camera.position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		TargetHead.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	pass


func _physics_process(delta: float) -> void:
	#get player input
	h_input = Input.get_axis("left", "right")
	v_input = Input.get_axis("up", "down")
	
	
		#handle_movement
	if TargetBody.is_on_floor():
		#velocity.x = lerp(velocity.x, h_input * speed, delta * accel)
		TargetBody.velocity = lerp(TargetBody.velocity, TargetHead.transform.basis * Vector3(h_input, TargetBody.velocity.y, v_input).normalized() * speed, delta * accel)
	else:
		TargetBody.velocity = lerp(TargetBody.velocity, TargetHead.transform.basis * Vector3(h_input, 0, v_input).normalized() * speed + Vector3(0,TargetBody.velocity.y,0), delta * accel)
		TargetBody.velocity.y -= gravity
	
	bob_t += delta * TargetBody.velocity.length() * float(TargetBody.is_on_floor())
	camera.transform.origin = _headbob(bob_t) + bob_origin
	
	TargetBody.move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	
	return pos
