extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal change(data)
var select_data = "00" : set = select_data_set
var distance : float = 0
var step = 5
var data_list = []
var max_data = 0
var core = null

var spacing = 0
var separation = 4 
# Called when the node enters the scene tree for the first time.
func _ready():
	separation = 4 if get("theme_override_constants/separation") == null else get("theme_override_constants/separation")
	pass # Replace with function body.
func select_data_set(data):
	select_data = str("%02d" % [int(data)])
	emit_signal("change",select_data)
func _input(event):
	if event is InputEventScreenDrag:
		if event.position.x > global_position.x and event.position.y > global_position.y:
			if event.position.x < global_position.x+size.x and event.position.y < global_position.y+size.y:
				distance = event.relative.y

func _process(delta):
	distance =  lerp(distance,0.0,0.1)
	if abs(distance) < 0.1:
		distance = 0
	if distance!= 0:
		if distance>step:
			distance -=step
			if int(select_data) > 0:
				self.select_data = str(int(select_data)-1)
		if distance<-step:
			distance +=step
			if int(select_data) < max_data:
				self.select_data = str(int(select_data)+1)
	for i in data_list.size():
		if data_list[i].text == data_list[int(select_data)].text:
			data_list[i].obvious = true
			self.position.y = core.position.y-data_list[i].position.y
			return
