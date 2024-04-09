extends Node3D
class_name AnimalModel

var top_marker
var default_material = null
@export var red_material = preload("res://art/materials/red.tres")
@export var white_material = preload("res://art/materials/white.tres")
@export var meshes: Array[MeshInstance3D]

func _ready():
	top_marker = $TopMarker

func set_material(material: Material):
	for mesh in meshes:
		mesh.material_override = material

func make_red():
	set_material(red_material)

func make_white():
	set_material(white_material)

func make_default():
	set_material(default_material)

func get_height() -> float:
	return top_marker.position.y
