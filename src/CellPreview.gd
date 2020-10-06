extends Spatial

const CAM_ZOOM = 3.0

var cell_scene = preload("res://Cell.tscn")
var c: Cell

func set_cell(cell: Cell):
	c = cell_scene.instance()
	c.hide_indicators()
	c.cell_size = cell.cell_size
	c.faces = cell.faces
	c.name_tag = cell.name_tag
	c.update_faces()
	c.align_panels()
	add_child(c)
	set_rotation_x(cell)
	set_rotation_y(cell)
	$Pivot/Camera.translation.z = CAM_ZOOM * $Cell.max_size * c.orientation.z

func set_rotation_x(cell):
	$Pivot.transform.basis = Basis()
	$Pivot.rotate_x(cell.orientation.x)

func set_rotation_y(cell):
	c.transform.basis = Basis()
	c.rotate_y(cell.orientation.y)
