extends MeshInstance3D
class_name vision_calculator

@onready var fog_of_war_obj: fog_of_war = $"../.."

@export var vision_radius : float = 10.0
@export var vision_fov : int = 90
@export var number_of_rays : int = 180

@export var vertical_offset := 0.1  # Just above ground to prevent Z-fighting
@export var look_direction := 0.0



func _process(_delta: float) -> void:
	look_direction = fog_of_war_obj.target_body.mesh_root.rotation.y
	create_vision_mesh()

func create_vision_mesh():
	mesh = null
	var space_rid = get_world_3d().direct_space_state
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var vertex_array : Array[Vector3] = []
	var origin = global_position
	
	vertex_array.append(Vector3(0, 0, 0))
	
	for i in range(number_of_rays):
		var step = i / float(number_of_rays - 1)
		var angle = -look_direction - deg_to_rad(vision_fov/2.0) + step * deg_to_rad(vision_fov) - PI/2.0
		var direction = Vector3(cos(angle), 0, sin(angle)).normalized()
		
		var ray_origin = origin
		var ray_target = ray_origin + direction * vision_radius
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target, 1)
		var result = space_rid.intersect_ray(query)
		
		var hit_pos : Vector3
		if result:
			hit_pos = result.position
		else:
			hit_pos = ray_target
		vertex_array.append(Vector3(hit_pos.x, origin.y, hit_pos.z) - origin)
	
	st.add_triangle_fan(vertex_array)
	var vis_mesh = st.commit()
	mesh = vis_mesh
