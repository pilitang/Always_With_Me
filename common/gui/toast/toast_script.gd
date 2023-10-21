class_name Toast
extends Control
signal done

enum {
	LENGTH_SHORT,
	LENGTH_LONG
}

var labelText
var toastDuration
var style

#Nodes
var label
var timer
var animation

func _init(text: String = "",duration:= LENGTH_SHORT,mstyle: ToastStyle =ToastStyle.new()):
	labelText = text
	toastDuration = duration
	if mstyle is ToastStyle:
		style = mstyle;
	else:
		printerr("Expected ToastStyle resource. Using default style")

func _ready():
	#Setting itself
	visible = false
# TODO: fix
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = MOUSE_FILTER_IGNORE

	#Setting the label
	label = Label.new()
	label.add_theme_font_size_override("font_size", 36)
	label.add_theme_color_override("font_color",style.fontColor)
	var styleBoxParser = StyleBoxFlat.new()
	styleBoxParser.bg_color = style.backgroundColor
	styleBoxParser.content_margin_bottom = style.contentMarginBottom
	styleBoxParser.content_margin_left = style.contentMarginLeft
	styleBoxParser.content_margin_right = style.contentMarginRight
	styleBoxParser.content_margin_top = style.contentMarginTop
	styleBoxParser.corner_radius_bottom_left = style.cornerRadius
	styleBoxParser.corner_radius_bottom_right = style.cornerRadius;
	styleBoxParser.corner_radius_top_left = style.cornerRadius;
	styleBoxParser.corner_radius_top_right = style.cornerRadius;
	label.add_theme_stylebox_override("normal", styleBoxParser);


	label.text = labelText;
	match style.position:
		ToastStyle.Position.Bottom:
			if style.toastType == ToastStyle.Type.Float:
				label.anchor_bottom = 1.0; 
				label.anchor_top = 1.0;
				label.anchor_left = 0.5;
				label.anchor_right = 0.5;
				label.offset_bottom = -200;
			elif style.toastType == ToastStyle.Type.Full:
				label.anchor_bottom = 1.0;
				label.anchor_top = 1.0;
				label.anchor_left = 0;
				label.anchor_right = 1;
				label.offset_bottom = 0;
			label.grow_vertical = 0;
		ToastStyle.Position.Top:
			if style.toastType == ToastStyle.Type.Float:
				label.anchor_bottom = 0;
				label.anchor_top = 0;
				label.anchor_left = 0.5;
				label.anchor_right = 0.5;
				label.offset_top = 200;
			elif style.toastType == ToastStyle.Type.Full:
				label.anchor_bottom = 0;
				label.anchor_top = 0;
				label.anchor_left = 0;
				label.anchor_right = 1;
				label.offset_top = 0;
			label.grow_vertical = 1;
	label.grow_horizontal = 2;
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER;
	add_child(label);

	#Setting the timer
	timer = Timer.new();
	timer.one_shot = true;
	match toastDuration:
		LENGTH_SHORT:
			timer.wait_time = 0.5;
		LENGTH_LONG:
			timer.wait_time = 2;
	add_child(timer)
	#Setting the animation
	animation = AnimationPlayer.new();
	var library = AnimationLibrary.new()
	library.add_animation("start", load("res://common/gui/toast/animations/start.anim"))
	library.add_animation("end", load("res://common/gui/toast/animations/end.anim"))
	animation.add_animation_library("",library)
	add_child(animation)

func show():
	if animation != null:
		animation.play("start")
	# warning-ignore:return_value_discarded
		animation.connect("animation_finished",Callable(self,"_animationEnded").bind("startAnimation"))
		visible = true
	else : 
		super.show()

func _animationEnded(_a, whichAnimation): #_a ignores the argument passed from the animation player
	if whichAnimation == "startAnimation":
		timer.start();
# warning-ignore:return_value_discarded
		timer.connect("timeout",Callable(self,"_animationEnded").bind(null, "endAnimation"))
	elif whichAnimation == "endAnimation":
		animation.play("end")
# warning-ignore:return_value_discarded
		animation.disconnect("animation_finished",Callable(self,"_animationEnded"))
		animation.connect("animation_finished",Callable(self,"_done"))

func _done(_a):
	animation.remove_animation_library("")
	super.queue_free()
	emit_signal("done")
