extends BaseControl

@onready var scrollBar:HScrollBar = find_child("HScrollBar")
@export var isEnabled = true : set = isEnabled_set

func isEnabled_set(value):
	isEnabled = value
	scrollBar.set("theme_override_styles/grabber",load("res://gstylebox/circular_white.stylebox") if isEnabled else load("res://gstylebox/circular_grey.stylebox"))
	pass

func _gui_input(event):
	if isEnabled :
		if event is InputEventScreenDrag or (event is InputEventScreenTouch and not event.pressed):
			scrollBar.value = event.position.x / scrollBar.size.x * scrollBar.max_value
			emit_signal("result_data",scrollBar.value)

func get_percent() -> int:
	return int((scrollBar.value / scrollBar.max_value) * 100)
	
func get_percent_str() -> String:
	return str(get_percent()) + "%"
func set_percent(value):
	scrollBar.value  = value
	emit_signal("result_data",scrollBar.value)
