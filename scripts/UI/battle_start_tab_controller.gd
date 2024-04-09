extends Node

@export var tab_index: int
@export var animal_preview_size: Vector2i
@export var animal_preview_list: AnimalList
@export var animal_deck: DeckPickContainer

func _on_tab_container_tab_changed(tab):
	if tab == tab_index:
		var picked_animals_data = animal_deck.get_chosen_animals_data()
		if len(picked_animals_data) == 0:
			return
		animal_preview_list.create_buttons(picked_animals_data, animal_preview_size, Callable(), Callable(), Callable(), Callable())
