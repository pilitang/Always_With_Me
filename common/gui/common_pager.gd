class_name CommonPager
extends Control

signal slide_distance_change(value)
signal index_change(value)
signal on_click(node)

@export var enable_scroll :bool = false
var list:Array : set = list_set

func list_set(new_value):
	list = new_value
	remove_all_child()
	update_list()
	set_index(0)
	await get_tree().process_frame
	update_position(true)
	

var distance: int = 0 : set = distance_set

func distance_set(new_value):
	distance = new_value
	emit_signal("slide_distance_change",distance)
	queue_redraw()
	
var current_index : int = 0 : set = set_index

func set_index(new_value):
	if new_value != current_index: 
		if new_value <= 0 :
			current_index = 0
		elif new_value >= list.size()-1:
			current_index = list.size()-1
		else:
			current_index = new_value
	emit_signal("index_change",current_index)
	queue_redraw()
	
func remove_all_child():
	for child in get_children():
		child.queue_free()

func update_list():
	for item in list:
		add_child(item)

func slide_left():
	if current_index > 0:
		self.current_index -= 1
	pass
func slide_right():
	if current_index < list.size() - 1:
		self.current_index += 1
		
const dragLimit : int = 2
var dragCount : int = 0
var dragOffset :Vector2 = Vector2.ZERO

var clickTime = 0
func _gui_input(event):
	if !enable_scroll : return
	
	if event is InputEventScreenDrag  :
		if dragCount < dragLimit :
			dragOffset += event.relative
		dragCount +=1
		if dragCount>=dragLimit and abs(dragOffset.x) > abs(dragOffset.y):
			if  (current_index <= 0 and distance >=60) or (current_index >= list.size()-1 and distance <=-60) :
				return
			self.distance += event.velocity.x
			
	if event is InputEventScreenTouch :

		dragCount = 0
		dragOffset = Vector2.ZERO
		if event.pressed == true:
			self.distance = 0
			clickTime = Time.get_ticks_msec()
		if event.pressed == false:
			var diff = Time.get_ticks_msec() - clickTime
			clickTime = 0
			
			if diff < 800 and abs(distance) < 2:
				emit_signal("on_click",self)
			else:
				if distance < 0 :
					self.current_index += 1
				elif distance > 0 :
					self.current_index -= 1
				self.distance = 0
			
func _process(_delta):
	var pos =  - (current_index * size.x)
	if list.size() >0 and int( get_child(0).position.x) != pos :
		queue_redraw()

func _draw():
	update_position()
	
func update_position(force:bool = false):
	for index in list.size():
		var pos = size.x * index - (current_index * size.x)
		if force == true ||  abs(get_child(index).position.x - pos) < 0.2:
			get_child(index).position.x = pos
		else :
			get_child(index).position.x = lerp(get_child(index).position.x,pos+distance,0.2)
		

