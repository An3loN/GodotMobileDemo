extends TextureButton
class_name ChosenAnimalButton

@export var touch_shift_treshold = 10.0

signal tapped(animal_data: AnimalData, animal_button: AnimalButton)
signal drag_started(animal_data: AnimalData, position: Vector2, touch_id: int, animal_button: AnimalButton)
signal dragged(animal_data: AnimalData, position: Vector2, touch_id: int, animal_button: AnimalButton)
signal drag_ended(touch_id: int, animal_button: AnimalButton)

var animal_data: AnimalData
var _started_touch := false
var _active_finger
var _drag_started := false
var border_rect: TextureRect
var touch_start_pos: Vector2i

func _ready():
	border_rect = $BorderRect
	lowlight()

func set_animal_data(animal_data: AnimalData):
	self.animal_data = animal_data
	$TextureRect.texture = animal_data.icon
	$NameLabel.text = animal_data.name

func _gui_input(event):
	if disabled:
		return
	if not event is InputEventScreenTouch and not event is InputEventScreenDrag:
		return
	if _active_finger and _active_finger != event.index:
		return
	if _started_touch and event is InputEventScreenDrag:
		if(not _drag_started):
			_drag_started = true
			drag_started.emit(animal_data, event.position + global_position, event.index, self)
			return
		dragged.emit(animal_data, event.position + global_position, event.index, self)
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			_started_touch = true
			_active_finger = event.index
			touch_start_pos = event.position
		else:
			_started_touch = false
			if _drag_started:
				_drag_started = false
				drag_ended.emit(event.index, self)
			else:
				tapped.emit(animal_data, self)
			#highlight self

func highlight():
	border_rect.visible = true

func lowlight():
	border_rect.visible = false

func disable():
	disabled = true

func enable():
	disabled = false
