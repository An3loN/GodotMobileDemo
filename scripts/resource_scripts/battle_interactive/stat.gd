extends RefCounted
class_name Stat

signal changed(new_value: float)

var base_value: float
var modifiers: Array[Modifier]
var _modified_value: float
var value: float:
	get:
		return _modified_value

func _init(base_value):
	self.base_value = base_value
	_modified_value = base_value
	modifiers = []

func update_modified_value():
	_modified_value = base_value
	var mult_coef = 1.0
	var add_coef = 0
	for modifier in modifiers:
		if modifier.type == Modifier.ModifierType.ADDITIVE:
			add_coef += modifier.value
		elif modifier.type == Modifier.ModifierType.MULTIPLICATIVE:
			mult_coef *= modifier.value
	_modified_value = _modified_value * mult_coef + add_coef
	changed.emit(_modified_value)

func add_modifier(modifier: Modifier, source):
	modifier.source = source
	modifiers.append(modifier)
	update_modified_value()

func add_modifiers(new_modifiers: Array[Modifier], source):
	for mod in new_modifiers:
		mod.source = source
	modifiers.append_array(new_modifiers)
	update_modified_value()

func remove_modifiers_by_effect(effect: Effect):
	modifiers.filter(func(mod): mod.source == effect)
