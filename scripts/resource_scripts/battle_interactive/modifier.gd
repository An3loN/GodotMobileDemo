extends Resource
class_name Modifier

enum ModifierType {
	ADDITIVE = 0,
	MULTIPLICATIVE,
}
enum ModifierStackType {
	LINEAR = 0,
	EXPONENTIAL,
}

@export var stat_name: String 
@export var value: float
@export var type: ModifierType
@export var stack_type: ModifierStackType
var source
