@tool
extends ColorRect

var speed = 0.1
var state = UNCHANGED
var obj = null
var is_it_mandatory = false
enum {
	UNCHANGED = 0,
	FOLLOW = 1,
	}
func _process(_delta):
	if state == FOLLOW:
		if obj != null:
			if is_it_mandatory :
				position.x = obj.position.x+(obj.size.x/2)
				is_it_mandatory = false
			else:
				position.x = lerp(position.x,obj.position.x+(obj.size.x/2),0.1)
				if get_node("Line2D").get_point_count()>0:
					get_node("ColorRect").position = get_node("Line2D").get_point_position(0)
	pivot_offset = size/2
	pass
func force(newval,bo):
	obj = newval
	is_it_mandatory = bo
	get_node("Line2D").prepare = true
#	visible = true
	

func follow(newval,st):
	obj = newval
	state = st
	pass



func _on_Timer_timeout():
	
	pass # Replace with function body.
