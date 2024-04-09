extends Node3D
class_name Grid

@export var grid_size: Vector2
@export var cell_count: Vector2i
var objects: Array[Array]
var center_pos: Vector3
var cell_size: Vector2
var size: Vector2i
var boundary_length: int:
	get:
		return (cell_count.x + cell_count.y)*2-4

func initialize():
	center_pos = position - Vector3(grid_size.x, 0.0, grid_size.y)/2
	cell_size = grid_size/Vector2(cell_count)
	objects = []
	for i in range(cell_count.y):
		objects.append([])
		for j in range(cell_count.x):
			objects[i].append(null)

func set_object(pos:Vector2i, obj: Object):
	objects[pos.x][pos.y] = obj

func get_object(pos: Vector2i):
	return objects[pos.y][pos.x]

func instantiate_object(pos: Vector2i, obj: Object):
	var instance = obj.instantiate()
	add_child(instance)
	objects[pos.y][pos.x] = instance
	instance.position = grid_to_world_position(pos)
	return instance

func world_to_grid_position(world_pos: Vector3)->Vector2i:
	var pos3 = world_pos - center_pos
	return Vector2i(Vector2(pos3.x, pos3.z)/cell_size)

func grid_to_world_position(grid_pos: Vector2i)->Vector3:
	var pos2 = Vector2(grid_pos)*cell_size + cell_size/2
	return Vector3(pos2.x, 0, pos2.y) + center_pos
