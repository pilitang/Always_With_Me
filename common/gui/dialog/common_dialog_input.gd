extends BaseDialog

@onready var bg:BaseControl = find_child("bg")
@onready var title : Label = find_child("title")
@onready var content = find_child("content")
@onready var confirm = find_child("confirm")
@onready var cancel = find_child("cancel")
@onready var dialogControl = find_child("dialogControl")

func _ready():
	if cancelOutside:
		bg.connect("on_click",Callable(self,"_on_cancel_on_click"))
	content.grab_focus()
	
	
func _on_cancel_on_click(node):
	emit_signal("result_data","")
	super.queue_free()

func _on_confirm_on_click(node):
	emit_signal("result_data",content.text)
	if confirmQuit:
		super.queue_free()
		
func queue_free():
	super.queue_free()
	
func _process(delta):
	if SysUtil.isMobile() :
		if DisplayServer.virtual_keyboard_get_height()>0 :
			dialogControl.anchor_bottom = 0.2
			dialogControl.anchor_top = 0.2
		else :
			dialogControl.anchor_bottom = 0.5
			dialogControl.anchor_top = 0.5
