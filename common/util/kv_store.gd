@tool
extends Node


var config = ConfigFile.new()
const PATH = "user://kvstore.cfg"
const SECTION_DEFAULT = "default"
func _init():
	if !FileAccess.file_exists(PATH):
		config.save(PATH)
	else:
		config.load(PATH)

func put(key:String,value):
	config.set_value(SECTION_DEFAULT,key,value)
	return config.save(PATH)
	
func get_value(key:String,default):
	return config.get_value(SECTION_DEFAULT,key,default)
	
func has(key:String) -> bool :
	return config.has_section_key(SECTION_DEFAULT,key) 

func remove_key(key:String):
	if config.has_section_key(SECTION_DEFAULT,key) :
		config.erase_section_key(SECTION_DEFAULT,key)

