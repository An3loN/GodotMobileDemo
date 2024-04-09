extends Node3D

func spawn(enemy_scene: PackedScene, parent_node: Node3D) -> Node3D:
	var enemy = enemy_scene.instantiate()
	parent_node.add_child(enemy)
	enemy.global_position = Vector3(global_position.x, enemy.global_position.y, global_position.z)
	enemy.basis = basis
	return enemy
