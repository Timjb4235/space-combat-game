extends Node3D

@export var dust_count: int = 1000
@export var radius: float = 100.0
@export var particle_size: float = 0.06
@export var player_path: NodePath

var multimesh_instance: MultiMeshInstance3D
var multimesh: MultiMesh
var player: Node3D
var offsets := []

func _ready():
	player = get_node(player_path) as Node3D
	
	var mesh := SphereMesh.new()
	mesh.radius = particle_size
	mesh.height = particle_size * 2
	mesh.radial_segments = 4
	mesh.rings = 2
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.0, 0.0, 0.5)
	material.emission_enabled = true
	material.emission = Color(0.2, 0.4, 1.0)
	material.emission_energy = 0.6    
	mesh.material = material

	# Setup MultiMesh
	multimesh_instance = MultiMeshInstance3D.new()
	add_child(multimesh_instance)

	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = dust_count
	multimesh.mesh = mesh
	multimesh_instance.multimesh = multimesh

	for i in range(dust_count):
		var offset := Vector3(
			randf_range(-radius, radius),
			randf_range(-radius, radius),
			randf_range(-radius, radius)
		)
		offsets.append(offset)

func _process(delta: float) -> void:
	var player_pos = player.global_transform.origin

	for i in range(dust_count):
		var offset = offsets[i]
		var dust_pos = offset

		# Wrap dust around the player’s position
		for axis in ['x', 'y', 'z']:
			if player_pos[axis] - dust_pos[axis] > radius:
				dust_pos[axis] += 2 * radius
				offset[axis] += 2 * radius
			elif dust_pos[axis] - player_pos[axis] > radius:
				dust_pos[axis] -= 2 * radius
				offset[axis] -= 2 * radius

		offsets[i] = offset
		var xform = Transform3D(Basis(), offset)
		multimesh.set_instance_transform(i, xform)
