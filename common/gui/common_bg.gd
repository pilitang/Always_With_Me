@tool
extends BaseControl
@export var root_path:NodePath = ""


func _on_bg_on_click(_node):
	if not root_path.is_empty() :
		get_node(root_path).queue_free()
