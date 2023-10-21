extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal change(year)


var distance :float = 0.0
var step = 5
var year_list = []
var year_text = str(Time.get_datetime_dict_from_system().year) :
	set(value):
		year_text = value
		emit_signal("change",year_text)

var year = self
var core = null
var spacing = 0
var separation = 4 

# Called when the node enters the scene tree for the first time.
func _ready():
#	self.year_text = 
	separation = 4 if get("theme_override_constants/separation") == null else get("theme_override_constants/separation")
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
			
			if int(year_text) > int(year_list[0].text):
				self.year_text = str(int(year_text)-1)
		if distance<-step:
			distance +=step
			if int(year_text) < int(year_list.back().text):
				self.year_text = str(int(year_text)+1)
	for i in year_list.size():
		if year_list[i].text == year_text+"年":
			year_list[i].obvious = true
			year.position.y = core.position.y-year_list[i].position.y
			return

