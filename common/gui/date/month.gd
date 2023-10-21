extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal change(month)


var distance : float = 0
var step = 5
var month_list = []
var month_text = str(Time.get_datetime_dict_from_system().month) :
	set(value):
		month_text = value
		emit_signal("change",month_text)

var month = self
var core = null
var year_text = "" 
var spacing = 0
var separation = 4 

# Called when the node enters the scene tree for the first time.
func _ready():
	separation = 4 if get("theme_override_constants/separation") == null else get("theme_override_constants/separation")
	
#	self.month_text = 
	
	pass # Replace with function body.

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
			if int(year_text)==Time.get_datetime_dict_from_system().year:
				if int(month_text) > Time.get_datetime_dict_from_system().month:
					self.month_text = str(int(month_text)-1)
			else:
				if int(month_text) > 1:
					self.month_text = str(int(month_text)-1)
		if distance<-step:
			distance +=step
			if int(month_text) < 12:
				self.month_text = str(int(month_text)+1)
	
	for i in month_list.size():
		
		if month_list[i].text == month_text+"月":
			month.position.y = core.position.y- month_list[i].position.y
			month_list[i].obvious = true
			return
		else:
			month.position.y = core.position.y-month_list[i].position.y


