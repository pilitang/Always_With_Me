@tool
extends BaseDataControl

#data = {
#	"id" : 0
#}
# Called when the node enters the scene tree for the first time.

func _ready():
	
#	print(float(get_size()),float(self.texture.get_width()))
	pass # Replace with function body.
func data_update():
	self.texture = TextureTool.texture_load(data.id)
	if data.has("size"):
		custom_minimum_size = data.size
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if data.has("is_aspect_ratio") and data.is_aspect_ratio:
		var aspect_ratio = (float(size.x)/float(self.texture.get_width()))
		custom_minimum_size.y = self.texture.get_height() * aspect_ratio
	
	pass
