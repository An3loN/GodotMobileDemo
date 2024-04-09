extends TextureButton
class_name DragButton

@export var touch_shift_treshold = 10.0

signal tapped(button: DragButton)
signal drag_started(position: Vector2, touch_id: int, button: DragButton)
signal dragged(position: Vector2, touch_id: int, button: DragButton)
signal drag_ended(touch_id: int, button: DragButton)

var _started_touch := false
var _active_finger
var _drag_started := false
var touch_start_pos: Vector2i

func _gui_input(event):
	if disabled:
		return
	if not event is InputEventScreenTouch and not event is InputEventScreenDrag:
		return
	if _active_finger and _active_finger != event.index:
		return
	if _started_touch and event is InputEventScreenDrag:
		if not _drag_started:
			if Vector2(event.position).distance_squared_to(Vector2(touch_start_pos)) < touch_shift_treshold:
				return
			_drag_started = true
			drag_started.emit(event.position + global_position, event.index, self)
			return
		dragged.emit(event.position + global_position, event.index, self)
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
				tapped.emit(self)

func disable():
	disabled = true

func enable():
	disabled = false
