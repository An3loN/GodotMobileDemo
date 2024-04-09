extends Panel
class_name AnimalPicker

@export var button_size: Vector2i
@export var animal_list: AnimalList

signal animal_drag_started(touch_position: Vector2, touch: int, animal_button: AnimalButton)
signal animal_dragged(touch_position: Vector2, touch: int, animal_button: AnimalButton)
signal animal_drag_ended(touch: int, animal_button: AnimalButton)
var active_button: AnimalButton
var active_touch := -1
var touch_position: Vector2

func on_animal_tapped(animal_button: AnimalButton):
	if active_button and active_button.animal_data == animal_button.animal_data:
		free_active_animal()
		return
	free_active_animal()
	active_button = animal_button
	animal_button.highlight()

func on_animal_drag_start(touch_position: Vector2, touch: int, animal_button: AnimalButton):
	if active_touch != -1 and touch != active_touch:
		return
	free_active_animal()
	active_button = animal_button
	self.touch_position = touch_position
	animal_drag_started.emit(touch_position, touch, animal_button)

func on_animal_dragged(touch_position: Vector2, touch: int, animal_button: AnimalButton):
	self.touch_position = touch_position
	animal_dragged.emit(touch_position, touch, animal_button)

func on_animal_drag_end(touch: int, animal_button: AnimalButton):
	animal_drag_ended.emit(touch, animal_button)
	free_active_animal()

func free_active_animal():
	active_touch = -1
	if active_button:
		active_button.lowlight()
	active_button = null

func lock_animal(animal_data: AnimalData):
	var button = animal_list.get_button_by_data(animal_data)
	if button:
		button.disable()

func unlock_animal(animal_data: AnimalData):
	var button = animal_list.get_button_by_data(animal_data)
	if button:
		button.enable()

func set_animals(animals_data: Array[AnimalData]):
	animal_list.create_buttons(animals_data, button_size,
	 on_animal_tapped, on_animal_drag_start, on_animal_dragged, on_animal_drag_end)
