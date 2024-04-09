extends DragButton
class_name AnimalButton

var animal_data: AnimalData
var border_rect: TextureRect
var image_rect: TextureRect

func initialize():
	border_rect = $BorderRect
	image_rect = $TextureRect
	lowlight()

func set_animal_data(animal_data: AnimalData):
	self.animal_data = animal_data
	$TextureRect.texture = animal_data.icon
	$NameLabel.text = animal_data.name

func clear_animal_data():
	self.animal_data = null
	$TextureRect.texture = null
	$NameLabel.text = ""

func highlight():
	border_rect.visible = true

func lowlight():
	border_rect.visible = false

func set_image(image_texture: Texture):
	image_rect.texture = image_texture
