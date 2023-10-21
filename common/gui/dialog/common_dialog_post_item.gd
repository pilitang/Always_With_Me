extends BaseControl

var showPosition = 0
var	items : Array = []
var resource = preload("res://common/gui/dialog/dialog_item_post_content.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var vBoxContainer = find_child("vBoxContainer")
@onready var contentContainer = find_child("contentContainer")
var post = Vector2()
var selectContent = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	for content in items :
		var itemNode :BaseControl = resource.instantiate()
		itemNode.text = content
		itemNode.connect("on_click",Callable(self,"on_item_click"))
		contentContainer.add_child(itemNode)
	match showPosition :
		BaseDialog.LEFT :
			contentContainer.styleBox = load("res://common/gui/dialog/stylebox/dialog_item_bg_left.stylebox")
			contentContainer.get_child(0).set("theme_override_styles/normal",load("res://common/gui/dialog/stylebox/dialog_item_left_top.stylebox"))
			contentContainer.get_child(contentContainer.get_child_count()-1).set("theme_override_styles/normal",load("res://common/gui/dialog/stylebox/dialog_item_left_bottom.stylebox"))
			contentContainer.size_flags_horizontal = Control.SIZE_SHRINK_END
		BaseDialog.RIGHT :
			contentContainer.styleBox = load("res://common/gui/dialog/stylebox/dialog_item_bg_right.stylebox")
			contentContainer.get_child(0).set("theme_override_styles/normal",load("res://common/gui/dialog/stylebox/dialog_item_right_top.stylebox"))
			contentContainer.get_child(contentContainer.get_child_count()-1).set("theme_override_styles/normal",load("res://common/gui/dialog/stylebox/dialog_item_right_bottom.stylebox"))
			contentContainer.size_flags_horizontal = Control.SIZE_EXPAND
		BaseDialog.CENTER :
			contentContainer.styleBox = load("res://common/gui/dialog/stylebox/dialog_item_bg_center.stylebox")
			contentContainer.get_child(0).set("theme_override_styles/normal",load("res://common/gui/dialog/stylebox/dialog_item_center_top.stylebox"))
			contentContainer.get_child(contentContainer.get_child_count()-1).set("theme_override_styles/normal",load("res://common/gui/dialog/stylebox/dialog_item_center_bottom.stylebox"))
			contentContainer.size_flags_horizontal = Control.SIZE_SHRINK_CENTER	

	vBoxContainer.position = post - Vector2(0,vBoxContainer.get_combined_minimum_size().y)

func _on_root_on_click(node):
	super.queue_free()
	
func on_item_click(node) :
	selectContent = node.text
	super.queue_free()
	
