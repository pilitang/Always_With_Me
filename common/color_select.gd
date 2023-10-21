class_name ColorChange
extends BaseControl

signal color_change(color)

@onready var waiweiViewport = find_child("waiweiViewport")
@onready var neiquanViewport = find_child("neiquanViewport")
@onready var waiwei_select = find_child("waiwei_select")
@onready var neiquan_select = find_child("neiquan_select")
@onready var waiwei = find_child("waiweiContainer")
@onready var neiquan = find_child("neiquanContainer")
@onready var baseColor = find_child("baseColor")

var waiwei_pressed = false
var curColor = Color.WHITE

func _ready():
	baseColor.modulate = curColor

func _on_waiwei_container_gui_input(event):
	if event is InputEventScreenTouch :
		var mb_post:Vector2 = waiwei.global_position + event.position
		var zxd_post:Vector2 = waiwei.global_position + waiwei.size/2
		var neiquan_distance = (neiquan.size/2).x+20
		var waiwei_distance = (waiwei.size/2).x-10
		if event.pressed and mb_post.distance_to(zxd_post) > neiquan_distance and mb_post.distance_to(zxd_post) < waiwei_distance:
			waiwei_pressed = true
		else :
			waiwei_pressed = false
			
	if event is InputEventScreenDrag and waiwei_pressed :
		var mb_post:Vector2 = waiwei.global_position + event.position
		var zxd_post:Vector2 = waiwei.global_position + waiwei.size/2
		var waiwei_ima = waiweiViewport.get_texture().get_image()
		waiwei_select.visible = true
		var color :	Color
		var neiquan_distance = (neiquan.size/2).x+20
		var waiwei_distance = (waiwei.size/2).x-10
		if mb_post.distance_to(zxd_post) > neiquan_distance and mb_post.distance_to(zxd_post) < waiwei_distance:
			waiwei_select.global_position = mb_post- waiwei_select.size/2
			color = waiwei_ima.get_pixelv(event.position)
		elif mb_post.distance_to(zxd_post) > waiwei_distance:
			waiwei_select.global_position = getPoint(zxd_post,mb_post,waiwei_distance)  - waiwei_select.size/2 
			color = waiwei_ima.get_pixelv(waiwei_select.global_position-waiwei.global_position + waiwei_select.size/2)
		elif mb_post.distance_to(zxd_post) < neiquan_distance:
			waiwei_select.global_position = getPoint(zxd_post,mb_post,neiquan_distance)  - waiwei_select.size/2 
			color = waiwei_ima.get_pixelv(waiwei_select.global_position-waiwei.global_position + waiwei_select.size/2)
		baseColor.modulate = color
		change_color(color)	

func _on_neiquan_container_gui_input(event):
	
	if event is InputEventScreenDrag and not waiwei_pressed :
		var neiquan_ima = neiquanViewport.get_texture().get_image()
		neiquan_select.visible = true

		var mb_post:Vector2 = neiquan.global_position + event.position 
		var zxd_post:Vector2 = neiquan.global_position + neiquan.size/2
		var distance = (neiquan.size/2).x-2
		var color :	Color
		if mb_post.distance_to(zxd_post) < distance:
			neiquan_select.global_position = mb_post - neiquan_select.size/2
			color = neiquan_ima.get_pixelv(event.position)
		else:
			neiquan_select.global_position = getPoint(zxd_post,mb_post,distance)  - neiquan_select.size/2
			color = neiquan_ima.get_pixelv(neiquan_select.global_position-neiquan.global_position + neiquan_select.size/2)	
		change_color(color)	

func getPoint(zxd_post,mb_post,jl):
	var hd = atan2(mb_post.y - zxd_post.y , mb_post.x - zxd_post.x)
	var jd = hd*180/3.1415926 + 180
	var post = Vector2(0,0)
	post.x = zxd_post.x + jl * cos(hd)
	post.y = zxd_post.y + jl * sin(hd)
	return post

func change_color(color):
	curColor = color
	emit_signal("color_change",color)
	
func _on_Control_on_click(node):
	super.queue_free()
	pass # Replace with function body.



