extends BaseDataControl


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parent = null

func data_update():
#	get_parent()
	$TextureRect.url = (data)

func _process(delta):
	if parent != null:
		custom_minimum_size.x = parent.size.x
