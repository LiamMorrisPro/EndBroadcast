extends CharacterBody3D

signal got_hit
signal die
signal summon

@onready var audio: audio_player = $audio_player
@onready var damage_fx: damage_flash = $Damage_Flash
@onready var shoot: shoot_boss = $ShootBoss

@export var player : top_down_player
var health : float = 100

enum ptrns{idle, phase1, phase2}
var state : ptrns = ptrns.idle

@onready var laser_gun: Node3D = $Mesh_Root/LaserGun

func _ready():
	laser_gun.laser_ref.laser_state = laser_gun.laser_ref.laser.off
	laser_gun.active = false
	pass

func _process(delta : float) -> void:
	match state:
		ptrns.idle:
			pass
		ptrns.phase1:
			shoot._trigger()
		ptrns.phase2:
			shoot._trigger_2()
	
	var dir = (player.position - global_transform.origin).normalized()
	var angle_y = atan2(dir.x, dir.z)
	rotation.y = lerpf(rotation.y, angle_y, delta * 2)



func _start():
	state = ptrns.phase1











func dead():
	die.emit()
	pass

func get_hit():
	got_hit.emit()
	damage_fx._trigger()
	audio.start_stream("Get_Hit")
	health -= 5
	
	
	if health <= 50 and state == ptrns.phase1:
		state = ptrns.phase2
		laser_gun.visible = true
		laser_gun.active = true
		laser_gun.laser_ref.laser_state == laser_gun.laser_ref.laser.on
		summon.emit()
	
	if health <= 0:
		dead()




#no knockback in this case
func knockback(direction : Vector3, force : float):
	pass
