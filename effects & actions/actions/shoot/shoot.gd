extends Node3D
class_name shoot_action

@export var bullet_object : PackedScene

@export var bullet_origin : Marker3D
@export var fire_rate : float = 1.0
@export var fire_rate_rand : float = 0.3
@export var is_friendly : bool = false

var can_shoot : bool = true
var reloading : bool = false
@onready var fire_rate_timer: Timer = $Fire_Rate
@onready var reload: Timer = $Reload

var instance

func _trigger():
	if can_shoot:
		can_shoot = false
		fire_rate_timer.wait_time = fire_rate #+ randf_range(-fire_rate_rand, fire_rate_rand)
		fire_rate_timer.start()
			
		instance = bullet_object.instantiate()
		instance.position = bullet_origin.global_position
		instance.transform.basis = bullet_origin.global_transform.basis
		instance.is_friendly = is_friendly
		
		var bullet_directory = get_tree().get_first_node_in_group("BulletDirectory")
		if bullet_directory != null:
			bullet_directory.add_child(instance)
		else:
			add_child(instance)

func _reload():
	can_shoot = false
	reloading = true
	reload.start()




func _on_fire_rate_timeout() -> void:
	can_shoot = true

func _on_reload_timeout() -> void:
	reloading = false
	can_shoot = true
