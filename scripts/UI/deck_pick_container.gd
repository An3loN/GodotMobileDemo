extends GridContainer
class_name DeckPickContainer

@export var chosen_animal_button_scene: PackedScene
var chosen_animal_buttons: Array[AnimalButton]
var animal_picker: AnimalPicker

func on_deck_button_tapped(button: AnimalButton):
	if animal_picker.active_button:
		if button.animal_data:
			animal_picker.unlock_animal(button.animal_data)
		button.set_animal_data(animal_picker.active_button.animal_data)
		animal_picker.lock_animal(animal_picker.active_button.animal_data)
		animal_picker.free_active_animal()
	else:
		if button.animal_data:
			animal_picker.unlock_animal(button.animal_data)
			button.clear_animal_data()

func initialize(animal_picker: AnimalPicker):
	self.animal_picker = animal_picker
	chosen_animal_buttons = []
	for i in range(GlobalConstants.DECK_SIZE):
		var button = chosen_animal_button_scene.instantiate() as AnimalButton
		button.initialize()
		button.custom_minimum_size = Vector2i(80, 80)
		add_child(button)
		chosen_animal_buttons.append(button)
		button.tapped.connect(on_deck_button_tapped)

func get_chosen_animals_data() -> Array[AnimalData]:
	var picked_animals_data: Array[AnimalData]
	picked_animals_data = []
	for animal_button in chosen_animal_buttons:
		if animal_button.animal_data:
			picked_animals_data.append(animal_button.animal_data)
	return picked_animals_data
