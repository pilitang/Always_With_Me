@tool
extends BaseDataControl

@export var add_image: bool = false : set = add_image_set

signal cancel_on_click(node)

@onready var cancelContainer = find_child("cancelContainer")
@onready var image = find_child("image")
@onready var panel = find_child("panel")

func add_image_set(data):
	add_image = data
	update()
func update():
	if not is_inside_tree() : return
	cancelContainer.visible = !add_image
	
func data_update():
	image.url  = data.path

func _on_cancelContainer_on_click(node):
	emit_signal("cancel_on_click",self)
