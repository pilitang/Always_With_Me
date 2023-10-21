extends BaseDataControl

@onready var scrollContainer = find_child("scrollContainer")
@onready var common_title = find_child("common_title")
@onready var listarr
@onready var body = find_child("body")
@onready var tileLabel = find_child("tileLabel")
@onready var commonPager = find_child("CommonPager")

var current_target =0

func _ready():
	var itemList = []
	for url in listarr:
		var full_screen_image_item = load("res://common/gui/full_screen_image_item.tscn").instantiate()
		full_screen_image_item.data = url
		itemList.append(full_screen_image_item)
	commonPager.list = itemList
	commonPager.current_index = current_target

func _on_common_title_back_on_click(node):
	super.queue_free()
	pass # Replace with function body.


func _on_CommonPager_index_change(value):
	tileLabel.text = str(commonPager.current_index+1)+"/" + str(listarr.size())


func _on_CommonPager_on_click(node):
	super.queue_free()
	pass # Replace with function body.
