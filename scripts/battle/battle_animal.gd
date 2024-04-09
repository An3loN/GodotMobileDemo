extends CharacterBody3D
class_name BattleAnimal

enum AnimalState {INACTIVE, ACTIVE}

signal died
signal attacked
signal got_hit
signal killed

@export var acceleration = 5.0
@export var attack_radius = 0.18

@onready var attack_timer := $AttackTimer as Timer
@onready var delay_timer := $AttackTimer/DelayTimer as Timer
@onready var damage_recieve_effect_timer := $DamageRecieveEffectTimer as Timer
@onready var hp_mesh := $HpMesh as MeshInstance3D

var _acceleration_vector: Vector3
var _target_velocity := Vector3.ZERO
var _target: BattleAnimal
var camera: Camera3D
var dead = false
var health: float
var base_stats: Dictionary
var effects: Array[Effect]
var stats: Dictionary
var is_enemy: bool
var model: AnimalModel
var state_machine := StateMachine.new()
var follow_target_state := StateMachine.State.new() as StateMachine.State
var attack_state := StateMachine.State.new() as StateMachine.State
var idle_state := StateMachine.State.new() as StateMachine.State

func _on_target_died():
	set_target(null)
	state_machine.perform('target_died')

func die():
	dead = true
	died.emit()
	queue_free()

func set_target(target: BattleAnimal) -> void:
	if(_target): 
		_target.died.disconnect(_on_target_died) 
	_target = target
	if(target):
		_target.died.connect(_on_target_died)

func _set_closest_targed() -> bool:
	var animals = get_tree().get_nodes_in_group('animals')
	var closest_animal
	var closest_sqr_distance
	for animal in animals:
		if(animal.is_enemy != is_enemy and not animal.dead):
			var sqr_distance = position.distance_squared_to(animal.position)
			if(not closest_animal or sqr_distance < closest_sqr_distance):
				closest_animal = animal
				closest_sqr_distance = sqr_distance
	set_target(closest_animal)
	return closest_animal != null

func _is_target_close() -> bool:
	return position.distance_to(_target.position) < attack_radius

func _follow_target() -> StateMachine.State:
	if(not _target): return follow_target_state
	if(_is_target_close()):
		return attack_state
	else:
		_target_velocity = position.direction_to(_target.position)
	return follow_target_state

func _do_damage(target: BattleAnimal):
	if(not target):
		return
	target.recieve_damage(stats["damage"].value)

func _on_attack_end():
	if(not _target):
		return
	if(_is_target_close()):
		_attack()
	else:
		state_machine.perform('target_escaped')

func _attack():
	attack_timer.start()
	delay_timer.start()
	await delay_timer.timeout
	_do_damage(_target)
	_on_attack_end()

func _on_state_changed(old_state: StateMachine.State, new_state: StateMachine.State):
	if(new_state == attack_state):
		_attack()
	if(old_state == attack_state):
		attack_timer.stop()
		delay_timer.stop()
	if(old_state == follow_target_state):
		_target_velocity = Vector3.ZERO

func _init():
	state_machine.add_state(follow_target_state)
	state_machine.add_state(attack_state)
	state_machine.add_state(idle_state)
	follow_target_state.on_action('physics_process', func (_args):
		return _follow_target()
	)
	follow_target_state.on_action('target_died', func(_args):
		var found = _set_closest_targed()
		if not found:
			return idle_state
		return follow_target_state
	)
	attack_state.on_action('target_died', func(_args):
		var found = _set_closest_targed()
		if not found:
			return idle_state
		return follow_target_state
	)
	attack_state.on_action('target_escaped', func(_args):
		return follow_target_state
	)
	state_machine.state_changed.connect(_on_state_changed)
	state_machine.state = follow_target_state

func _ready():
	attack_timer.timeout.connect(_attack)

func _process(_delta):
	hp_mesh.global_basis = camera.global_basis.inverse()

func _physics_process(delta):
	state_machine.perform('physics_process', delta)	
	var delta_acceleration = acceleration * delta
	velocity += (_target_velocity - velocity).clamp(
		Vector3(-delta_acceleration, 0.0, -delta_acceleration),
		Vector3(delta_acceleration, 0.0, delta_acceleration))
	look_at(velocity)
	move_and_slide()

func _set_attack_time(attack_time: float):
	attack_timer.wait_time = attack_time

func _set_attack_delay(attack_delay: float):
	delay_timer.wait_time = attack_delay

func _set_stats(new_stats: Dictionary):
	stats = new_stats
	stats["attack_time"].changed.connect(_set_attack_time)
	stats["attack_delay"].changed.connect(_set_attack_delay)
	_set_attack_time(stats["attack_time"].value)
	_set_attack_delay(stats["attack_delay"].value)
	health = stats["max_health"].value

#func _apply_all_effects():
	#if not effects:
		#return
	#for effect in effects:
		#for modifier in effect.modifiers:
			#stats[modifier.stat_name].add_modifier(modifier)

func apply_effect(effect: Effect):
	effects.append(effect)
	for modifier in effect.modifiers:
		stats[modifier.stat_name].add_modifier(modifier, effect)

func clear_effect(effect: Effect):
	effects.erase(effect)
	for modifier in effect.modifiers:
		stats[modifier.stat_name].remove_modifiers_by_effect(effect)

func initialize(animal_data: AnimalData, is_enemy: bool, camera: Camera3D) -> void:
	self.camera = camera
	_acceleration_vector = Vector3(acceleration, acceleration, acceleration)
	model = animal_data.scene.instantiate() as AnimalModel
	add_child(model)
	hp_mesh.position = Vector3(hp_mesh.position.x, model.get_height(), hp_mesh.position.z)
	self.is_enemy = is_enemy
	_set_stats(animal_data.base_stats.get_dict())
	#effects = animal_data.base_effects
	#_apply_all_effects()

func on_battle_start() -> void:
	if(is_enemy):
		model.make_red()
		model.default_material = model.red_material
	_set_closest_targed()

func recieve_damage(damage: float) -> void:
	health -= damage
	hp_mesh.set_instance_shader_parameter("hp_part", float(health) / float(stats["max_health"].value))
	if(health <= 0):
		die()
	model.make_white()
	damage_recieve_effect_timer.start()
	await damage_recieve_effect_timer.timeout
	model.make_default()

func _exit_tree():
	state_machine.free()
