extends CharacterBody3D

@onready var laser_gun: Node3D = $LaserGun
@onready var search_player: search_target = $SearchPlayer

@onready var audio: audio_player = $Audio
@onready var explosion_fx: GPUParticles3D = $Particles/Explosion
@onready var damage_fx: damage_flash = $Damage_Flash

var canSeeTarget : bool = false
var target_position : Vector3

var health : int = 30



func _ready() -> void:
	laser_gun.active = false
	laser_gun.laser_ref.laser_state = laser_gun.laser_ref.laser.on
	pass


func _process(delta: float) -> void:
	if search_player.check_if_visible():
		canSeeTarget = true
		var dir = (search_player.target_current_position - global_transform.origin).normalized()
		var angle_y = atan2(dir.x, dir.z)
		rotation.y = lerpf(rotation.y, angle_y, delta * 2)
	else:
		canSeeTarget = false
	pass




var dying : bool = false
func dead():
	if dying == false:
		dying = true
		target_position = global_position
		#play dead animation / vfx
		audio.start_stream("Explode")
		explosion_fx.emitting = true
		#wait for end of it
		await get_tree().create_timer(0.5).timeout
		#queue free
		queue_free()


func get_hit():
	damage_fx._trigger()
	audio.start_stream("Get_Hit")
	health -= 5
	
	if health <= 0:
		dead()





#no knockback in this case
func knockback(direction : Vector3, force : float):
	pass
