extends Spatial

func _ready():
	var part = Parts.get_part(8)
	add_child(part)
