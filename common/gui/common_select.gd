@tool
class_name CommonSelect
extends BaseControl
@export var unselectIcon :Resource
@export var selectIcon :Resource

var isSelect = false :
	set(value):
		isSelect = value
		if value :
			%icon.texture = selectIcon
		else:
			%icon.texture = unselectIcon

func _ready():
	%icon.texture = unselectIcon
