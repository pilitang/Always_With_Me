extends Control

var isDrag = false
signal move(direction_vector)
	
var lastEvent = null
func _on_gui_input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
		lastEvent = event
	if event is InputEventScreenTouch:
		isDrag = event.pressed
		if event.pressed :
			%panel.global_position = global_position+event.position - %bg.size/2
		else:
			%panel.position  = Vector2.ZERO
		emit_signal("move",Vector2.ZERO)
		
func getPoint(center_post,click_post,distance):
	var hd = atan2(click_post.y - center_post.y , click_post.x - center_post.x)
	var post = Vector2(0,0)
	post.x = center_post.x + distance * cos(hd)
	post.y = center_post.y + distance * sin(hd)
	return post

func _process(delta):
	var center = %bg.global_position + %bg.size/2- %rocker.size/2
	if isDrag :
		var click_post:Vector2 = global_position + lastEvent.position 
		var center_post:Vector2 = %bg.global_position + %bg.size/2
		var distance = (%bg.size/2).x
		if click_post.distance_to(center_post) < distance:
			%rocker.global_position = click_post - %rocker.size/2
		else:
			%rocker.global_position = getPoint(center_post,click_post,distance)  - %rocker.size/2
		emit_signal("move",(click_post-center_post).normalized())
	elif center != %rocker.global_position:
		%rocker.global_position = lerp(%rocker.global_position,center,10*delta)
		emit_signal("move",Vector2.ZERO)
		if (%rocker.global_position- center).length() < 1:
			%rocker.global_position = center





