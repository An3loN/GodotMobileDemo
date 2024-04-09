extends Node3D
class_name Battle

signal state_changed(new_state: BattleState)
enum BattleState {PREPARING, FIGHTING}
@export var animal_preview_camera_depth = 5.0
@export var preview_holder: Node3D
@onready var grid := $Grid as Grid
@onready var enemy_generator := $EnemyGenerator as EnemyGenerator
@onready var animal_spawner := $AnimalSpawner as AnimalSpawner
var preview
var camera: Camera3D
var battleState = BattleState.PREPARING
var animal_picker: AnimalPicker

func on_animal_drag_start(touch_position: Vector2, _touch: int, animal_button: AnimalButton):
	var preview_scene = load("res://scenes/animal_preview.tscn") # active_animal_data.name)
	preview = preview_scene.instantiate()
	preview.initialize(animal_button.animal_data)
	preview_holder.add_child(preview)
	preview.position = camera.project_position(touch_position, animal_preview_camera_depth)

func on_animal_dragged(touch_position: Vector2, _touch: int, _animal_button: AnimalButton):
	preview.set_global_pos(camera.project_position(touch_position, animal_preview_camera_depth))
	if(preview.ground_target_position):
		preview.set_global_pos(preview.ground_target_position)

func on_animal_drag_end(_touch: int, animal_button: AnimalButton):
	if(preview.ground_target_position):
		place_animal(animal_button.animal_data, preview.ground_target_position)
		animal_picker.lock_animal(animal_button.animal_data)
	preview.queue_free()

func initialize(animal_picker: AnimalPicker, camera: Camera3D):
	BattleInteractive.battle = self
	self.camera = camera
	self.animal_picker = animal_picker
	animal_picker.animal_drag_started.connect(on_animal_drag_start)
	animal_picker.animal_dragged.connect(on_animal_dragged)
	animal_picker.animal_drag_ended.connect(on_animal_drag_end)
	grid.initialize()
	animal_spawner.initialize(camera)
	enemy_generator.initialize(grid)
	generate_enemies()

func generate_enemies():
	enemy_generator.generate()
	enemy_generator.draw_enemy_warners()

func spawn_enemies():
	enemy_generator.spawn(animal_spawner)

func place_animal(animal_data, pos):
	animal_spawner.spawn(animal_data, false, pos, Basis())

func start_fight():
	assert(battleState == BattleState.PREPARING, "Battle has already started!!!!!")
	enemy_generator.clear_enemy_warners()
	spawn_enemies()
	get_tree().call_group("animals", "on_battle_start")
	set_state(BattleState.FIGHTING)

func set_state(state: BattleState):
	if(state == battleState): return
	battleState = state
	state_changed.emit(state)
