extends MeshInstance

# Can't see the shader params in instanced shader material, hence this script
var thickness setget set_face_z, get_face_z
var color setget set_color, get_color
var emit_color setget set_emit_color, get_emit_color
var tile_grid_size setget set_tile_grid_size, get_tile_grid_size
var texture_id setget set_face_texture, get_face_texture
export var part_type = ""

var _texture_id = 0

func get_face_z():
	return get_param("face_z") * 2.0

func get_color():
	return get_param("color")

func get_emit_color():
	return get_param("emit_color")

func get_tile_grid_size():
	return get_param("tile_grid_size")

func get_face_texture():
	return _texture_id

func set_face_texture(id):
	_texture_id = id
	set_param("use_texture", id > 0)
	if id > 0:
		set_param("face_texture", Parts.textures.values()[id])

func set_face_z(value):
	set_param("face_z", value / 2.0)

func set_color(col):
	set_param("color", col)

func set_emit_color(col):
	set_param("emit_color", col)

func set_tile_grid_size(v):
	set_param("tile_grid_size", v)

func set_param(pname, value):
	var sm = get_surface_material(0)
	sm.set_shader_param(pname, value)

func get_param(pname):
	return get_surface_material(0).get_shader_param(pname)
