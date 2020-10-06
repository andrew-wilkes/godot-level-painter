extends Node

signal cell_selected(idx)
signal edit_cell(idx)
signal delete_cell(idx)

func emit_cell_selected(idx):
	emit_signal("cell_selected", idx)

func emit_edit_cell(idx):
	emit_signal("edit_cell", idx)

func emit_delete_cell(idx):
	emit_signal("delete_cell", idx)
