class_name FileUtil
extends RefCounted


static func saveFile(data,name,ext = ".dat"):
	var path = "user://"+name+ext
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(var_to_str(data))

static func loadFile(name,ext=".dat"):
	var path = "user://"+name+ext
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var text = file.get_as_text()
		return str_to_var(text)
	return null

static func loadAssets(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var text = file.get_as_text()
		return str_to_var(text)
	return null
	
	
