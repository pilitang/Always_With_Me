@tool
extends BaseControl


var check = false : set = check_set
@onready var hook = find_child("Hook")

func check_set(value):
	check = value
#	hook.visible = check
	hook.texture = load("res://profile/login/res/btn_ye_op.webp") if check else load("res://profile/login/res/btn_ye_cl.webp")

func _on_Control_on_click(node):
	self.check = !check
