extends BaseControl

var speed = 0.1
var state = UNCHANGED

enum {
	UNCHANGED = 0,
	MAGNIFY = 1,
	NARROW = 2
}

var is_it_mandatory = false

@onready var title = find_child("title")

func _process(_delta):
	if state == MAGNIFY:
		zoom_in()
	elif state == NARROW:
		zoom_out()
	title.pivot_offset = title.size/2
	if is_it_mandatory:
		is_it_mandatory = false
		force()
		
func force():
	title.scale = Vector2(2,2)
	title.self_modulate = Color(1,1,1,1)
func zoom_in():
	title.scale = lerp(title.scale,Vector2(1,1),speed)

func zoom_out():
	title.scale = lerp(title.scale,Vector2(0.8,0.8),speed)
