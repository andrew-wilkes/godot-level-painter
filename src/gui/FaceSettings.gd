extends Control

signal face_settings_closed
signal remove_toggled(value)

const ACTIVE_PARAMETER_TEXT = "Toggle all active parameter check boxes"
const PARAMETER_TEXT = "Is this parameter active or not?"

var _texture_button
var _idx: int
var _face: Face
var _cell: Cell
var _thickness
var _img_size: Vector2
var _picking_texture = false

func _ready():
	$Panel/HBox/VBox/Active/HBox/All.set_tooltip(ACTIVE_PARAMETER_TEXT)
	if get_parent().name == "root":
		$Panel.popup_centered()
		_cell = Cell.new()
		_face = Face.new()
	_texture_button = $Panel/HBox/VBox/Texture/HBox/Button
	_img_size = _texture_button.rect_size
	_thickness = $Panel/HBox/VBox/Thickness/HBox/Value
	# Get references to the CheckBoxes
	for check_box in get_tree().get_nodes_in_group("Check"):
		check_box.set_tooltip(PARAMETER_TEXT)

func open_panel(cell: Cell, idx: int, title: String):
	_cell = cell
	_face = cell.faces[idx]
	_idx = idx
	_texture_button.icon = g.get_texture(_img_size.x, _img_size.y, _face.texture_id)
	$Panel.window_title = title
	$Panel/HBox/VBox/Active/HBox/Remove.pressed = false
	$Panel/HBox/VBox/Scale/HBox/x.set_value(_face.scale.x)
	$Panel/HBox/VBox/Scale/HBox/y.set_value(_face.scale.y)
	$Panel/HBox/VBox/Tiles/HBox/CheckButton.pressed =_face.tiled
	_thickness.text = String(_face.thickness)
	$Panel/HBox/VBox/Albedo/HBox/ColorPicker.set_pick_color(_face.albedo)
	$Panel/HBox/VBox/Emission/HBox/ColorPicker.set_pick_color(_face.emission)
	$Panel/HBox/VBox2/Part/HBox/List.clear()
	for t_key in Parts.parts.keys():
		$Panel/HBox/VBox2/Part/HBox/List.add_item(t_key)
	$Panel/HBox/VBox2/Part/HBox/List.select(_face.part_id)
	$Panel/HBox/VBox2/Offsets/HBox/Label/VBox/HBox/x.set_value(_face.offsets.x)
	$Panel/HBox/VBox2/Offsets/HBox/Label/VBox/HBox2/y.set_value(_face.offsets.y)
	$Panel/HBox/VBox2/Offsets/HBox/Label/VBox/HBox3/z.set_value(_face.offsets.z)
	set_checkboxes()
	show_panel()

func _on_TextureButton_pressed():
	_picking_texture = true
	$Panel.hide()
	$TexturePicker/Popup.popup_centered()

func _on_TexturePicker_item_selected(index: int):
	_texture_button.icon = g.get_texture(_img_size.x, _img_size.y, index)
	_face.texture_id = index

func _on_texture_picker_closed():
	show_panel()

func show_panel():
	$Panel.popup_centered()

func _on_x_value_changed(value):
	_face.scale.x = value

func _on_y_value_changed(value):
	_face.scale.y = value

func _on_CheckButton_toggled(button_pressed):
	_face.tiled = button_pressed

func _on_thickness_text_changed(txt):
	_thickness.modulate = Color(1,0,0)
	if txt.is_valid_float():
		var n = float(txt)
		if n > 0.0:
			_face.thickness = n
			_thickness.modulate = Color(1,1,1)

func _on_albedo_color_changed(color):
	_face.albedo = color

func _on_emission_color_changed(color):
	_face.emission = color

func _on_Main_Check_toggled(button_pressed):
	for idx in _face.active_params.size():
		_face.active_params[idx] = button_pressed
	set_checkboxes()

func set_checkboxes():
	var idx = 0
	for check_box in get_tree().get_nodes_in_group("Check"):
		check_box.pressed = _face.active_params[idx]
		idx += 1

func _on_Texture_Check_toggled(button_pressed):
	_face.active_params[0] = button_pressed

func _on_Scale_Check_toggled(button_pressed):
	_face.active_params[1] = button_pressed

func _on_Tiles_Check_toggled(button_pressed):
	_face.active_params[2] = button_pressed

func _on_Thickness_Check_toggled(button_pressed):
	_face.active_params[3] = button_pressed

func _on_Albedo_Check_toggled(button_pressed):
	_face.active_params[4] = button_pressed

func _on_Emission_Check_toggled(button_pressed):
	_face.active_params[5] = button_pressed

func _on_part_selected(index):
	_face.part_id = index

func _on_popup_hide():
	if _picking_texture:
		_picking_texture = false
	else:
		emit_signal("face_settings_closed")

func _on_Remove_toggled(button_pressed):
	emit_signal("remove_toggled", button_pressed)

func _on_xoff_value_changed(value):
	_face.offsets.x = value

func _on_yoff_value_changed(value):
	_face.offsets.y = value

func _on_zoff_value_changed(value):
	_face.offsets.z = value
