extends CharacterBody3D
class_name top_down_player

var h_input 
var v_input

var speed : float = 15
var accel : float = 20
var air_accel : float = 5

var gravity : float = 0.5
var jump_power : float = 15

var vel : Vector3 = Vector3.ZERO
var vel_prev : Vector3 = Vector3.ZERO

var can_take_damage : bool = true
var can_move : bool = true

@onready var mesh_root: Node3D = $MeshRoot

@onready var squash_fx: squash_effect = $Effects/Squash
@onready var damage_fx: damage_flash = $Effects/Damage_Flash

@onready var jump_fx: jump_action = $Effects/JumpEffect
@onready var shoot: shoot_action = $Actions/Shoot
@onready var rotate_to_mouse_fx: rotate_to_mouse = $Effects/rotate_to_mouse
@onready var rotate_to_motion_fx: rotate_to_motion = $Effects/rotate_to_motion

@onready var dash_action: dash = $Actions/Dash

@onready var audio: audio_player = $audio_player

@onready var reload_particle: GPUParticles3D = $Particle_Emitters/Reload_Particle

@onready var animation_tree: AnimationTree = $AnimationTree



func _ready():
	rotate_to_mouse_fx.active = true
	rotate_to_motion_fx.active = false

func _physics_process(delta: float) -> void:
	
	if can_move == false:
		return
	
	#get player input
	h_input = Input.get_axis("left", "right")
	v_input = Input.get_axis("up", "down")
	

	if Input.is_action_just_pressed("dash"):
		if dash_action.can_dash:
			change_rotation_method(0.5)
			dash_action._trigger()
			animation_tree.set("parameters/OneShot/request", 1)
	
	
	#handle shoot
	if Input.is_action_pressed("attack"):
		if shoot.can_shoot and GameMaster.player_ammo > 0:
			GameMaster.update_player_ammo(-1)
			shoot._trigger()
			audio.start_stream("Shoot")
		elif shoot.can_shoot and GameMaster.player_ammo <= 0:
			GameMaster.update_player_ammo(GameMaster.player_ammo_max)
			shoot._reload()
			audio.start_stream("Reload")
			reload_particle.restart()
			reload_particle.emitting = true
			pass
	
	if Input.is_action_just_pressed("reload") and GameMaster.player_ammo < GameMaster.player_ammo_max and !shoot.reloading:
		GameMaster.update_player_ammo(GameMaster.player_ammo_max)
		shoot._reload()
		audio.start_stream("Reload")
		reload_particle.restart()
		reload_particle.emitting = true
		pass
	
	
	
	#handle landing detect and squash
	vel_prev = vel
	vel = velocity
	
	if abs(vel.y) < 0.3 and abs(vel_prev.y) > 0.3 and is_on_floor():
		jump_fx.trigger_landing_effect(vel_prev.y)
		squash_fx.start_squash()
	pass
	
	#handle_movement
	if is_on_floor():
		#velocity.x = lerp(velocity.x, h_input * speed, delta * accel)
		velocity = lerp(velocity, Vector3(h_input, velocity.y, v_input).normalized() * speed, delta * accel)
	else:
		velocity = lerp(velocity, Vector3(h_input, 0, v_input).normalized() * speed + Vector3(0,velocity.y,0), delta * accel)
		velocity.y -= gravity
	
	#for laser effect not hitting when dashing through
	if can_take_damage:
		collision_layer = 0b00000000_00000000_00000001_00000010
	else:
		collision_layer = 0b00000000_00000000_00000000_00000010
	
	move_and_slide()
	animate()


func jump():
	var angle_offest = -h_input
	
	velocity.y = jump_power
	jump_fx.trigger_jump_effect(angle_offest)
	squash_fx.start_stretch()
	pass

func land(impact_value : float):
	jump_fx.trigger_landing_effect(impact_value)




var hit_wait : bool = false

func get_hit():
	
	if hit_wait == true || !can_take_damage:
		return
	
	hit_wait = true
	damage_fx._trigger()
	audio.start_stream("Get_Hit")
	
	GameMaster.update_player_health(-3)
	squash_fx.start_stretch()
	damage_fx._trigger()
	
	await get_tree().create_timer(0.2).timeout
	hit_wait = false



func knockback(direction : Vector3, force : float):
	velocity += direction * force


func reset_can_hide():
	pass



func change_rotation_method(time : float):
	rotate_to_mouse_fx.active = false
	rotate_to_motion_fx.active = true
	await get_tree().create_timer(time).timeout
	rotate_to_mouse_fx.active = true
	rotate_to_motion_fx.active = false
	
	
	pass

func animate():
	
	var forward_vector : Vector3 = -mesh_root.global_transform.basis.z.normalized()
	var right_vector : Vector3 = mesh_root.global_transform.basis.x.normalized()
	
	var forward_speed: float = velocity.dot(forward_vector)/speed
	var side_speed : float = velocity.dot(right_vector)/speed

	animation_tree.set("parameters/BlendSpace2D/blend_position", Vector2(side_speed, forward_speed))
	pass

func pause_for_cutscene():
	if can_move == false:
		rotate_to_mouse_fx.active = true
		can_move = true
	elif can_move == true:
		rotate_to_mouse_fx.active = false
		can_move = false
