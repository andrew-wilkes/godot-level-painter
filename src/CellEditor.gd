extends Spatial

const ROTATION_SPEED = 2.0
const CAMERA_SPEED = 10.0
const P2 = PI / 2.0
const INITIAL_CAM_Z = 4.0

var camera_spinning = { x = false, y = false }
var spin_direction = Vector2(1.0, -1.0)
var cell
var cam_pos = INITIAL_CAM_Z

func _ready():
	# The CellSettings child node loads the current cell
	cell = $CellSettings.cell
	$Cell.faces = cell.faces
	$Cell.update_faces()
	$Cell.align_panels()
	set_rotation_x()
	set_rotation_y()

func _on_up_down_pressed():
	$Camera.rotation.x *= -1.0
	$Camera.translation.y *= -1.0

func _on_spin_button_toggled(on):
	camera_spinning.y = on
	if on: spin_direction.y = -spin_direction.y

func _on_up_down_button_toggled(on):
	camera_spinning.x = on
	if on: spin_direction.x = -spin_direction.x

func _process(delta):
	if camera_spinning.x:
		cell.orientation.x = clamp(cell.orientation.x + delta * ROTATION_SPEED * spin_direction.x, -P2, P2)
		set_rotation_x()
	if camera_spinning.y:
		cell.orientation.y += delta * ROTATION_SPEED * spin_direction.y
		set_rotation_y()
	var z = cam_pos - $Pivot/Camera.translation.z
	if  abs(z) > 0.1:
		$Pivot/Camera.translation.z += delta * CAMERA_SPEED * sign(z)

func set_rotation_x():
	$Pivot.transform.basis = Basis()
	$Pivot.rotate_x(cell.orientation.x)

func set_rotation_y():
	$Cell.transform.basis = Basis()
	$Cell.rotate_y(cell.orientation.y)

func _on_face_changed(idx):
	$Cell.update_face(idx)
	$Cell.align_panels()
	set_cam_pos()
	set_size_vals()

func set_size_vals():
	$CellSettings.set_size_values($Cell.cell_size)

func _on_zoom_changed(v):
	cell.orientation.z = 1.0 + v
	set_cam_pos()

func set_cam_pos():
	cam_pos = INITIAL_CAM_Z * $Cell.max_size * cell.orientation.z
	pass

func _on_ok_button_pressed():
	# add or update cell
	if g.cell_idx < 0:
		g.cells.append(cell)
	else:
		g.cells[g.cell_idx] = cell
	return get_tree().change_scene("res://CellSelector.tscn")
