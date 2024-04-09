extends Node3D
class_name EnemyGenerator

@export var enemy_animal: AnimalData
@export var animal_scene: PackedScene
@export var enemy_warner_scene: PackedScene
@export var generation_noise: FastNoiseLite
var grid

var enemies_data = []
var _enemies_basises = []
var _enemies_positions = []
var _enemy_warners = []

func initialize(grid):
	self.grid = grid

func _get_boundary_position(index):
	var boundary_length = grid.boundary_length
	if(index < boundary_length / 4):
		return Vector2i(0, index)
	elif(index <  boundary_length / 2):
		return Vector2i(index - grid.cell_count.y + 1, grid.cell_count.y - 1)
	elif(index < 3 * boundary_length / 4):
		return Vector2i(grid.cell_count.x - 1, 2 * grid.cell_count.y - 3 - index + grid.cell_count.x)
	else:
		return Vector2i(2*grid.cell_count.y + 2*grid.cell_count.x - 4 - index , 0)

func _get_boundary_basis(index):
	var boundary_length = grid.boundary_length
	if(index < boundary_length / 4):
		return Basis(Vector3.FORWARD, Vector3.UP, Vector3.RIGHT)
	elif(index <  boundary_length / 2):
		return Basis(Vector3.LEFT, Vector3.UP, Vector3.FORWARD)
	elif(index < 3 * boundary_length / 4):
		return Basis(Vector3.BACK, Vector3.UP, Vector3.LEFT)
	else:
		return Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK)

func generate():
	var noise = generation_noise
	for i in range(grid.boundary_length):
		var noise_value = noise.get_noise_1d(float(i))
		if noise_value > 0.2:
			var generated_enemy_data = enemy_animal
			var enemy_position = grid.grid_to_world_position(_get_boundary_position(i))
			var enemy_basis = _get_boundary_basis(i)
			enemies_data.append(generated_enemy_data)
			_enemies_basises.append(enemy_basis)
			_enemies_positions.append(enemy_position)

func draw_enemy_warners():
	for i in range(len(_enemies_positions)):
		var warner_position = _enemies_positions[i]
		var warner_basis = _enemies_basises[i]
		var warner = enemy_warner_scene.instantiate() as Node3D
		warner.position = warner_position
		warner.basis = warner_basis
		add_child(warner)
		_enemy_warners.append(warner)

func clear_enemy_warners():
	for warner in _enemy_warners:
		warner.queue_free()

func spawn(spawner: AnimalSpawner):
	for i in range(len(enemies_data)):
		spawner.spawn(enemies_data[i], true, _enemies_positions[i], _enemies_basises[i])
