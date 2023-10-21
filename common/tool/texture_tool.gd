class_name TextureTool
extends Node


static func texture_load(id):
	return load(Global.texture_data[id].path)
