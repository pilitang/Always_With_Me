@tool
extends Control

@export var color:Color : set = colorset
@export var root_path:NodePath = ""
@export var open_confirm:bool = false : set = open_confirm_set


@export var title_text : String = ""  : set = title_text_set

@onready var confirm_label = find_child("confirm_label")
@onready var confirm = find_child("confirm")
func colorset(value):
	color = value
	update()
func open_confirm_set(value):
#	confirm = get_node("confirm")
	open_confirm = value
	update()
	
	
func title_text_set(value):
	title_text = value
	update()
	
func _ready():
	update()
	
func update():
	if not is_inside_tree() : return
	$Label.text = title_text
	$confirm.visible = open_confirm

func _on_common_title_back_on_click(node):
	if !root_path.is_empty():
		get_node(root_path).queue_free()
