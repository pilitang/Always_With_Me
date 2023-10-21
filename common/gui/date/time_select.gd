extends BaseControl

var hours_list = []
var minutes_list = []
@onready var hours = find_child("hours")
@onready var minutes = find_child("minutes")
@onready var core = find_child("core")
var hour_text  = "20"
var minute_text = "00"
var time_text = "" : set = time_text_set
@onready var display_time = find_child("display_time")
@onready var common_title = find_child("common_title")

@onready var dialogControl = find_child("dialogControl")

var itemNode = load("res://common/gui/date/date_select_item.tscn")
var spacing = 0
func bg_click(data):
	super.queue_free()
func time_text_set(time):
	time_text = time
	display_time.text =time_text

func _ready():
	super._ready()
	spacing = itemNode.instantiate().size.y
	self.time_text = str(hour_text)+"时"+str(minute_text)+"分"
	for i in 25:
		add_label_node(str("%02d" % [i]),hours,"时",hours_list)
	for i in 60:
		add_label_node(str("%02d" % [i]),minutes,"分",minutes_list)
	data_change(hours,hours_list,24,"hours_change",str(hour_text))
	data_change(minutes,minutes_list,59,"minutes_change",str(minute_text))

func hours_change(data):
	hour_text = data
	self.time_text = hour_text+"时"+minute_text+"分"
	
func minutes_change(data):
	minute_text = data
	self.time_text = hour_text+"时"+minute_text+"分"
	
func data_change(node,data_list,max_data,connect_text,current_time:String = "0"):
	node.select_data = current_time
	node.core = core
	node.data_list = data_list
	node.max_data = max_data
	node.spacing = spacing
	node.connect("change",Callable(self,connect_text))
	
func add_label_node(text:String,add_child_node,company,data_list):
	var label = itemNode.instantiate()
	label.data = text+company
	add_child_node.add_child(label)
	data_list.append(label)

func _on_confirm_on_click(node):
	
	emit_signal("result_data",[hour_text,minute_text])
	super.queue_free()

func _on_cancel_on_click(node):
	super.queue_free()

func queue_free():
	dialogControl.playExit()
	super.queue_free()
