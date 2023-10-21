@tool
class_name CommonImageText
extends BaseControl
@export var state0_image :Resource
@export var state0_text :String = ""

@export var state1_image :Resource
@export var state1_text :String = ""
@export var text_size :int =28
@export var text_color :Color = Color.WHITE
var state = 0 :
	set(value):
		state = value
		match value :
			0 :
				%icon.texture = state0_image
				%content.text = state0_text
			1 :
				%icon.texture = state1_image
				%content.text = state1_text

func _ready():
	%icon.texture = state0_image
	%content.text = state0_text
	%content.add_theme_font_size_override("font_size", text_size)
	%content.modulate = text_color
	if state0_text.is_empty() : %content.visible = false
