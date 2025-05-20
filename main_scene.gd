extends Node3D


func _ready() -> void:
	_create_boundary(1000)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _create_boundary(size: float, thickness: float = 1.0):
	var sides := [
		{ "normal": Vector3.LEFT },
		{ "normal": Vector3.RIGHT },
		{ "normal": Vector3.UP },
		{ "normal": Vector3.DOWN },
		{ "normal": Vector3.FORWARD },
		{ "normal": Vector3.BACK }
	]

	for side in sides:
		var normal: Vector3 = side.normal
		var static_body := StaticBody3D.new()
		
		var collision_shape = CollisionShape3D.new()
		var box_shape = BoxShape3D.new()
		
		if normal == Vector3.LEFT or normal == Vector3.RIGHT:
			box_shape.size = Vector3(thickness, size * 2, size * 2)
		elif normal == Vector3.UP or normal == Vector3.DOWN:
			box_shape.size = Vector3(size * 2, thickness, size * 2)
		else:
			box_shape.size = Vector3(size * 2, size * 2, thickness)

		collision_shape.shape = box_shape
		static_body.add_child(collision_shape)

		var mesh_instance := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = box_shape.size
		mesh_instance.mesh = mesh

		# Create transparent material
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.2, 0.8, 1.0, 0.2)  # light blue, mostly transparent
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.flags_transparent = true
		mesh.material = mat

		static_body.add_child(mesh_instance)

		# Position the wall
		static_body.transform.origin = normal * size
		add_child(static_body)
