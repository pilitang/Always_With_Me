extends BaseControl

@onready var year = find_child("year")
@onready var month = find_child("month")
@onready var day = find_child("day")
@onready var commonRoundedRectangle = find_child("day")
@onready var display_date = find_child("display_date")
@onready var core = find_child("core")
@onready var dialogControl = find_child("dialogControl")
var itemNode = load("res://common/gui/date/date_select_item.tscn")
var year_list = []
var month_list = []
var day_list = []

var spacing = 0

var birthday = false

var if_change = true
var year_text = str(Time.get_datetime_dict_from_system().year)
var month_text = str(Time.get_datetime_dict_from_system().month)
var day_text = str(Time.get_datetime_dict_from_system().day)
#var date = str(OS.get_date().year)+"年"+str(OS.get_date().month)+"月"+str(OS.get_date().day)+"日" : set = dateset
var date = [str(Time.get_datetime_dict_from_system().year),str(Time.get_datetime_dict_from_system().month),str(Time.get_datetime_dict_from_system().day)] :
	set(value):
		date = value
		year_text = value[0]
		month_text = value[1]
		day_text = value[2]
	
#	emit_signal("date_change",date)
	
func _process(delta):
	commonRoundedRectangle.size.y = 300
	display_date.text = date[0]+"年"+date[1]+"月"+date[2]+"日"
	
func _ready():
	super._ready()
	year.year_text = date[0]
	month.month_text = date[1]
	day.day_text = date[2]
	
	spacing = itemNode.instantiate().size.y
	
	if year.get_child_count() ==0:
		if birthday:
			for i in 101:
				var label = itemNode.instantiate()
				
				label.text = str((Time.get_datetime_dict_from_system().year-100)+i)+"年"
				year.add_child(label)
				year_list.append(label)
		else:
			for i in 11:
				var label = itemNode.instantiate()
				
				label.text = str(Time.get_datetime_dict_from_system().year+i)+"年"
				year.add_child(label)
				year_list.append(label)
	year.core = core
	year.year_list = year_list
	year.spacing = spacing
	month.spacing = spacing
	day.spacing = spacing
	year.connect("change",Callable(self,"change_year"))
	month.connect("change",Callable(self,"change_month"))
	day.connect("change",Callable(self,"change_day"))
	change_year(year_text)
	pass # Replace with function body.

func change_year(data):
	year_text = data
	if data == str(Time.get_datetime_dict_from_system().year):
		if int(month_text) <  Time.get_datetime_dict_from_system().month:
			month_text = str(Time.get_datetime_dict_from_system().month)
		if_change = true
		add_month(Time.get_datetime_dict_from_system().month,12)
	else:
		if if_change == true:
			add_month(1,12)
			if_change = false
	change_month(month_text)
	self.date =[year_text,month_text,day_text]
	
var if_change_day = "0"#上一次最大天数,如果一样就不更改
func change_month(data):
	
	month_text = data
	if year_text == str(Time.get_datetime_dict_from_system().year) and month_text == str(Time.get_datetime_dict_from_system().month):
		if int(month_text) in [1,3,5,7,8,10,12]:

				
				if_change_day = "31"
				add_day(Time.get_datetime_dict_from_system().day,31)
				
		elif int(month_text) == 2:
			if (int(year_text)%4 == 0 and int(year_text)%100 != 0) or (int(year_text)%400 == 0):
#				if if_change_day != "29":
					if_change_day = "29"
					add_day(Time.get_datetime_dict_from_system().day,29)
			else:
#				if if_change_day != "28":
					if_change_day = "28"
					add_day(Time.get_datetime_dict_from_system().day,28)
		else:
#			if if_change_day != "30":
				if_change_day = "30"
				add_day(Time.get_datetime_dict_from_system().day,30)
	else:
		if int(month_text) in [1,3,5,7,8,10,12]:
#			if if_change_day != "31":
				if_change_day = "31"
				add_day(1,31)
		elif int(month_text) == 2:
			if (int(year_text)%4 == 0 and int(year_text)%100 != 0) or (int(year_text)%400 == 0):
#				if if_change_day != "29":
					if_change_day = "29"
					add_day(1,29)
			else:
#				if if_change_day != "28":
					if_change_day = "28"
					add_day(1,28)
		else:
#			if if_change_day != "30":
				if_change_day = "30"
				add_day(1,30)
	self.date =[year_text,month_text,day_text]
	
func change_day(data):
	day_text = data
	self.date =[year_text,month_text,day_text]
	
	
func add_month(start:int ,end :int):
	for i in month.get_child_count():
		month.get_child(i).queue_free()
		month_list = []
	for i in end+1-start:
		var label = itemNode.instantiate()
		label.text = str(i+start)+"月"
		month.year_text = year_text
		month.add_child(label)
		month_list.append(label)
	month.core = core
	
	month.month_list = month_list

func add_day(start:int ,end :int):
	for i in day.get_child_count():
		day.get_child(i).queue_free()
		day_list = []
	for i in end+1-start:
		var label = itemNode.instantiate()
		label.text = str(i+start)+"日"
		day.year_text = year_text
		day.month_text = month_text
		day.add_child(label)
		day_list.append(label)
	day.max_day = int(if_change_day)
	day.core = core
	day.day_list = day_list


func _on_cancel_on_click(node):
	super.queue_free()


func _on_confirm_on_click(node):
	emit_signal("result_data",date)
	super.queue_free()
