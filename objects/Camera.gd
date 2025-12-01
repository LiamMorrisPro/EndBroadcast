extends Camera3D

@export var randomStrength : float = 1.0
@export var shakeFade : float = 10.0

var rng = RandomNumberGenerator.new()

var shake_strength : float = 0.0

func _ready() -> void:
	GameMaster.player_got_hit.connect(apply_shake)
	pass


func apply_shake():
	shake_strength = randomStrength
	pass

func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _process(delta : float):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		
		position.x = random_offset().x
		position.y = random_offset().y
	pass
