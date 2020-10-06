extends Control

signal spin_button_toggled(on)
signal up_down_button_toggled(on)
signal face_changed(idx)
signal zoom_changed(v)
signal ok_button_pressed()

export(Texture) var blank

var cell: Cell
var _current_index: int
var remove_face = false

func _ready():
	# Load the current Cell or create a new Cell
	if g.cell_idx < 0:
		cell = Cell.new()
	else:
		cell = g.cells[g.cell_idx]
	$Panel/VBox/NameTag.text = cell.name_tag
	set_size_values(cell.cell_size)
	# Set up face selection buttons
	var idx = 0
	for button in get_tree().get_nodes_in_group("Faces"):
		var title = String(g.FACES.keys()[idx])
		button.set_tooltip(title)
		button.connect("pressed", self, "open_face_settings", [idx, title])
		idx += 1

func set_size_values(size: Vector3):
	$Panel/VBox/Size/HBox/Label/HBox/X.text = String(size.x)
	$Panel/VBox/Size/HBox/Label/HBox/Y.text = String(size.y)
	$Panel/VBox/Size/HBox/Label/HBox/Z.text = String(size.z)

func _on_Remove_toggled(value):
	remove_face = value

func update_face():
	if remove_face:
		cell.faces[_current_index] = null
	remove_face = false
	emit_signal("face_changed", _current_index)

func open_face_settings(idx, title):
	_current_index = idx
	if cell.faces[idx] == null:
		cell.faces[idx] = Face.new()
	$FaceSettings.open_panel(cell, idx, title)

func _on_face_settings_closed():
	update_face()

func _on_zoom_value_changed(value):
	emit_signal("zoom_changed", value)

func _on_Spin_button_down():
	emit_signal("spin_button_toggled", true)

func _on_Spin_button_up():
	emit_signal("spin_button_toggled", false)

func _on_UpDown_button_down():
	emit_signal("up_down_button_toggled", true)

func _on_UpDown_button_up():
	emit_signal("up_down_button_toggled", false)

func _on_OK_button_down():
	var txt = $Panel/VBox/NameTag.text
	if txt.length() < 1:
		txt = "Unnamed"
	cell.name_tag = txt
	emit_signal("ok_button_pressed")

func _on_NameTag_text_changed():
	pass
