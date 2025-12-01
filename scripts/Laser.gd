extends RayCast3D
class_name laser_obj

@onready var beam_root: Node3D = $Beam_Root
@onready var bulb_root: Node3D = $Bulb_Root
@onready var end_root: Node3D = $End_Root
@onready var particles: GPUParticles3D = $End_Root/GPUParticles3D
@onready var damage_zone: Area3D = $End_Root/DamageArea

@onready var timer: Timer = $Timer


@export var opening_curve : Curve
@export var curve: Curve
@export var closing_curve : Curve

@export var opening_duration : float = 0.4
@export var duration := 2.0
@export var close_duration : float = 0.5
var t := 0.0

enum laser {on,off}
var laser_state = laser.on
var track_state = laser.off
var change : bool = false




func ready():
	if laser_state == laser.off:
		beam_root.scale.x = 0.01
		beam_root.scale.z = 0.01
			
		#bulb root
		bulb_root.scale = Vector3(0.01,0.01,0.01)






func _process(delta : float) -> void:
	
	damage_zone.monitoring = true
	var cast_point
	force_raycast_update()
	

	if laser_state == laser.on and track_state == laser.off:
		if change == true:
			change = false
			t = 0.0
		beam_open()
	elif laser_state == laser.off and track_state == laser.on:
		if change == true:
			change = false
			t = 0.0
		beam_close()
	elif laser_state == laser.on:
		beam_root_pulse()
		pass
		
	if laser_state == laser.off and track_state == laser.off:
		visible = false
	else:
		damage_enemies()
		visible = true

	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		beam_root.scale.y = -cast_point.y
		end_root.position = cast_point
	else:
		beam_root.scale.y = -target_position.y
	
	if laser_state == laser.on:
		particles.emitting = true
	else:
		particles.emitting = false
		
	



func beam_root_pulse():
	if t < duration:
		#beam root
		t += get_process_delta_time()
		var u = t / duration
		var scale_value = curve.sample(u)
		beam_root.scale.x = scale_value
		beam_root.scale.z = scale_value
		
		#bulb root
		bulb_root.scale = Vector3.ONE * scale_value
	else:
		
		#beam root
		beam_root.scale.x = curve.sample(1.0)
		beam_root.scale.z = curve.sample(1.0)
		t = 0.0
		
		#beam origin
		bulb_root.scale = Vector3.ONE * curve.sample(1.0)


func beam_open():
	if t < opening_duration:
		#beam root
		t += get_process_delta_time()
		var u = t / opening_duration
		var scale_value = opening_curve.sample(u)
		beam_root.scale.x = scale_value
		beam_root.scale.z = scale_value
		
		#bulb root
		bulb_root.scale = Vector3.ONE * scale_value
		end_root.scale = Vector3.ONE * scale_value
	else:
		track_state = laser.on
		change = true

func beam_close():
	if t < close_duration:
		#beam root
		t += get_process_delta_time()
		var u = t / close_duration
		var scale_value = closing_curve.sample(u)
		beam_root.scale.x = scale_value
		beam_root.scale.z = scale_value
		
		#bulb root
		bulb_root.scale = Vector3.ONE * scale_value
		end_root.scale = Vector3.ONE * scale_value
	else:
		track_state = laser.off
		change = true





var hit_array : Array

func _on_damage_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		hit_array.append(body)

func _on_damage_area_body_exited(body: Node3D) -> void:
	hit_array.erase(body)
	pass # Replace with function body.

func damage_enemies():
	for player in hit_array:
		player.get_hit()
	
	pass
