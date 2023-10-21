extends BaseControl

@export var select : bool = false 
		
var speed = 0.5
var interval = 3.0

@onready var yuan = find_child("yuan")
var switch_close = preload("res://common/gui/stylebox/switch_close.stylebox")
var	switch_open = preload("res://common/gui/stylebox/switch_open.stylebox")

func _process(delta):
	if (int(yuan.position.x+0.5) != interval ) or (int(yuan.position.x+0.5) != int(size.x - interval - yuan.size.x+0.5)):
		if !select:
			styleBox = switch_close
			yuan.position.x = lerp(yuan.position.x,interval,speed)
		else:
			styleBox = switch_open
			yuan.position.x = lerp(yuan.position.x,size.x - interval - yuan.size.x,speed)

