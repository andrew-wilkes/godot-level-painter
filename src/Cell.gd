extends Spatial

class_name Cell, "res://assets/icons/cell-icon.png"

"""
A cell is an object containing data about what object (if any)
is positioned in each of the 6 faces of the cube-like box around
the volume of the 2x2x2 unit space.

The base of the cell is at coordinate y-zero.

A typical object may be a MeshInstance of a wall.
Tall and wide walls will be scaled.
But the cell itself is not scaled since the thickness of walls should not be scaled.
Hence we maintain a cell_scale vector to adjust positioning.
"""

var name_tag: String = "Unnamed"
var level: int = 0
var cell_size = Vector3(1, 1, 1)
var max_size = 1.0
var faces = [null, null, null, null, null, null]
var orientation = Vector3(-0.5, -0.5, 1)

func update_faces():
	for i in range(6):
		update_face(i)

func update_face(i):
	set_cell_size()
	if get_child(i).get_child_count() == 0:
		if faces[i] != null:
			# Add new panel
			add_new_panel(i)
			print("Added new panel")
	else:
		var panel = get_child(i).get_child(0)
		if faces[i] == null:
			# Remove panel
			panel.queue_free()
			print("Removed panel")
		elif panel.part_type == Parts.parts.keys()[faces[i].part_id]:
			# Update same panel
			update_panel_settings(panel, i)
		else:
			# Change panel
			panel.queue_free()
			add_new_panel(i)

func add_new_panel(i: int):
	var part = Parts.get_part(faces[i].part_id)
	get_child(i).add_child(part)
	update_panel_settings(part, i)
	align_panel(part, i)

func update_panel_settings(panel: MeshInstance, i: int):
	var face = faces[i]
	if face == null: return
	panel.texture_id = face.texture_id
	var tile_grid_size = Vector2(1, 1)
	if face.tiled: tile_grid_size = face.scale
	panel.tile_grid_size = tile_grid_size
	panel.thickness = face.thickness
	panel.color = face.albedo
	panel.emit_color = face.emission

func align_panels():
	for i in range(6):
		if get_child(i).get_child_count() > 0:
			var panel = get_child(i).get_child(0)
			align_panel(panel, i)

func align_panel(panel: Node, pos: int):
	var trans = Vector3(0, 0, 0)
	# Shift into it's face position
	match pos:
		g.FACES.FRONT:
			trans.z = -cell_size.z
		g.FACES.BACK:
			trans.z = -cell_size.z
		g.FACES.RIGHT:
			trans.z = -cell_size.x
		g.FACES.LEFT:
			trans.z = -cell_size.x
		g.FACES.CEILING:
			trans.z = -cell_size.y
		g.FACES.FLOOR:
			trans.z = -cell_size.y
	panel.translation = trans
	if faces[pos] != null:
		panel.scale = Vector3(faces[pos].scale.x, faces[pos].scale.y, 1.0)
		panel.translation += faces[pos].offsets

func set_cell_size():
	# base it on max dimensions of faces
	var x = 1.0
	for i in [g.FACES.FRONT, g.FACES.CEILING, g.FACES.FLOOR, g.FACES.BACK]:
		if faces[i] != null:
			x = max(x, faces[i].scale.x)
	var y = 1.0
	for i in [g.FACES.FRONT, g.FACES.LEFT, g.FACES.RIGHT, g.FACES.BACK]:
		if faces[i] != null:
			y = max(y, faces[i].scale.y)
	var z = 1.0
	for i in [g.FACES.CEILING, g.FACES.FLOOR]:
		if faces[i] != null:
			z = max(z, faces[i].scale.y)
	for i in [g.FACES.LEFT, g.FACES.RIGHT]:
		if faces[i] != null:
			z = max(z, faces[i].scale.x)
	cell_size = Vector3(x, y, z)
	$Volume.scale = cell_size
	max_size = max(x, max(y, z))

func hide_indicators():
	$FrontMarker.hide()
	$Volume.hide()
