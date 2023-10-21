extends Node


var save_name = ""
var text_name = "未知"
var texture_data = FileUtil.loadAssets("res://configure/texture.json")
var drama_data = FileUtil.loadAssets("res://configure/drama.json")
#var dialogue_data = FileUtil.loadAssets("res://dialogue/dialogue.json")

func save_data():
			#创建存档
	if save_name == "":
		save_name = SaveData.add_save()
	SaveData.save_file("地图数据",{
#		"hp":hp,
#		"knapsack":knapsack,
	},save_name)#创建存档

func get_data():
	var dic = SaveData.get_file("地图数据",{},save_name)
#	hp = dic["hp"]
#	knapsack = dic["knapsack"]


#
#@onready var imageCache : ImageCache = ImageCache.new()
#@onready var webSocket : WebSocket = WebSocket.new()
##@onready var threadPool : FutureThreadPool = FutureThreadPool.new()
#
#var normal_virtual_keyboard_height = 0
#var timeOffset = 0
#
#const DB_PATH = "user://db/"
#signal resource_load_complete(path)
#signal resource_arr_load_complete(path)
#
#var transition = preload("res://common/gui/loading/transition.tscn").instantiate()
#
#var world = null	
#signal world_complete
#func _ready():
#
#	add_child(imageCache)
#	add_child(webSocket)
##	threadPool.use_signals = true
##	add_child(threadPool)
#	add_child(transition)
#	if SysUtil.isMobile() : normal_virtual_keyboard_height = DisplayServer.virtual_keyboard_get_height() 
#
#func _exit_tree():
#	webSocket.close()
#
#signal task_change(task_id,number,task_arr)
#signal task_data_change()
#signal task_complete(task_id)
#var task_arr = []
#
#
#var refresh_task = false
#
#var  resource_request_list = []
#var  resource_arr_request_list = []
#
#var progress: Array = []
#var value = 0
#
#func resource_load_threaded(path:String , callable : Callable,cache_mode := ResourceLoader.CACHE_MODE_REUSE,progress_callable : Callable = Callable()) :
#	resource_request_list.append({"path":path,"callable":callable,"progress_callable":progress_callable})
#	ResourceLoader.load_threaded_request(path,"",true,cache_mode)
#
#
#func resource_load_arr_threaded(pathArr:Array , callable : Callable,cache_mode := ResourceLoader.CACHE_MODE_REUSE) :
#	resource_arr_request_list.append({"pathArr":pathArr,"callable":callable})
#	for path in pathArr:
#		ResourceLoader.load_threaded_request(path,"",true,cache_mode)
#
#func _process(delta):
#	for info in resource_request_list:
#		match ResourceLoader.load_threaded_get_status(info.path,progress) :
#			ResourceLoader.THREAD_LOAD_LOADED:
#
#				resource_request_list.erase(info)
#				if info.callable.is_valid():
#					info.callable.call(info.path,ResourceLoader.load_threaded_get(info.path))
#					resource_load_complete.emit(info.path)
#
#			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
#				value = clamp(progress[0]*100,0,100)
#
#				if info.progress_callable.is_valid() and !info.progress_callable.is_null():
#					info.progress_callable.call()
#
#
#
#	for info in resource_arr_request_list:
#		var count = 0
#		for path in info.pathArr:
#			if ResourceLoader.THREAD_LOAD_LOADED == ResourceLoader.load_threaded_get_status(path) :
#				count += 1
#		if count == info.pathArr.size():
#			resource_request_list.erase(info)
#			if info.callable.is_valid():
#				var arr = []
#				for path in info.pathArr:
#					arr.append({"path":path,"resource":ResourceLoader.load_threaded_get(path)})
##				print(arr,"-----------------------------")
#				info.callable.call(arr)
#				resource_arr_load_complete.emit(info.pathArr)

