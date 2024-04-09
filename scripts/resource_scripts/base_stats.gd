extends Resource
class_name BaseStats

@export var max_health = 100
@export var damage = 1
@export var attack_time = 0.5
@export var attack_delay = 0.15

func get_dict() -> Dictionary:
	var stats = {}
	stats["max_health"] = Stat.new(max_health)
	stats["damage"] = Stat.new(damage)
	stats["attack_time"] =  Stat.new(attack_time)
	stats["attack_delay"] =  Stat.new(attack_delay)
	return stats
