class_name DaySelect
extends BaseControl

var daylist = []




@onready var days = find_child("days")
@onready var core = find_child("core")
@onready var dialogControl = find_child("dialogControl")
@onready var common_title = find_child("common_title")
@onready var display_days = find_child("display_days")
var itemNode = load("res://common/gui/date/date_select_item.tscn")
var days_num = 3
const prefabricationList = [1,2,3,4,5,6,7,14,21,
30,60,90,182,365,730,1095,1460,1825]
static func get_day_num(value:int)->String:
	match value:
		1:
			return "一天"
		2:
			return "两天"
		3:
			return "三天"
		4:
			return "四天"
		5:
			return "五天"
		6:
			return "六天"
		7:
			return "一周"
		14:
			return "两周"
		21:
			return "三周"
		30:
			return "一个月"
		60:
			return "两个月"
		90:
			return "三个月"
		182:
			return "半年"
		365:
			return "一年"
		730:
			return "两年"
		1095:
			return "三年"
		1460:
			return "四年"
		1825:
			return "五年"
	return "未知"

func _ready():
	super._ready()
	days.spacing = itemNode.instantiate().size.y
	
	
	
	days_change(prefabricationList.find(days_num))
	for i in prefabricationList:
		add_label_node(get_day_num(i),days,"",daylist)
	data_change(days,daylist,"",prefabricationList.size()-1,"days_change",str(prefabricationList.find(days_num)))
	pass

func days_change(data):
	days_num = prefabricationList[int(data)]
	display_days.text  = get_day_num(int(days_num))
	
func add_label_node(text:String,add_child_node,company,data_list):
	var label = itemNode.instantiate()
	label.data = text+company
	add_child_node.add_child(label)
	data_list.append(label)

func data_change(node,data_list,company,max_data,connect_text,current_time:String = "7"):
	node.select_data = current_time
	node.core = core
	node.data_list = data_list
	node.max_data = max_data
	node.connect("change",Callable(self,connect_text))

func _on_cancel_on_click(node):
	super.queue_free()

func _on_confirm_on_click(node):
	emit_signal("result_data",days_num)
	super.queue_free()
