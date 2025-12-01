extends Node3D
class_name fog_of_war

@export var target_body : top_down_player
@export var target_camera : Camera3D


@onready var viewport_camera: Camera3D = $SubViewport/ViewportCamera
@onready var fog_mesh: Node3D = $FogMesh
@onready var vision_FOV: vision_calculator = $FogMesh/vision_fov
@onready var vision_center: vision_calculator = $FogMesh/vision_center
@onready var unit_detect: Area3D = $Area3D



@export var FOV : float
@export var FOV_Range : float
@export var Center_Range : float

var visible_candidates: Array = []

func _ready():
	vision_FOV.vision_fov = FOV
	vision_FOV.vision_radius = FOV_Range
	
	vision_center.vision_radius = Center_Range
	vision_center.vision_fov = 360
	


func _process(_delta: float) -> void:
	viewport_camera.global_position = target_camera.global_position
	viewport_camera.rotation = target_camera.global_rotation
	
	fog_mesh.global_position = target_body.global_position + Vector3(0,0,0)
	unit_detect.global_position = target_body.global_position + Vector3(0,0,0)
	_check_visible_units()




func _check_visible_units():
	var space_state = get_world_3d().direct_space_state
	
	for body in visible_candidates:

		var origin = target_body.global_position + Vector3(0,0.5,0)
		var target = body.global_position
		
		#check if in fov
		var to_target = (body.global_position - target_body.global_position).normalized()
		# FOV angle check
		var angle_deg = rad_to_deg(acos(-target_body.mesh_root.transform.basis.z.dot(to_target)))
		if (target - origin).length() > FOV_Range:
			body._toggle_visibility(false)
			continue
		if angle_deg > FOV * 0.5 and (target - origin).length() > Center_Range:
			body._toggle_visibility(false)
			continue
		
		
		var exclude_list = [self]
		for other in visible_candidates:
			if other != body and is_instance_valid(other):
				exclude_list.append(other)
		
		var query = PhysicsRayQueryParameters3D.create(origin, target, 0b00000000_00000000_00000010_00000001)
		query.collide_with_areas = false # skip other areas if desired
		query.exclude = exclude_list # avoid hitting yourself

		
		var result = space_state.intersect_ray(query)
		
		if result.is_empty():
			continue # no hit at all (probably fine)
		
		if result["collider"] == body:
			body._toggle_visibility(true)
		else:
			body._toggle_visibility(false)
	pass




func _unit_detect_area_entered(body: Node3D) -> void:
	visible_candidates.append(body)


func _unit_detect_area_exited(body: Node3D) -> void:
	visible_candidates.erase(body)
	body._toggle_visibility(false)
