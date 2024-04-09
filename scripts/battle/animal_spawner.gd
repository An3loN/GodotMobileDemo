extends Node3D
class_name AnimalSpawner

signal animal_spawned(animal: BattleAnimal, is_enemy: bool)

var camera: Camera3D
@export var animal_scene: PackedScene
@export var animals_parent_node: Node3D

func initialize(camera: Camera3D):
	self.camera = camera

func spawn(animal_data: AnimalData, is_enemy:bool, spawn_position: Vector3, spawn_basis: Basis):
	var animal = animal_scene.instantiate() as BattleAnimal
	animals_parent_node.add_child(animal)
	animal.position = spawn_position
	animal.basis = spawn_basis
	animal.initialize(animal_data, is_enemy, camera)
	animal.add_to_group('enemies' if is_enemy else 'allies')
	animal.add_to_group('animals')
	animal_spawned.emit(animal, is_enemy)
