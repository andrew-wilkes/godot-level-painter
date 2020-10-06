extends Control

var cell_editor = preload("res://CellEditor.tscn")
var cell_preview = preload("res://CellPreview.tscn")
var cell_control = preload("res://CellControl.tscn")

const VP_SIZE = 96

func _ready():
	var idx = 0
	for cell in g.cells:
		var scene = cell_preview.instance()
		scene.set_cell(cell)
		var v = Viewport.new()
		v.size = Vector2(VP_SIZE, VP_SIZE)
		v.render_target_v_flip = true
		v.render_target_clear_mode = Viewport.CLEAR_MODE_NEVER
		v.render_target_update_mode = Viewport.UPDATE_ONCE
		v.own_world = true
		v.add_child(scene)
		$Views.add_child(v)
		var cont = cell_control.instance()
		cont.set_texture(v.get_texture())
		cont.set_title(cell.name_tag)
		cont.idx = idx
		idx += 1
		find_node("Cells").add_child(cont)
	var r = 0
	r += event_bus.connect("cell_selected", self, "_set_selected_cell")
	r += event_bus.connect("edit_cell", self, "_edit_cell")
	r += event_bus.connect("delete_cell", self, "_delete_cell")
	return r

func _on_NewCell_button_down():
	g.cell_idx = -1
	return get_tree().change_scene_to(cell_editor)

func _set_selected_cell(idx):
	print("Select %d" % idx)
	g.cell_idx = idx

func _edit_cell(idx):
	print("Edit %d" % idx)
	g.cell_idx = idx
	return get_tree().change_scene_to(cell_editor)

func _delete_cell(idx):
	print("Delete %d" % idx)
	# queue deleted cell for freeing and modify remaining cell idx values
	for i in g.cells.size():
		var cell = find_node("Cells").get_child(i + 1)
		if i == idx:
			cell.queue_free()
		if i > idx:
			cell.idx -= 1
	g.cells.remove(idx)
