extends Node

var data = {
	
}

func _ready():
	data = load_data_all()
func put(key,value,path):
	data[key] = value
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(data)
	
func pull(key,desire,path):
	if !FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_var(data)
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_var()
	if content.has(key):
		return content[key]
	else:
		return desire
func pull_all(path):
	if !FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_var(data)
	var file = FileAccess.open(path, FileAccess.READ)
#	var6 content = file.get_var()
	return file.get_var()


#只负责存储系统消息
func save(key,value):
	put(key,value,"user://save_game.dat")

func load_data(key,desire = null):
	pull(key,desire,"user://save_game.dat")

func load_data_all():
	return pull_all("user://save_game.dat")



#负责存储存档
#创建存档
func add_save():
	#检查并创建所以游戏存档的根目录
	add_dir("user://save/")
	var text = str(Time.get_datetime_string_from_datetime_dict(Time.get_datetime_dict_from_unix_time(Time.get_unix_time_from_system()),false))
	text = text.replace("-","_")
	text = text.replace(":","_")
	text = text.replace("T","_")
	var path = Global.text_name+text
	add_dir("user://save/"+path)
	return path

func save_file(key,value,save_name):
	
	put(key,value,"user://save/"+save_name+"/"+key)
#	print()

func get_file(key,value,save_name):
	return pull(key,value,"user://save/"+save_name+"/"+key)
	
func add_dir(path):
	var dir = DirAccess.open("user://")
	if not dir.dir_exists(path):
		dir.make_dir_recursive(path)
