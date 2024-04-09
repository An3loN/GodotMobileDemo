@tool
extends EditorScenePostImport

const data_folder_path = "res://data/animals/"

func _post_import(scene):
	iterate(scene)
	return scene

func iterate(node):
	if node != null:
		if node is MeshInstance3D:
			print("Node %s is mesh" % node.name)
			var animal_data_file_name = get_source_file().get_basename().get_file() + ".tres"
			var animal_data_file_path = data_folder_path + animal_data_file_name
			var animal_data = ResourceLoader.load(animal_data_file_path, "AnimalData")
			animal_data.mesh = node.mesh
			print(ResourceSaver.save(animal_data, animal_data_file_path, 0))
		elif node is Skeleton3D:
			print("Node %s is skeleton" % node.name)
			var animal_data_file_name = get_source_file().get_basename().get_file() + ".tres"
			var animal_data_file_path = data_folder_path + animal_data_file_name
			var animal_data = ResourceLoader.load(animal_data_file_path, "AnimalData")
			animal_data.skeleton = node
			print(ResourceSaver.save(animal_data, animal_data_file_path, 0))
		for child in node.get_children():
			iterate(child)
