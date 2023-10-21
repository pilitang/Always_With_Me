extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal change(day)
var distance :float = 0
var step = 5
var day_list = []
var day_text = str(Time.get_datetime_dict_from_system().day) : 
	set(value):
		day_text = value
		emit_signal("change",day_text)

var day = self
var core = null
var year_text = "" 
var month_text = "" 
var max_day = 0
var spacing = 0

var separation = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	
	separation = 4 if get("theme_override_constants/separation") == null else get("theme_override_constants/separation")
	
#	day_text =  
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
			
			if int(year_text)==Time.get_datetime_dict_from_system().year and int(month_text)==Time.get_datetime_dict_from_system().month:
				
				if int(day_text) > Time.get_datetime_dict_from_system().day:
					
					self.day_text = str(int(day_text)-1)
				else:
					self.day_text = str(Time.get_datetime_dict_from_system().day)
			else:
				if int(day_text) > 1:
					self.day_text = str(int(day_text)-1)
		if distance<-step:
			distance +=step
			if int(day_text) < max_day:
				
				self.day_text = str(int(day_text)+1)
	
	for i in day_list.size():
		
		if day_list[i].text == day_text+"日":
			day.position.y = core.position.y-day_list[i].position.y
			day_list[i].obvious = true
			return
		else:
			
			day.position.y = core.position.y-day_list[i].position.y
