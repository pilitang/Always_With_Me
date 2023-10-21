class_name CommonIndicator
extends Control


var distance: int = 0 
var current_index : int = 0
var list:Array : set = list_set

signal click(index)
@onready var line = find_child("line")
@onready var tabContainer = find_child("tabContainer")
var tabRes = load("res://common/gui/common_indicator_tab.tscn")

func list_set(new_value):
	list = new_value
	update_list()
	line.force(tabContainer.get_child(0),true)
	tabContainer.get_child(0).is_it_mandatory = true
	
func update_list():
	for title in list:
		var item = tabRes.instantiate()
		item.connect("on_click",Callable(self,"item_click"))
		tabContainer.add_child(item)
		item.title.text = title

	pass

func slide_distance_change(value):
	distance = value

func index_change(value):
	for child in tabContainer.get_children():
		if child == tabContainer.get_child(value):
			child.state = 1
			line.follow(child,1)
		else:
			child.state = 2

func item_click(node : BaseControl):
	emit_signal("click",node.get_index() )

