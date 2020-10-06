extends Control

var idx: int

func _on_Select_button_down():
	event_bus.emit_cell_selected(idx)

func _on_Edit_button_down():
	event_bus.emit_edit_cell(idx)

func _on_Delete_button_down():
	event_bus.emit_delete_cell(idx)

func set_texture(tex):
	find_node("Preview").texture = tex

func set_title(txt):
	find_node("Title").text = txt
