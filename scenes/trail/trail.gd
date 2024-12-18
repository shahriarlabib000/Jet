extends MeshInstance3D

@export var target:Node3D
@export var max_count := 100
var points :Array[Vector3] = []

func _ready() -> void:
	mesh = ImmediateMesh.new()

func _physics_process(_delta: float) -> void:
	if is_instance_valid(target):
		if points.size() < max_count:
			points.push_back(target.global_position)
		else:
			points.pop_front()
		
		mesh.clear_surfaces()
		mesh.surface_begin(mesh.PRIMITIVE_LINE_STRIP)
		for point:Vector3 in points:
			mesh.surface_add_vertex(point)
		mesh.surface_end()
