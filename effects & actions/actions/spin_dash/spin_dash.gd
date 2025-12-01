extends Node3D
class_name spin_dash

@export var target_body : Node3D
@export var mesh_root : Node3D
@export var target_aim : Node3D

@export var spin_dash_duration : float = 0.4

var target_rotation_degrees = Vector3(0,360,0)

var in_spin_dash : bool = false

var can_spin_dash : bool = true

@onready var cooldown: Timer = $Cooldown
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var damage_zone: damage_area = $Area3D





func _trigger():
	
	if !can_spin_dash:
		return
		
	in_spin_dash = true
	can_spin_dash = false
	cooldown.start()
	
	particles.restart()
	
	
	
	#dash
	var H_Input = Input.get_axis("left", "right")
	var V_Input = Input.get_axis("up", "down")
	
	var target_direction = Vector3(H_Input, 0, V_Input).normalized()
	
	target_body.velocity = target_direction * 70
	
	#spin
	if H_Input != 0:
		target_rotation_degrees = abs(target_rotation_degrees) * H_Input
	start_spin_animation(0.4)
	
	
func start_spin_animation(duration: float) -> void:
	var start_rotation = mesh_root.rotation_degrees
	
	var tween = create_tween()
	tween.tween_property(mesh_root, "rotation_degrees", start_rotation + target_rotation_degrees, duration)
	tween.set_ease(Tween.EASE_OUT) # Optional: for a smoother deceleration
	tween.set_trans(Tween.TRANS_BOUNCE) # Optional: for a specific transition type
	tween.finished.connect(reset_rotation)

func reset_rotation():
	in_spin_dash = false
	mesh_root.rotation_degrees -= target_rotation_degrees


func _on_cooldown_timeout() -> void:
	can_spin_dash = true
