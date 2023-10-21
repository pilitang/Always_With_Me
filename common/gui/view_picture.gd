extends Control

#onready var panel:BaseControl = find_child("panel")
#onready var texturerect = find_child("texturerect")

func _ready():
#	panel.connect("on_click",Callable(self,"bg_click"))
	pass # Replace with function body.

func bg_click(new_ve):
	super.queue_free()
	pass
