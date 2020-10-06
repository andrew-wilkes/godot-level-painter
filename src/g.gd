extends Node

# Globals

enum FACES { BACK, LEFT, FLOOR, RIGHT, FRONT, CEILING }

var cell_idx: int = -1
var cells = []

func get_resized_texture(t: Texture, width: int = 0, height: int = 0):
	var image = t.get_data()
	if width > 0 && height > 0:
		image.resize(width, height)
		if image.get_size().x != width:
			print("Unable to resize image!")
	var itex = ImageTexture.new()
	
	itex.create_from_image(image)
	return itex

func get_texture(ix: float, iy: float, id: int, t: Texture = null):
	if t == null:
		t = Parts.textures.values()[id]
	return g.get_resized_texture(t, ix, iy)
