class_name CommonRefresh
extends Container

signal refresh
signal load_more


var isRefreshing : bool = false
var isLoading : bool = false

var distance :int = 0 :
	set(value):
		distance = value
		if header != null : header.offset = value
		if footer != null : footer.offset = value
		queue_redraw()
		
var header : RefreshInterface = null
var footer : RefreshInterface = null

	
var speed = 0.01
const startOffset : int = 120 
const dragLimit : int = 4
var dragCount : int = 0
var dragOffset :Vector2 = Vector2.ZERO
@onready var scroll : CommonScrollContainer = get_child(0)


func _ready():
	init_node()

func init_node():
	if header == null:
		header = load("res://common/gui/common_refresh_header.tscn").instantiate()
		add_child(header)
#	if footer == null:
#		footer = load("res://common/gui/common_refresh_loader.tscn").instantiate()
#		add_child(footer)
	scroll.connect("load_more",Callable(self,"need_load_more"))


func _gui_input(event):
	if scroll.canRefresh()  :
		if event is InputEventScreenDrag and not isRefreshing and not isLoading :
			if dragCount < dragLimit :
				dragOffset += event.relative
			dragCount +=1
			var offset = distance + event.velocity.y*speed
			if dragCount>=dragLimit and  abs(dragOffset.x) < abs(dragOffset.y) and  ( ( offset >0 and scroll.canRefresh() ) ) :
				distance = offset
		if event is InputEventScreenTouch :
			dragCount = 0
			dragOffset = Vector2.ZERO
			if event.pressed == true :
				if not (isRefreshing or isLoading):
					reset()
			if event.pressed == false :
				if distance >= startOffset and  scroll.canRefresh() :
					isRefreshing = true
					if header != null : 
						header.status = 1 
						distance = int(header.custom_minimum_size.y) 
					else :
						reset()
					emit_signal("refresh")
				else :
					reset()

func _process(_delta):
	position.y = distance

func reset():
	distance = 0
	if header != null : header.status = 0 
	if footer != null : footer.status = 0 
	
func finishRefresh():
	isRefreshing = false
	reset()


func finishLoad():
	isLoading = false
	reset()

func need_load_more():
	if isLoading :
		return
	isLoading = true
	if footer != null : 
		footer.status = 1 
#		distance = -footer.custom_minimum_size.y 
	else :
		reset()
	emit_signal("load_more")
