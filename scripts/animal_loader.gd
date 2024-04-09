extends Node
class_name AnimalLoader
signal animals_loaded(animals_data)

var animals_data: Array[AnimalData]

func get_animals_data():
	if not animals_data:
		animals_data = load('res://data/animals.tres').animals_data
	return animals_data 

func get_owned_animals_data() -> Array[AnimalData]:
	get_animals_data()
	var owned_animals_data: Array[AnimalData]
	owned_animals_data = []
	for animal_data in animals_data:
		if animal_data.owned:
			owned_animals_data.append(animal_data)
	return owned_animals_data
