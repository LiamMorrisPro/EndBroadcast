extends Node3D


@export var speed : float = 100.0
var is_friendly : bool = true


@onready var lifetime: Timer = $Lifetime
@onready var damage_zone: damage_area = $DamageArea





func _ready():
	lifetime.start()
	damage_zone.on_hit.connect(hit)
	damage_zone.activate(10)
	pass

func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0,0,-speed) * delta



func hit(body : Node3D):
	if is_friendly and body.is_in_group("Enemy"):
		body.get_hit()
		body.knockback(-global_transform.basis.z, 10.0)
		_destroy_self()
		
	elif !is_friendly and body.is_in_group("Player"):
		body.get_hit()
		body.knockback(-global_transform.basis.z, 30.0)
		_destroy_self()
		
	elif !is_friendly and body.is_in_group("Enemy"):
		pass
	else:
		_destroy_self()


func _on_lifetime_timeout() -> void:
	_destroy_self()

func _destroy_self():
	queue_free()
