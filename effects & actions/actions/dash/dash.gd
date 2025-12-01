extends Node3D
class_name dash

@export var target_body : top_down_player
@onready var dash_cooldown: Timer = $Dash_Cooldown
@onready var Iframe_timer: Timer = $IFrameTimer




var target_rotation_degrees = Vector3(0,360,0)
var can_dash : bool = true
var cooldown : float = 0.7
var IFrames : float = 0.5

func _ready():
	dash_cooldown.wait_time = cooldown
	Iframe_timer.wait_time = IFrames
	pass

func _trigger():
	#dash
	if can_dash == true:
		dash_cooldown.start()
		Iframe_timer.start()
		can_dash = false
		target_body.can_take_damage = false
		var H_Input = Input.get_axis("left", "right")
		var V_Input = Input.get_axis("up", "down")
		
		var target_direction = Vector3(H_Input, 0, V_Input).normalized()
		
		target_body.velocity = target_direction * 100
	


func _on_timer_timeout() -> void:
	can_dash = true

func _on_i_frame_timer_timeout() -> void:
	target_body.can_take_damage = true
