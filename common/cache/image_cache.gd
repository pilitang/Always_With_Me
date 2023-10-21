class_name ImageCache
extends BaseNode


var dict : Dictionary = {}
var list : Array = []
func add( url :String ,tex : Texture ):
	dict[url] = tex
	list.append(url)
	
func find(url :String) -> Texture:
	if not has(url) : return null
	list.erase(url)
	list.append(url)
	return dict[url]
	
func has(url :String) -> bool:
	return dict.has(url)

func _process(_delta):
	if dict.size() >100 :
		dict.erase(list.pop_front())

