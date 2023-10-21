class_name ImageUtil
extends Object	
	
static func get_image_texture(path:String)->ImageTexture:
	var image = Image.load_from_file(path)
	return ImageTexture.create_from_image(image)
