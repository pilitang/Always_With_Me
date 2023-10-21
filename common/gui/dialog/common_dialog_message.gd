extends BaseDialog
var isRichContent = false
var content = ""
var line_char_num = 22
var isIncrease = false
var confirmText = "确定"
var cancelText ="取消"

@onready var richLabel = %richLabel

func _ready():
	super._ready()
	%confirm.text = confirmText
	%cancel.text = cancelText
	if isRichContent or content.length() > line_char_num*3:
		%richLabel.visible = true
		%contentLabel.visible = false
		if content.length() <= line_char_num :
			%richLabel.text ="[fill][center]"+content +"[/center][/fill]"
		elif content.length() <= line_char_num*3:
			%richLabel.text ="[fill]"+content +"[/fill]"
		else :
			%richLabel.text =content
	else :
		%richLabel.visible = false
		%contentLabel.visible = true
		%contentLabel.text = content
		if content.length() <= line_char_num :
			%contentLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		else :
			%contentLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			
	if cancelOutside:
		%bg.connect("on_click",Callable(self,"_on_cancel_on_click"))
	if isIncrease:
		%dialogue.custom_minimum_size.y = 700
		%dialogue.size.y = 700
	else:
		%dialogue.custom_minimum_size.y = 457
		%dialogue.size.y = 457


func _on_cancel_on_click(node):
	emit_signal("result_data",false)
	super.queue_free()
	
func _on_confirm_on_click(node):
	emit_signal("result_data",true)
	if confirmQuit:
		super.queue_free()
	
