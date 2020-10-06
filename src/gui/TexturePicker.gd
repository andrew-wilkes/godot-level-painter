extends Control

signal item_selected(index)
signal texture_picker_closed

func _ready():
	add_textures()
	print($Popup/ItemList.connect("item_selected", self, "item_selected"))

func add_textures():
	for t_key in Parts.textures.keys():
		$Popup/ItemList.add_icon_item(Parts.textures[t_key])

func item_selected(index):
	$Popup.hide()
	emit_signal("item_selected", index)

func _on_popup_hide():
	emit_signal("texture_picker_closed")
