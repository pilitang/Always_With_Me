@tool
class_name colorPickerButtonSimplify
extends ColorPickerButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if get_picker().get_child_count() > 1:
		for i in get_picker().get_child_count():
			if i != 0:
				
				get_picker().get_child(i).visible = false
#	get_picker().set("script",load("res://test/ColorPicker.gd"))
