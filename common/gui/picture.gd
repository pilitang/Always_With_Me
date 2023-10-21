extends BaseDataControl


@onready var select_label = find_child("select")

var index = 0
var select = false : set = set_select
var my_task = null
var texture = null
func data_update():
	if not is_inside_tree() : return
	%image.url = data
		
func set_select(value):
	select = value
	if select:
		select_label.text = str(index)
		select_label.set("theme_override_styles/normal",load("res://common/gui/stylebox/image_select.stylebox"))
	else:
		select_label.text = ""
		select_label.set("theme_override_styles/normal",load("res://common/gui/stylebox/image_unselect.stylebox"))
