class_name CommonImage
extends BaseControl



var parent_node = null
@export var maxEdge : int = 0 
var adjust = Vector2.ZERO

var url : String = "":
	set(value):
		if url != value or value.is_empty():
			self.texture = null
		url = value
		if url == null or  url.is_empty() :  return
		if url.begins_with("http") :
			if Global.imageCache.has(full_url()) :
				var tex = Global.imageCache.find(full_url())
				self.texture = tex
				adjustSize(tex.get_size()) 
			else :
				load_image_from_http()
		elif url.begins_with("res://") :
			var tex =  load(url)
			if tex != null :
				self.texture = tex
				adjustSize(tex.get_size())
				Global.imageCache.add(url,tex)
				
		else :
			var tex = ImageUtil.get_image_texture(url)
			if tex != null :
				self.texture = tex
				adjustSize(tex.get_size())
				Global.imageCache.add(url,tex)

func full_url():
	var longEdge = max(maxEdge,max(size.x,size.y))
	return url+"?imageView2/0/w/%d/format/webp" % longEdge

func _ready():
	super._ready()
	self.expand_mode = TextureRect.EXPAND_IGNORE_SIZE


			
func load_image_from_http():
	BaseNetwork.downloadFile(full_url(),self,"download_completed")
	
func download_completed(data: PackedByteArray):
	if not is_inside_tree() or is_queued_for_deletion() : return
	if data == null or data.is_empty() : 
		load_image_from_http()
		return
	var img = Image.new()
	var err = img.load_webp_from_buffer(data)
	if err != 0 or img == null or img.is_empty(): 
		load_image_from_http()
		return
	
	var image_tex = ImageTexture.create_from_image(img) #,0
	self.texture  = image_tex
	adjustSize(image_tex.get_size())
	Global.imageCache.add(full_url(),image_tex)


func adjustSize(adjust_size:Vector2):
	
	if adjust == Vector2.ZERO : return
	if adjust_size.y == 0 : return
#	max(size.x,size.y)
#	if size.x <= adjust.x and size.y <= adjust.y: #两个边都小于用原来的大小
#		custom_minimum_size = adjust
#		return
	elif adjust_size.x > adjust_size.y:
		custom_minimum_size.y = adjust.y
		custom_minimum_size.x = (adjust_size.x/adjust_size.y)*adjust.y
		return
	elif adjust_size.y > adjust_size.x:
		custom_minimum_size.x = adjust.x
		custom_minimum_size.y = (adjust_size.y/adjust_size.x)*adjust.x
		return
	else :
		custom_minimum_size = adjust
		
