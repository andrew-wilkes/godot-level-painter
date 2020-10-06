extends Spatial

"""
This script scans for textures and part scenes
This script is an autoload.
"""

const TEXTURE_FILES_PATH = "res://assets/textures/"
const PARTS_FILES_PATH = "res://parts/"

var textures = {}
var parts = {}

func _ready():
	scan_files(TEXTURE_FILES_PATH, textures, ["png", "jpg"])
	scan_files(PARTS_FILES_PATH, parts, ["tscn"])

func scan_files(path, dict, extensions):
	var files = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if !dir.current_is_dir():
				if file_name.get_extension() in extensions:
					print("Found file: " + file_name)
					files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the " + path + " path.")
	files.sort()
	for fn in files:
		dict[fn.split(".")[0]] = load(path + fn)

func get_part(id: int):
	var key = parts.keys()[id]
	var part = parts[key].instance()
	#part.set_surface_material(0, part.get_surface_material(0).duplicate())
	return part
