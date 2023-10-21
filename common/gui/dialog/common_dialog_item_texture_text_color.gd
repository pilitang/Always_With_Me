extends BaseDataControl

#items = [{path:"",label:""}]


var selectContent = ""
var	items : Array = []
var color : Color 

var post
var offset = 10
func _ready():
	for item in items:
		var node = load("res://common/gui/dialog/dialog_item_content_texture_text.tscn").instantiate()
		if items.back() == item:
			node.is_separation_line = false
		%contentContainer.add_child(node)
		node.connect("on_click",Callable(self,"on_item_click"))
		node.data = item
	var styleBox = StyleBoxFlat.new()
	styleBox.bg_color = color
	styleBox.corner_radius_top_left = 8
	styleBox.corner_radius_top_right = 8
	styleBox.corner_radius_bottom_right = 8
	styleBox.corner_radius_bottom_left = 8
	%marginContainer.styleBox = styleBox
	%down_arrow.self_modulate = color
	await get_tree().process_frame
	var marginSize = %marginContainer.get_combined_minimum_size() 
	var arrowSize = %down_arrow.get_combined_minimum_size() 
	%marginContainer.position = post - Vector2(marginSize.x/2,marginSize.y+arrowSize.y+offset)
	%down_arrow.position = post -Vector2(arrowSize.x/2,arrowSize.y+offset+2)

func on_item_click(node):
	selectContent = node.data.text
	super.queue_free()

func _on_Control_on_click(node):
	super.queue_free()
