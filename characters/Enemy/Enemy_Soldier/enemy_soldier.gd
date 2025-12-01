extends CharacterBody3D
class_name enemy_soldier


@onready var search_player: search_target = $Components/SearchPlayer
@onready var pathfinder: Pathfinder = $Components/Pathfinder
@onready var shoot: shoot_action = $Components/Shoot

@onready var exclamation_fx: GPUParticles3D = $FX/Exclamation
@onready var call_fx: GPUParticles3D = $FX/Call
@onready var damage_fx: damage_flash = $Components/Damage_Flash
@onready var explosion_fx: GPUParticles3D = $Particles/Explosion

@onready var audio: audio_player = $Audio



enum st {idle, waking, calling, chasing, dead}
var soldier_state : st = st.idle

var bot_net : Bot_Net

var initial_position : Vector3 = Vector3.ZERO
var roaming_distance : float = 10.0


var target_position : Vector3 = Vector3.ZERO
var attack_distance : float = 20.0
var stop_distance : float = 10.0
var canSeeTarget : bool = false

var health : float = 15
var floor_friction : float = 10.0

var got_hit : bool = false


func _ready():
	if get_parent().is_in_group("BotNet"):
		bot_net = get_parent()
		bot_net.call_help.connect(waking)
	
	initial_position = global_position
	target_position = global_position

func _process(_delta: float) -> void:

	match soldier_state:
		st.idle: idle()
		st.waking: waking()
		st.calling: calling()
		st.chasing: chasing()
		st.dead: pass
	
	
	
	handle_looking()
	pass

func _physics_process(delta: float) -> void:
	
	#apply drag
	if is_on_floor():
		velocity = lerp(velocity, Vector3.ZERO, delta * floor_friction)
	else:
		velocity.y = -10
	move_and_slide()
	pass


func idle():
	#check if player is visible
	if search_player.check_if_visible():
		target_position = search_player.target_current_position
		canSeeTarget = true
	else:
		canSeeTarget = false


	if got_hit == true:
		target_position = get_tree().get_first_node_in_group("Player").global_position
		got_hit = false
		#call help
		if !bot_net.player_position_known:
			bot_net.current_target_position = target_position
			soldier_state = st.calling
		#wake up
		else:
			target_position = bot_net.current_target_position
			soldier_state = st.waking
	

	if canSeeTarget and bot_net != null:
		#call help
		if !bot_net.player_position_known:
			soldier_state = st.calling
		#wake up
		else:
			target_position = bot_net.current_target_position
			soldier_state = st.waking


func calling():
	#emit exclamation
	exclamation_fx.emitting = true
	await get_tree().create_timer(0.2).timeout
	#call help
	call_fx.emitting = true
	await get_tree().create_timer(0.2).timeout
	bot_net._call_help()
	#start chasing
	soldier_state = st.chasing


func waking():
	#emit exclamation effect
	exclamation_fx.emitting = true
	#wait before witching to chasing
	await get_tree().create_timer(0.2).timeout
	soldier_state = st.chasing


func chasing():
	if search_player.check_if_visible():
		target_position = search_player.target_current_position
		canSeeTarget = true
	else:
		canSeeTarget = false
	
	if bot_net.player_position_known and !canSeeTarget:
		target_position = bot_net.current_target_position
	
	
	if (target_position - global_position).length() <= attack_distance and canSeeTarget:
		if shoot.can_shoot:
			shoot._trigger()
			audio.start_stream("Shoot")
			
	
	

var dying : bool = false
func dead():
	if dying == false:
		dying = true
		soldier_state = st.dead
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
	
	got_hit = true
	await get_tree().create_timer(0.1).timeout
	got_hit = false

func knockback(direction : Vector3, force : float):
	velocity += direction * force

func handle_looking():
	if canSeeTarget:
		look_at(Vector3(target_position.x, position.y, target_position.z), Vector3.UP)
	else:
		if velocity.length() >= 0.1:
			var normal_vec = velocity.normalized()
			look_at(Vector3(global_position.x + normal_vec.x, position.y, global_position.z + normal_vec.z), Vector3.UP)
		pass
	pass


func _toggle_visibility(toggle : bool):
	
	pass
