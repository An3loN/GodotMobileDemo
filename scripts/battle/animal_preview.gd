extends Node3D

@export var override_material: Material
var ground_target_position = null
var ground_raycast
var model

func initialize(animal_data: AnimalData):
	model = animal_data.scene.instantiate()
	add_child(model)
	on_drag()
	ground_raycast = $GroundRayCast

func on_drag():
	override_children_mesh_material(model, override_material)

func override_children_mesh_material(node: Node3D, material):
	for child in node.get_children():
		if(child is MeshInstance3D):
			child.material_override = material
		override_children_mesh_material(child, material)

func _process(_delta):
	if(ground_raycast.is_colliding()):
		ground_target_position = ground_raycast.get_collision_point()
	else:
		ground_target_position = null

func set_exposed():
	override_children_mesh_material(model, null)
	global_position = model.root_marker.global_position

func set_global_pos(pos: Vector3):
	global_position = pos
	ground_raycast.force_raycast_update()
	if(ground_raycast.is_colliding()):
		ground_target_position = ground_raycast.get_collision_point()
	else:
		ground_target_position = null
