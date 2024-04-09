extends BattleInteractive
class_name Effect

@export var modifiers: Array[Modifier]
var target: BattleAnimal

func apply(target: BattleAnimal):
	target.apply_effect(self)

func clear():
	target.clear_effect(self)
