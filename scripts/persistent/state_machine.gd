extends Object
class_name StateMachine

signal state_changed(old_state:State, new_state:State)

var states: Array[State]
var state: State
var any_state_actions = {}

func perform(action_name: String, args = {}):
	var new_state = state.perform(action_name, args)
	set_state(new_state)

func add_state(state: State) -> void:
	state.state_machine = self
	states.append(state)

func set_state(new_state: State):
	if(new_state != state):
		state_changed.emit(state, new_state)
	state = new_state

func on_any_state(action_name: String, action: Callable):
	any_state_actions[action_name] = action

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		for state in states:
			state.free()

class State extends Object:
	var actions = {}
	var state_machine: StateMachine

	func on_action(action_name: String, action: Callable):
		self.actions[action_name] = action
		
	func perform(action_name, args = {}) -> State:
		if not self.actions.has(action_name): 
			if self.state_machine.any_state_actions.has(action_name):
				self.state_machine.any_state_actions[action_name].call(args)
			return self
		var next_state = self.actions[action_name].call(args)
		return next_state if next_state else self
