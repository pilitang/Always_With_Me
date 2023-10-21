extends BaseControl

@onready var sendContent = find_child("sendContent")

signal text_changed(data)

var text_size = 60
var isShow = false

var last_max_value= 1
var total = 0
func _ready():
	sendContent.grab_focus()
	last_max_value = sendContent.get_h_scroll_bar().max_value
	
	
func _process(delta):
	total = sendContent.get_line_count()
	for i in sendContent.get_line_count():
		total += sendContent.get_line_wrap_count(i)
	if total < 4:
		sendContent.size.y = sendContent.custom_minimum_size.y+text_size * (total-1) 
	else:
		sendContent.size.y = sendContent.custom_minimum_size.y+text_size * 3
	sendContent.position.y = size.y - sendContent.size.y - SysUtil.get_virtual_height()
	if SysUtil.isMobile() and isShow  :
		if SysUtil.get_virtual_height() <= 0:
			super.queue_free()
	else :
		if SysUtil.get_virtual_height() > 0 :
			isShow = true

func _on_sendContent_text_changed():
	if last_max_value != sendContent.get_h_scroll_bar().max_value :
		if total < 4:
			sendContent.scroll_vertical = 0
		else :
			sendContent.scroll_vertical = int(sendContent.get_h_scroll_bar().max_value)-4
	last_max_value = sendContent.get_h_scroll_bar().max_value
	emit_signal("text_changed",sendContent.text)

func _on_bg_on_click(node):
	super.queue_free()
		
