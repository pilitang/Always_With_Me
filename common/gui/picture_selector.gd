
extends BaseControl

@onready var panel:BaseControl = find_child("panel")

@onready var scrollcontainer : CommonScrollContainer = find_child("CommonScrollContainer")
@onready var picture_node = find_child("picture_node")
var speed = 10
#var imag_choose:Texture2D = null : set = imag_choose_set
@onready var imag_node = find_child("imag_node")
@onready var common_title = find_child("common_title")
var path =""
var pathlist = [] 
@export var pathMax: int = 6
@export var isMax: bool = true
var listarr = []


func _ready():

	dir_contents(OS.get_system_dir(OS.SYSTEM_DIR_PICTURES))

	initNode()
	
func initNode():
	init_container()
	common_title.get_node("confirm").connect("on_click",Callable(self,"confirm_on_click"))

func confirm_on_click(node):
	var mediaList = []
	for i in pathlist:
		mediaList.append(LocalMediaWrapper.create(i))
	emit_signal("result_data",mediaList)
	
	get_parent().remove_child(self)
	
#	free()
	
func init_container():
	scrollcontainer.registItemType("res://common/gui/picture.tscn")
	scrollcontainer.connect("on_item_click",Callable(self,"picture_node_click"))
	scrollcontainer.childClickName.append("circle_selection")
	scrollcontainer.connect("on_child_item_click",Callable(self,"picture_on_child_item_click"))

func path_list_update(child,picture):
	for i in picture_node.get_children():
		if pathlist.find(i.data) >= 0:
			i.index = str(pathlist.find(i.data)+1)
			i.select = true
		else:
			i.index = ""
			i.select = false

func picture_on_child_item_click(child,node):
	var picture = child.get_parent().get_parent()
	if pathlist.find(picture.data) != -1:
		pathlist.remove_at(pathlist.find(picture.data))
		path_list_update(child,picture)
		return
	if !isMax:
		pathlist.append(picture.data)
		if pathlist.size() > pathMax:
			pathlist.remove_at(0)
	else:
		if pathlist.size() < pathMax:
			pathlist.append(picture.data)
		else:
			ToastRouter.showToast("只能选择"+str(pathMax)+"张图片")
	path_list_update(child,picture)
	
func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if (".jpg" in file_name or ".png" in file_name ):
					listarr.append(path+"/"+file_name)
			file_name = dir.get_next()
	select_change_update(listarr)
	
func select_change_update(data):
	scrollcontainer.data = data
	
func picture_node_click(data):
	path = (data.data)
	CommonRouter.goto_full_screen_image(listarr,listarr.find(path))
	
	
	
