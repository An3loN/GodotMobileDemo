extends Node3D
@export_category("Controls")
@export var main_menu_control: Control
@export var battle_control: Control

@export_category("Main menu")
@export var animal_picker: AnimalPicker
@export var deck_pick_container: DeckPickContainer
@export var animal_loader: AnimalLoader

@export_category("Battle")
@export var animal_hand_picker: AnimalPicker
@export var battle_scene: PackedScene
@export var battle_holder: Node3D
@export var camera: Camera3D

var battle: Battle

func _ready():
	deck_pick_container.initialize(animal_picker)
	animal_picker.set_animals(animal_loader.get_owned_animals_data())
	set_main_menu_control_layout()

func set_main_menu_control_layout():
	main_menu_control.visible = true
	battle_control.visible = false

func set_battle_control_layout():
	main_menu_control.visible = false
	battle_control.visible = true

func start_battle():
	var picked_animals = deck_pick_container.get_chosen_animals_data()
	set_battle_control_layout()
	animal_hand_picker.set_animals(picked_animals)
	battle = battle_scene.instantiate() as Battle
	battle_holder.add_child(battle)
	battle.initialize(animal_hand_picker, camera)
	battle.animal_preview_camera_depth = camera.position.distance_to(battle_holder.position)

func start_fight():
	battle.start_fight()

func _on_start_button_pressed():
	start_battle()

func _on_start_fight_button_pressed():
	start_fight()
