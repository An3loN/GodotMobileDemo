extends GridContainer
class_name AnimalList

@export var animal_button_scene: PackedScene

var button_size: Vector2i
var buttons: Array[AnimalButton]

func create_buttons(animals_data: Array[AnimalData], button_size: Vector2i, on_tap: Callable, on_drag_start: Callable, on_drag: Callable, on_drag_end: Callable):
	if len(buttons) != 0:
		for button in buttons:
			button.free()
	buttons = []
	self.button_size = button_size
	for animal_data in animals_data:
		var button = animal_button_scene.instantiate() as AnimalButton
		button.initialize()
		button.custom_minimum_size = button_size
		button.set_animal_data(animal_data)
		add_child(button)
		buttons.append(button)
		if(on_tap):
			button.tapped.connect(on_tap)
		if(on_drag_start):
			button.drag_started.connect(on_drag_start)
		if(on_drag):
			button.dragged.connect(on_drag)
		if(on_drag_end):
			button.drag_ended.connect(on_drag_end)

func get_button_by_data(animal_data: AnimalData):
	for i in range(len(buttons)):
		if buttons[i].animal_data == animal_data:
			return buttons[i]
	return null

func _draw():
	if not button_size:
		return
	columns = int(size.x / button_size.x)
