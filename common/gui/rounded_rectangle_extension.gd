@tool
class_name rounded_rectangle_extension
extends NinePatchRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var label:NodePath
@export var font_size:int
@export var data :String : get = data_get, set = data_set


func data_set(new_value):
	data = new_value
	data_update()

func data_get():
	return data
# Called when the node enters the scene tree for the first time.
func data_update():
	get_node(label).text = data
	size.x = (24*2)+(get_node(label).text.length()*font_size)
	custom_minimum_size.x = (24*2)+(get_node(label).text.length()*font_size)
	pass # Replace with function body.

func modify(txt):
	
	get_node(label).text = txt
	size.x = (24*2)+(get_node(label).text.length()*font_size)
	custom_minimum_size.x = (24*2)+(get_node(label).text.length()*font_size)

