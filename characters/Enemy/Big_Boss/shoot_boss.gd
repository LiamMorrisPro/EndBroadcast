extends Node3D
class_name shoot_boss

@export var bullet_object : PackedScene

@export var fire_rate : float = 0.5
@export var fire_rate_rand : float = 0.3
@export var is_friendly : bool = false

var can_shoot : bool = true
@onready var fire_rate_timer: Timer = $Fire_Rate

@onready var aims: Node3D = $Aims
var offset : bool = false

func _trigger():
	fire_rate = 0.5
	if can_shoot:
		
		if offset == false:
			offset = true
			aims.rotation_degrees.y = 7.5
		elif offset == true:
			offset = false
			aims.rotation_degrees.y = 0
		
		can_shoot = false
		fire_rate_timer.wait_time = fire_rate #+ randf_range(-fire_rate_rand, fire_rate_rand)
		fire_rate_timer.start()
		
		for aim in aims.get_children():
			var bullet_origin = aim.get_child(0)
			var instance
			instance = bullet_object.instantiate()
			instance.position = bullet_origin.global_position
			instance.transform.basis = bullet_origin.global_transform.basis
			instance.is_friendly = is_friendly

			var bullet_directory = get_tree().get_first_node_in_group("BulletDirectory")
			if bullet_directory != null:
				bullet_directory.add_child(instance)
			else:
				add_child(instance)

var pattern = 0
func _trigger_2():
	if pattern == 0:
		pattern = 1
	else:
		pattern = 0
	
	fire_rate = 0.2
	
	if can_shoot:
		
		
		can_shoot = false
		fire_rate_timer.wait_time = fire_rate #+ randf_range(-fire_rate_rand, fire_rate_rand)
		fire_rate_timer.start()
		
		
		for aim in aims.get_children():
			if pattern == 0:
				pattern = 1
			
			elif pattern == 1:
				pattern = 0
				continue
			
			var bullet_origin = aim.get_child(0)
			var instance
			instance = bullet_object.instantiate()
			instance.position = bullet_origin.global_position
			instance.transform.basis = bullet_origin.global_transform.basis
			instance.is_friendly = is_friendly

			var bullet_directory = get_tree().get_first_node_in_group("BulletDirectory")
			if bullet_directory != null:
				bullet_directory.add_child(instance)
			else:
				add_child(instance)
		
	pass



func _on_fire_rate_timeout() -> void:
	can_shoot = true
